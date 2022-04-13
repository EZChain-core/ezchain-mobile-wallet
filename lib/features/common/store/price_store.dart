import 'dart:async';

import 'package:async/async.dart';
import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/storage.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/explorer/price/requests.dart';
import 'package:wallet/ezc/wallet/explorer/price/types.dart';
import 'package:wallet/ezc/wallet/network/utils.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/store/token_store.dart';

part 'price_store.g.dart';

@LazySingleton()
class PriceStore = _PriceStore with _$PriceStore;

abstract class _PriceStore with Store {
  static const currencyKey = "CURRENCY_KEY";

  final _tokenStore = getIt<TokenStore>();

  @readonly
  //ignore: prefer_final_fields
  ObservableMap<String, EzcPrice> _prices = ObservableMap.of({});

  @computed
  Decimal get ezcPrice =>
      _prices[ezcSymbol.toLowerCase()]?.currentPriceDecimal ?? Decimal.zero;

  @readonly
  //ignore: prefer_final_fields
  Observable<EzcCurrency> _ezcCurrency = Observable(EzcCurrency.USD);

  Timer? _timer;

  CancelableCompleter<Map<String, EzcPrice>>? _completer;

  final _contractAddresses = {getAvaxAssetId()};

  _PriceStore() {
    storage.read(key: currencyKey).then((value) {
      _ezcCurrency.value = CurrencyExt.getByType(value);

      _tokenStore.antAssets.observe((listChange) {
        if (listChange.list.isNotEmpty) {
          final contractAddresses = listChange.list.map((token) => token.id);
          _contractAddresses.addAll(contractAddresses);
          updatePrice();
        }
      });

      _tokenStore.erc20Tokens.observe((listChange) {
        if (listChange.list.isNotEmpty) {
          final contractAddresses =
              listChange.list.map((token) => token.contractAddress);
          _contractAddresses.addAll(contractAddresses);
          updatePrice();
        }
      });

      _ezcCurrency.observe((changeNotification) {
        final currency = changeNotification.newValue;
        if (currency != null) {
          updatePrice();
        }
      });
    });
  }

  updatePrice() {
    if (_contractAddresses.isEmpty) {
      _contractAddresses.add(getAvaxAssetId());
    }
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (timer.isActive &&
          (_completer == null || _completer?.isCompleted == true)) {
        _fetchPrice();
      }
    });
    _fetchPrice();
  }

  Decimal getPrice(String symbol) {
    return _prices[symbol.toLowerCase()]?.currentPriceDecimal ?? Decimal.zero;
  }

  @action
  dispose() {
    _completer?.operation.cancel();
    _timer?.cancel();
    _contractAddresses.clear();
    _prices.clear();
  }

  @action
  Future<bool> saveCurrency(EzcCurrency currency) async {
    try {
      await storage.write(key: currencyKey, value: currency.type);
      _ezcCurrency.value = currency;
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  @action
  _fetchPrice() {
    _completer = CancelableCompleter();
    _completer?.operation.value.then((value) {
      _prices.clear();
      _prices.addAll(value);
    }, onError: (e) {
      logger.e(e);
    });
    final future = fetchEzcPrices(
      _contractAddresses.toList(),
      _ezcCurrency.value.type,
    );
    _completer?.complete(future);
  }
}

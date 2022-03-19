import 'dart:async';

import 'package:async/async.dart';
import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
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
  final _tokenStore = getIt<TokenStore>();

  @readonly
  //ignore: prefer_final_fields
  ObservableMap<String, EzcPrice> _prices = ObservableMap.of({});

  @computed
  Decimal get ezcPrice =>
      _prices[ezcSymbol.toLowerCase()]?.currentPriceDecimal ?? Decimal.zero;

  Timer? _timer;

  CancelableCompleter<Map<String, EzcPrice>>? _completer;

  final _contractAddresses = {getAvaxAssetId()};

  _PriceStore() {
    _tokenStore.antAssets.observe((tokens) {
      if (tokens.list.isNotEmpty) {
        final contractAddresses = tokens.list.map((token) => token.id);
        _contractAddresses.addAll(contractAddresses);
        updatePrice();
      }
    });

    _tokenStore.erc20Tokens.observe((tokens) {
      if (tokens.list.isNotEmpty) {
        final contractAddresses =
            tokens.list.map((token) => token.contractAddress);
        _contractAddresses.addAll(contractAddresses);
        updatePrice();
      }
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
  _fetchPrice() {
    _completer = CancelableCompleter();
    _completer?.operation.value.then((value) {
      _prices.clear();
      _prices.addAll(value);
    }, onError: (e) {
      logger.e(e);
    });
    final future = fetchEzcPrices(_contractAddresses.toList());
    _completer?.complete(future);
  }
}

import 'dart:async';

import 'package:async/async.dart';
import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/explorer/coingecko/requests.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/store/token_store.dart';

part 'price_store.g.dart';

@LazySingleton()
class PriceStore = _PriceStore with _$PriceStore;

abstract class _PriceStore with Store {
  final _tokenStore = getIt<TokenStore>();

  @readonly
  ObservableMap<String, Decimal> _prices = ObservableMap.of({});

  @computed
  Decimal get avaxPrice => _prices[ezcCode.toLowerCase()] ?? Decimal.zero;

  Timer? _timer;

  CancelableCompleter<Decimal>? _completer;

  updatePrice() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (timer.isActive &&
          (_completer == null || _completer?.isCompleted == true)) {
        _fetchPrice();
      }
    });
    _fetchPrice();
  }

  @action
  dispose() {
    _completer?.operation.cancel();
    _timer?.cancel();
    _prices.clear();
  }

  @action
  _fetchPrice() {
    _completer = CancelableCompleter();
    _completer?.operation.value.then((value) {
      _prices[ezcCode.toLowerCase()] = value;
    }, onError: (e) {
      logger.e(e);
    });
    _completer?.complete(getAvaxPriceDecimal());
  }
}

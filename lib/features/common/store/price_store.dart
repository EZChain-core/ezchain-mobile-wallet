import 'dart:async';

import 'package:async/async.dart';
import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/explorer/coingecko/requests.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'balance_store.dart';

part 'price_store.g.dart';

@LazySingleton()
class PriceStore = _PriceStore with _$PriceStore;

abstract class _PriceStore with Store {
  final _tokenStore = getIt<TokenStore>();

  @observable
  Decimal avaxPrice = Decimal.zero;

  @observable
  ObservableMap<String, Decimal> prices = ObservableMap.of({});

  Timer? _timer;

  CancelableCompleter? _completer;

  _PriceStore() {
    // _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //   logger.e("KIEN: tick = ${timer.tick}");
    // });
  }

  @action
  updateAvaxPrice() async {
    try {
      avaxPrice = await getAvaxPriceDecimal();
    } catch (e) {
      logger.e(e);
    }
  }

  String getBalanceInUsd(Decimal balance) {
    final balanceUsd = balance * avaxPrice;
    return decimalToLocaleString(balanceUsd, decimals: decimalNumber);
  }

  @action
  dispose() {
    _timer?.cancel();
  }
}

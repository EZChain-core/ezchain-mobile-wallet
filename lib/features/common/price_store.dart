import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';
import 'package:wallet/roi/wallet/utils/price_utils.dart';

import 'balance_store.dart';

part 'price_store.g.dart';

@LazySingleton()
class PriceStore = _PriceStore with _$PriceStore;

abstract class _PriceStore with Store {
  @observable
  Decimal avaxPrice = Decimal.zero;

  @action
  updateAvaxPrice() async {
    avaxPrice = await getAvaxPriceDecimal();
  }

  String getBalanceInUsd(Decimal balance) {
    final balanceUsd = balance * avaxPrice;
    return decimalToLocaleString(balanceUsd, decimals: decimalNumber);
  }
}

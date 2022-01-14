import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/utils/price_utils.dart';

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
}

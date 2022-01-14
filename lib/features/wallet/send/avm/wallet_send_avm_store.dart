import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/wallet/helpers/address_helper.dart';
import 'package:wallet/roi/wallet/utils/fee_utils.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

part 'wallet_send_avm_store.g.dart';

class WalletSendAvmStore = _WalletSendAvmStore with _$WalletSendAvmStore;

abstract class _WalletSendAvmStore with Store {
  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();

  @computed
  Decimal get avaxPrice => _priceStore.avaxPrice;

  @computed
  Decimal get balanceX => _balanceStore.balanceX;

  String get balanceXString => _balanceStore.balanceXString;

  @observable
  String? addressError;

  @observable
  String? amountError;

  @observable
  Decimal amount = Decimal.zero;

  @observable
  Decimal fee = Decimal.zero;

  @observable
  Decimal total = Decimal.zero;

  @action
  getBalanceX() async {
    _balanceStore.updateBalanceX();
    _priceStore.updateAvaxPrice();
    fee = bnToDecimalAvaxX(getTxFeeX());
    total = avaxPrice * fee;
  }

  @action
  bool validate(String address) {
    final isAddressValid = validateAddressX(address);
    final isAmountValid =
        _balanceStore.balanceX >= (amount + fee) && amount > Decimal.zero;
    if (!isAddressValid) {
      addressError = Strings.current.sharedInvalidAddress;
    }
    if (!isAmountValid) {
      amountError = Strings.current.sharedInvalidAmount;
    }
    return isAddressValid && isAmountValid;
  }

  @action
  removeAmountError() {
    if (amountError != null) {
      amountError = null;
    }
  }

  @action
  removeAddressError() {
    if (addressError != null) {
      addressError = null;
    }
  }

  @action
  updateTotal(Decimal amount) {
    total = (amount + fee) * avaxPrice;
  }
}

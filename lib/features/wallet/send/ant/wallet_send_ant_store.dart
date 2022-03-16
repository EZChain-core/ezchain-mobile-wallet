import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/ezc/wallet/helpers/address_helper.dart';
import 'package:wallet/ezc/wallet/utils/fee_utils.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';
import 'package:wallet/generated/l10n.dart';

part 'wallet_send_ant_store.g.dart';

class WalletSendAntStore = _WalletSendAntStore with _$WalletSendAntStore;

abstract class _WalletSendAntStore with Store {
  WalletTokenItem? token;

  Decimal get balanceToken => token?.amount ?? Decimal.zero;

  @observable
  String? addressError;

  @observable
  String? amountError;

  @observable
  Decimal amount = Decimal.zero;

  @observable
  Decimal fee = bnToDecimalAvaxX(getTxFeeX());

  @computed
  Decimal get total => (amount + fee) * (token?.price ?? Decimal.zero);

  setToken(WalletTokenItem token) {
    this.token = token;
  }

  @action
  bool validate(String address) {
    final isAddressValid = validateAddressX(address);
    final isAmountValid =
        balanceToken >= (amount + fee) && amount > Decimal.zero;
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
}

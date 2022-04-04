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

  Decimal get balanceToken => token?.balance ?? Decimal.zero;

  @readonly
  String? _addressError;

  @readonly
  String? _amountError;

  @observable
  Decimal amount = Decimal.zero;

  @readonly
  Decimal _fee = bnToDecimalAvaxX(getTxFeeX());

  @computed
  Decimal get total => (amount + _fee) * (token?.price ?? Decimal.zero);

  setToken(WalletTokenItem token) {
    this.token = token;
  }

  @action
  bool validate(String address) {
    final isAddressValid = validateAddressX(address);
    final isAmountValid =
        balanceToken >= (amount + _fee) && amount > Decimal.zero;
    if (!isAddressValid) {
      _addressError = Strings.current.sharedInvalidAddress;
    }
    if (!isAmountValid) {
      _amountError = Strings.current.sharedInvalidAmount;
    }
    return isAddressValid && isAmountValid;
  }

  @action
  removeAmountError() {
    if (_amountError != null) {
      _amountError = null;
    }
  }

  @action
  removeAddressError() {
    if (_addressError != null) {
      _addressError = null;
    }
  }
}

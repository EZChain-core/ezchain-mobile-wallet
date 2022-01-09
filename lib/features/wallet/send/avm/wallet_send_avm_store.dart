import 'package:mobx/mobx.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/wallet/helpers/address_helper.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';
import 'package:wallet/roi/wallet/utils/price_utils.dart';

part 'wallet_send_avm_store.g.dart';

class WalletSendAvmStore = _WalletSendAvmStore with _$WalletSendAvmStore;

abstract class _WalletSendAvmStore with Store {
  final wallet = SingletonWallet(
      privateKey:
          "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  @observable
  String balanceX = '0';

  @observable
  double avaxPrice = 0;

  @observable
  String? addressError;

  @observable
  String? amountError;

  @observable
  double fee = 0.001;

  @observable
  double total = 0;

  double get balanceXDouble => double.tryParse(balanceX.replaceAll(',', '')) ?? 0;

  @action
  getBalanceX() async {
    await wallet.updateUtxosX();
    wallet
        .getBalanceX()
        .forEach((_, balance) => {balanceX = balance.unlockedDecimal});

    avaxPrice = (await getAvaxPrice()).toDouble();
    total = avaxPrice * fee;
  }

  @action
  bool validate(String address, double amount) {
    final isAddressValid = validateAddressX(address);
    final isAmountValid = balanceXDouble > amount && amount > 0;
    if(!isAddressValid) {
      addressError = Strings.current.sharedInvalidAddress;
    }
    if(!isAmountValid) {
      amountError = Strings.current.sharedInvalidAmount;
    }
    return isAddressValid && isAmountValid;
  }

  @action
  removeAmountError() {
    if(amountError != null) {
      amountError = null;
    }
  }

  @action
  removeAddressError() {
    if(addressError != null) {
      addressError = null;
    }
  }

  @action
  updateTotal(double amount) {
    total = (amount + fee) * avaxPrice;
  }
}

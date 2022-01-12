import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/wallet/helpers/address_helper.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/utils/fee_utils.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';
import 'package:wallet/roi/wallet/utils/price_utils.dart';

part 'wallet_send_avm_store.g.dart';

class WalletSendAvmStore = _WalletSendAvmStore with _$WalletSendAvmStore;

abstract class _WalletSendAvmStore with Store {
  final wallet = getIt<WalletFactory>().activeWallet;

  final priceStore = getIt<PriceStore>();

  @computed
  double get avaxPrice => priceStore.avaxPrice.toDouble();

  @observable
  String? addressError;

  @observable
  String? amountError;

  @observable
  double fee = 0;

  @observable
  double total = 0;

  @action
  getBalanceX() async {
    priceStore.updateAvaxPrice();
    fee = bnToDecimalAvaxX(getTxFeeX()).toDouble();
    total = avaxPrice * fee;
  }

  @action
  bool validate(String address, double amount, double balance) {
    final isAddressValid = validateAddressX(address);
    final isAmountValid = balance > amount && amount > 0;
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

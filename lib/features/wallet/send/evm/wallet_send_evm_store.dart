import 'package:mobx/mobx.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/wallet/helpers/address_helper.dart';
import 'package:wallet/roi/wallet/helpers/gas_helper.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';
import 'package:wallet/roi/wallet/utils/price_utils.dart';
import 'package:web3dart/web3dart.dart';

part 'wallet_send_evm_store.g.dart';

class WalletSendEvmStore = _WalletSendEvmStore with _$WalletSendEvmStore;

abstract class _WalletSendEvmStore with Store {
  final wallet = SingletonWallet(
      privateKey:
          "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  @observable
  BigInt gasPrice = BigInt.zero;

  @observable
  BigInt gasLimit = BigInt.zero;

  @observable
  double avaxPrice = 0;

  @observable
  String? addressError;

  @observable
  String? amountError;

  @observable
  bool sendSuccess = false;

  @observable
  bool confirmSuccess = false;

  @observable
  double fee = 0.00065625;

  @observable
  bool isLoading = false;

  @action
  getBalanceC() async {

    final adjustGasPrice = await getAdjustedGasPrice();
    gasPrice = EtherAmount.fromUnitAndValue(EtherUnit.wei, adjustGasPrice)
        .getValueInUnitBI(EtherUnit.gwei);

    avaxPrice = (await getAvaxPrice()).toDouble();
  }

  @action
  confirm(String address, double amount, double balance) async {
    final isAddressValid = validateAddressEvm(address);
    final isAmountValid = balance >= amount && amount > 0;
    if (!isAddressValid) {
      addressError = Strings.current.sharedInvalidAddress;
    }
    if (!isAmountValid) {
      amountError = Strings.current.sharedInvalidAmount;
    }
    if (isAddressValid && isAmountValid) {
      final evmAmount = numberToBNAvaxC(amount);
      gasLimit =
          await wallet.estimateAvaxGasLimit(address, evmAmount, gasPrice);
      confirmSuccess = true;
    }
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
  Future<bool> sendEvm(String address, double amount) async {
    isLoading = true;
    try {
      final txId = await wallet.sendAvaxC(
          address, numberToBNAvaxC(amount), gasPrice, gasLimit.toInt());
      print("txId = $txId");
      isLoading = false;
      return true;
    } catch (e) {
      print(e);
      isLoading = false;
      return false;
    }
  }
}

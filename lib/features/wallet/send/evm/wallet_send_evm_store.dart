import 'package:mobx/mobx.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/wallet/helpers/address_helper.dart';
import 'package:wallet/roi/wallet/helpers/gas_helper.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';
import 'package:web3dart/web3dart.dart';

part 'wallet_send_evm_store.g.dart';

class WalletSendEvmStore = _WalletSendEvmStore with _$WalletSendEvmStore;

abstract class _WalletSendEvmStore with Store {
  final wallet = SingletonWallet(
      privateKey:
          "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  @observable
  String balanceC = '0';

  @observable
  BigInt gasPrice = BigInt.zero;

  @observable
  BigInt gasLimit = BigInt.zero;

  @observable
  double rateAvax = 127.3;

  @observable
  String? addressError;

  @observable
  String? amountError;

  @observable
  bool sendSuccess = false;

  @observable
  bool confirmSuccess = false;

  double get balanceCDouble =>
      double.tryParse(balanceC.replaceAll(',', '')) ?? 0;

  @action
  getBalanceC() async {
    await wallet.updateAvaxBalanceC();
    balanceC = wallet.getBalanceC().balanceDecimal;

    final adjustGasPrice = await getAdjustedGasPrice();
    gasPrice = EtherAmount.fromUnitAndValue(EtherUnit.wei, adjustGasPrice)
        .getValueInUnitBI(EtherUnit.gwei);
  }

  @action
  confirm(String address, double amount) async {
    final isAddressValid = validateAddressEvm(address);
    final isAmountValid = balanceCDouble > amount && amount > 0;
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
    try {
      final txId = await wallet.sendAvaxC(
          address, numberToBNAvaxC(amount), gasPrice, gasLimit.toInt());
      print("txId = $txId");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

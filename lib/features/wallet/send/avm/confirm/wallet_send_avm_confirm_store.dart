import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

part 'wallet_send_avm_confirm_store.g.dart';

class WalletSendAvmConfirmStore = _WalletSendAvmConfirmStore
    with _$WalletSendAvmConfirmStore;

abstract class _WalletSendAvmConfirmStore with Store {
  final wallet = SingletonWallet(
      privateKey:
          "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  @observable
  bool sendSuccess = false;

  @observable
  bool isLoading = false;

  @action
  sendAvm(String address, double amount, {String? memo}) async {
    isLoading = true;
    try {
      await wallet.updateUtxosX();
      final txId =
          await wallet.sendAvaxX(address, numberToBNAvaxX(amount), memo: memo);
      print("txId = $txId");
      sendSuccess = true;
    } catch (e) {
      print(e);
    }
    isLoading = false;
  }
}

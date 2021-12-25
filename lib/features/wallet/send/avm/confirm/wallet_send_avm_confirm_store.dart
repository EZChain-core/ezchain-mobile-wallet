import 'package:mobx/mobx.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/wallet/helpers/address_helper.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

part 'wallet_send_avm_confirm_store.g.dart';

class WalletSendAvmConfirmStore = _WalletSendAvmConfirmStore with _$WalletSendAvmConfirmStore;

abstract class _WalletSendAvmConfirmStore with Store {
  final wallet = SingletonWallet(
      privateKey:
          "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  @observable
  bool sendSuccess = false;

  @action
  sendAvm(String address, double amount) async {
    try {
      await wallet.updateUtxosX();
      final txId = await wallet.sendAvaxX(address, numberToBNAvaxX(amount));
      print("txId = $txId");
      sendSuccess = true;
    } catch (e) {
      print(e);
    }
  }
}

import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

part 'wallet_send_avm_store.g.dart';

class WalletSendAvmStore = _WalletSendAvmStore with _$WalletSendAvmStore;

abstract class _WalletSendAvmStore with Store {
  final wallet = SingletonWallet(
      privateKey:
          "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  @observable
  String balanceX = '0';

  @action
  getBalanceX() async {
    await wallet.updateUtxosX();
    wallet
        .getBalanceX()
        .forEach((_, balance) => {balanceX = balance.unlockedDecimal});
  }
}

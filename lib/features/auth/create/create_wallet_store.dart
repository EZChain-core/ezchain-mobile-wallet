import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/mnemonic_wallet.dart';

part 'create_wallet_store.g.dart';

class CreateWalletStore = _CreateWalletStore with _$CreateWalletStore;

abstract class _CreateWalletStore with Store {
  _CreateWalletStore();

  @observable
  String mnemonicPhrase = '';

  @action
  generateMnemonicPhrase() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final MnemonicWallet _mnemonicWallet = MnemonicWallet.create();
    mnemonicPhrase = _mnemonicWallet.mnemonic;
  }
}

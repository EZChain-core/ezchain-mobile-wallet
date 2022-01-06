import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/mnemonic_wallet.dart';

part 'create_wallet_store.g.dart';

class CreateWalletStore = _CreateWalletStore with _$CreateWalletStore;

abstract class _CreateWalletStore with Store {
  final MnemonicWallet _mnemonicWallet = MnemonicWallet.create();

  _CreateWalletStore();

  @observable
  String mnemonicPhrase = '';

  @action
  void generateMnemonicPhrase() {
    mnemonicPhrase = _mnemonicWallet.mnemonic;
  }
}

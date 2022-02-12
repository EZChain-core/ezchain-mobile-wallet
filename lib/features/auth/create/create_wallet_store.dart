import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/mnemonic_wallet.dart';

part 'create_wallet_store.g.dart';

const _sizeOfRandomInputMnemonic = 4;

class CreateWalletStore = _CreateWalletStore with _$CreateWalletStore;

abstract class _CreateWalletStore with Store {
  _CreateWalletStore();

  final randomIndex = (List.generate(24, (index) => index)..shuffle())
      .take(_sizeOfRandomInputMnemonic)
      .toList();

  String mnemonicPhrase = '';

  Future<String> generateMnemonicPhrase() async {
    mnemonicPhrase = MnemonicWallet.generateMnemonicPhrase();
    return mnemonicPhrase;
  }
}

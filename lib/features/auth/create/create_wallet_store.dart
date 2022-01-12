import 'dart:math';

import 'package:mobx/mobx.dart';
import 'package:wallet/roi/sdk/utils/mnemonic.dart';
import 'package:wallet/roi/wallet/mnemonic_wallet.dart';

part 'create_wallet_store.g.dart';

const _sizeOfRandomInputMnemonic = 4;

class CreateWalletStore = _CreateWalletStore with _$CreateWalletStore;

abstract class _CreateWalletStore with Store {
  _CreateWalletStore();

  final randomIndex = List.generate(_sizeOfRandomInputMnemonic,
      (_) => Random().nextInt(Mnemonic.mnemonicLength) + 1);

  String mnemonicPhrase = '';

  Future<String> generateMnemonicPhrase() async {
    mnemonicPhrase = MnemonicWallet.generateMnemonicPhrase();
    return mnemonicPhrase;
  }
}

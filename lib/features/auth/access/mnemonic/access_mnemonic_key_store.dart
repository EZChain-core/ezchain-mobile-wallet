
import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/mnemonic_wallet.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
part 'access_mnemonic_key_store.g.dart';

class AccessMnemonicKeyStore = _AccessMnemonicKeyStore with _$AccessMnemonicKeyStore;
abstract class _AccessMnemonicKeyStore with Store {

  @action
  bool accessWithMnemonicKey(String mnemonicKey) {
    final wallet = MnemonicWallet.import(mnemonicKey);
    return wallet != null;
  }
}

import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
part 'access_private_key_store.g.dart';

class AccessPrivateKeyStore = _AccessPrivateKeyStore with _$AccessPrivateKeyStore;
abstract class _AccessPrivateKeyStore with Store {

  @action
  bool accessWithPrivateKey(String privateKey) {
    final wallet = SingletonWallet.access(privateKey);
    return wallet != null;
  }
}
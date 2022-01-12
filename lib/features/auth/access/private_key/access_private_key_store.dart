
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/wallet.dart';
part 'access_private_key_store.g.dart';

class AccessPrivateKeyStore = _AccessPrivateKeyStore with _$AccessPrivateKeyStore;
abstract class _AccessPrivateKeyStore with Store {

  final walletFactory = getIt<WalletFactory>();

  @action
  bool accessWithPrivateKey(String privateKey) {
    final wallet = SingletonWallet.access(privateKey);
    if(wallet != null) {
      walletFactory.addWallet(wallet);
      walletFactory.saveAccessKey(privateKey);
      return true;
    }
    return false;
  }
}
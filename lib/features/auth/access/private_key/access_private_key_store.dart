import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/wallet.dart';
part 'access_private_key_store.g.dart';

class AccessPrivateKeyStore = _AccessPrivateKeyStore
    with _$AccessPrivateKeyStore;

abstract class _AccessPrivateKeyStore with Store {
  final walletFactory = getIt<WalletFactory>();

  @observable
  bool isLoading = false;

  Future<bool> accessWithPrivateKey(String privateKey) async {
    isLoading = true;
    final wallet = SingletonWallet.access(privateKey);
    if (wallet != null) {
      isLoading = false;
      walletFactory.addWallet(wallet);
      walletFactory.saveAccessKey(privateKey);
      return true;
    }
    return false;
  }
}

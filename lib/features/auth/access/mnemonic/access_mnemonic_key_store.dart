
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/wallet/mnemonic_wallet.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
part 'access_mnemonic_key_store.g.dart';

class AccessMnemonicKeyStore = _AccessMnemonicKeyStore with _$AccessMnemonicKeyStore;
abstract class _AccessMnemonicKeyStore with Store {
  final walletFactory = getIt<WalletFactory>();

  @action
  bool accessWithMnemonicKey(String mnemonicKey) {
    final wallet = MnemonicWallet.import(mnemonicKey);
    if(wallet != null) {
      walletFactory.addWallet(wallet);
      walletFactory.saveAccessKey(mnemonicKey);
      return true;
    }
    return false;
  }
}
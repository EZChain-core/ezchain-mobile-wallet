
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/wallet/mnemonic_wallet.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
part 'create_wallet_confirm_store.g.dart';

class CreateWalletConfirmStore = _CreateWalletConfirmStore with _$CreateWalletConfirmStore;
abstract class _CreateWalletConfirmStore with Store {
  final walletFactory = getIt<WalletFactory>();

  @action
  bool accessWithMnemonicKey(String mnemonicKey) {
    final wallet = MnemonicWallet.import(mnemonicKey);
    if(wallet != null) {
      walletFactory.addWallet(wallet);
      return true;
    }
    return false;
  }
}
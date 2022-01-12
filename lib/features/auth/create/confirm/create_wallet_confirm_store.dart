import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/wallet/mnemonic_wallet.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

part 'create_wallet_confirm_store.g.dart';

class CreateWalletConfirmStore = _CreateWalletConfirmStore
    with _$CreateWalletConfirmStore;

abstract class _CreateWalletConfirmStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  bool accessWithMnemonicKey(String mnemonicKey) {
    final wallet = MnemonicWallet.import(mnemonicKey);
    if (wallet != null) {
      _walletFactory.addWallet(wallet);
      _walletFactory.saveAccessKey(mnemonicKey);
      return true;
    }
    return false;
  }
}

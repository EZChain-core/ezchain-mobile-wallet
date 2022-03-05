import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/ezc/wallet/mnemonic_wallet.dart';
import 'package:wallet/ezc/wallet/singleton_wallet.dart';

part 'create_wallet_confirm_store.g.dart';

class CreateWalletConfirmStore = _CreateWalletConfirmStore
    with _$CreateWalletConfirmStore;

abstract class _CreateWalletConfirmStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  @observable
  bool isLoading = false;

  Future<bool> accessWithMnemonicKey(String mnemonicKey) async {
    isLoading = true;
    final wallet = MnemonicWallet.import(mnemonicKey);
    if (wallet != null) {
      isLoading = false;
      _walletFactory.addWallet(wallet);
      _walletFactory.saveAccessKey(mnemonicKey);
      return true;
    }
    return false;
  }
}

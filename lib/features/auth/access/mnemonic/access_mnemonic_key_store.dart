import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/wallet/mnemonic_wallet.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

part 'access_mnemonic_key_store.g.dart';

class AccessMnemonicKeyStore = _AccessMnemonicKeyStore
    with _$AccessMnemonicKeyStore;

abstract class _AccessMnemonicKeyStore with Store {

  @observable
  bool isLoading = false;

  final _walletFactory = getIt<WalletFactory>();

  final _mnemonicPhrase = <String>[];

  List<String> get mnemonicPhrase => _mnemonicPhrase;

  set mnemonicPhrase(List<String> phrase) {
    _mnemonicPhrase.clear();
    _mnemonicPhrase.addAll(phrase);
  }

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

import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/wallet/mnemonic_wallet.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

part 'access_mnemonic_key_store.g.dart';

class AccessMnemonicKeyStore = _AccessMnemonicKeyStore
    with _$AccessMnemonicKeyStore;

abstract class _AccessMnemonicKeyStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  final _mnemonicPhrase = <String>[];

  List<String> get mnemonicPhrase => _mnemonicPhrase;

  set mnemonicPhrase(List<String> phrase) {
    _mnemonicPhrase.clear();
    _mnemonicPhrase.addAll(phrase);
  }

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

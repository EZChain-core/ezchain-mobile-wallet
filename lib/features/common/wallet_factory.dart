import 'package:wallet/roi/wallet/wallet.dart';

abstract class WalletFactory {
  WalletProvider get activeWallet;

  addWallet(WalletProvider wallet);

  saveAccessKey(String key);

  clear();

  clearWallets();

  Future<bool> isExpired();

  Future<bool> initWallet();

  Future<String> getAccessKey();

  savePinCode(String pin);

  Future<bool> isPinCodeCorrect(String pin);
}

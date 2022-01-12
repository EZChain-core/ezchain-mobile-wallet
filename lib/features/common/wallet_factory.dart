import 'package:wallet/roi/wallet/wallet.dart';

abstract class WalletFactory {
  WalletProvider get activeWallet;

  addWallet(WalletProvider wallet);

  saveAccessKey(String key);

  clear();

  Future<bool> isExpired();

  Future<bool> initWallet();
}

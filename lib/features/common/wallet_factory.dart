import 'package:wallet/roi/wallet/network/constants.dart';
import 'package:wallet/roi/wallet/network/types.dart';
import 'package:wallet/roi/wallet/wallet.dart';

import 'network_config_type.dart';

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

  saveNetworkConfig(NetworkConfigType network);

  Future<NetworkConfigType> getNetworkConfig();
}

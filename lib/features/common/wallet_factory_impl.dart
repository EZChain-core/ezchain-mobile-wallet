import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/sdk/utils/mnemonic.dart';
import 'package:wallet/roi/wallet/mnemonic_wallet.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/wallet.dart';

import 'network_config_type.dart';

@LazySingleton(as: WalletFactory)
class WalletFactoryImpl extends WalletFactory {
  static const expiredTimeInMinutes = 5;
  static const expiredTimeKey = 'expiredTimeKey';
  static const accessKey = 'accessKey';
  static const pinCode = 'pinCode';
  static const networkConfig = 'networkConfig';

  final List<WalletProvider> _wallets = [];

  final _storage = const FlutterSecureStorage();

  @override
  WalletProvider get activeWallet => _wallets.first;

  @override
  addWallet(WalletProvider wallet) {
    _wallets.add(wallet);
  }

  @override
  saveAccessKey(String key) {
    _storage.write(key: accessKey, value: key);
    _saveExpiredTime();
  }

  @override
  clear() {
    _wallets.clear();
    _storage.deleteAll();
  }

  @override
  clearWallets() {
    _wallets.clear();
  }

  @override
  Future<bool> isExpired() async {
    final timeMillis =
        int.tryParse(await _storage.read(key: expiredTimeKey) ?? '');
    if (timeMillis == null) return true;
    final time = DateTime.fromMillisecondsSinceEpoch(timeMillis);
    final now = DateTime.now();
    final diffMinutes = now.difference(time).inMinutes;
    return diffMinutes > expiredTimeInMinutes;
  }

  _saveExpiredTime() {
    final now = DateTime.now().millisecondsSinceEpoch;
    _storage.write(key: expiredTimeKey, value: now.toString());
  }

  @override
  Future<bool> initWallet() async {
    final key = await _storage.read(key: accessKey);
    if (key == null || key.isEmpty) return false;
    WalletProvider? wallet;
    if (key.split(' ').length == Mnemonic.mnemonicLength) {
      // mnemonic key
      wallet = MnemonicWallet.import(key);
    } else {
      // private key
      wallet = SingletonWallet.access(key);
    }
    if (wallet != null) {
      _wallets.clear();
      _wallets.add(wallet);
      return true;
    }
    return false;
  }

  @override
  Future<String> getAccessKey() async {
    return await _storage.read(key: accessKey) ?? '';
  }

  @override
  savePinCode(String pin) {
    _storage.write(key: pinCode, value: pin);
  }

  @override
  Future<bool> isPinCodeCorrect(String pin) async {
    final correctPin = await _storage.read(key: pinCode) ?? '';
    return correctPin == pin;
  }

  @override
  saveNetworkConfig(NetworkConfigType network) {
    _storage.write(key: networkConfig, value: network.name);
  }

  @override
  Future<NetworkConfigType> getNetworkConfig() async {
    final networkName = await _storage.read(key: networkConfig) ?? '';
    return getNetworkConfigType(networkName);
  }
}

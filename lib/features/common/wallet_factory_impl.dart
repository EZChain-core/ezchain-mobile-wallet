import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/wallet/mnemonic_wallet.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/wallet.dart';

@LazySingleton(as: WalletFactory)
class WalletFactoryImpl extends WalletFactory {
  static const expiredTimeInMinutes = 5;
  static const expiredTimeKey = 'expiredTimeKey';
  static const accessKey = 'accessKey';

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
    if (key.split(' ').length == 24) {
      // mnemonic key
      wallet = MnemonicWallet.import(key);
    } else if (key.startsWith("PrivateKey-")) {
      // private key
      wallet = SingletonWallet.access(key);
    }
    if (wallet != null) {
      _wallets.add(wallet);
      return true;
    }
    return false;
  }
}

import 'package:injectable/injectable.dart';
import 'package:wallet/roi/wallet/wallet.dart';

@LazySingleton()
class WalletFactory {
  final List<WalletProvider> _wallets = [];

  WalletProvider get activeWallet => _wallets.first;

  addWallet(WalletProvider wallet) {
    _wallets.add(wallet);
  }

  clear() {
    _wallets.clear();
  }
}
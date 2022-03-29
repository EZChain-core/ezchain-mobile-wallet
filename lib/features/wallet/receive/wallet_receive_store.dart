import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/wallet_factory.dart';

part 'wallet_receive_store.g.dart';

class WalletReceiveStore = _WalletReceiveStore with _$WalletReceiveStore;

abstract class _WalletReceiveStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;
}

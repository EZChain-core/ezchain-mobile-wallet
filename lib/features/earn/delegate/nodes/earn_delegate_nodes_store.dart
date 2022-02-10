import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';

part 'earn_delegate_nodes_store.g.dart';

class EarnDelegateNodesStore = _EarnDelegateNodesStore
    with _$EarnDelegateNodesStore;

abstract class _EarnDelegateNodesStore with Store {
  final wallet = getIt<WalletFactory>().activeWallet;
}

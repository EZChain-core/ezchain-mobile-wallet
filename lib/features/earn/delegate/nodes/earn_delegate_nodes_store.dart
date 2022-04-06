import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/store/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';

import 'earn_delegate_node_item.dart';

part 'earn_delegate_nodes_store.g.dart';

class EarnDelegateNodesStore = _EarnDelegateNodesStore
    with _$EarnDelegateNodesStore;

abstract class _EarnDelegateNodesStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  final _validatorsStore = getIt<ValidatorsStore>();

  @observable
  String keySearch = '';

  @computed
  ObservableList<EarnDelegateNodeItem> get nodes => keySearch.isEmpty
      ? _validatorsStore.delegateNodes
      : ObservableList.of(_validatorsStore.delegateNodes
          .where((element) =>
              element.nodeId.toLowerCase().contains(keySearch.toLowerCase()) ||
              element.nodeName
                      ?.toLowerCase()
                      .contains(keySearch.toLowerCase()) ==
                  true)
          .toList());

  _EarnDelegateNodesStore() {
    refresh();
  }

  @action
  refresh() {
    Future.delayed(Duration.zero, () => _validatorsStore.fetch());
  }
}

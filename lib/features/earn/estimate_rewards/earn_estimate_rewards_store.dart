import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/store/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';

import 'earn_estimate_rewards_item.dart';

part 'earn_estimate_rewards_store.g.dart';

class EarnEstimateRewardsStore = _EarnEstimateRewardsStore
    with _$EarnEstimateRewardsStore;

abstract class _EarnEstimateRewardsStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  final _validatorsStore = getIt<ValidatorsStore>();

  @computed
  String get totalRewards => _validatorsStore.totalRewards;

  @computed
  ObservableList<EarnEstimateRewardsItem> get estimateRewards =>
      _validatorsStore.estimateRewards;

  _EarnEstimateRewardsStore() {
    refresh();
  }

  @action
  refresh() {
    Future.delayed(Duration.zero, () => _validatorsStore.fetch());
  }
}

import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/ezc/sdk/utils/bigint.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/store/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';

import 'earn_delegate_node_item.dart';

part 'earn_delegate_nodes_store.g.dart';

class EarnDelegateNodesStore = _EarnDelegateNodesStore
    with _$EarnDelegateNodesStore;

abstract class _EarnDelegateNodesStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;
  final _validatorsStore = getIt<ValidatorsStore>();

  final List<EarnDelegateNodeItem> _nodes = [];

  @observable
  String keySearch = '';

  @computed
  List<Validator> get validators => _validatorsStore.validators;

  _EarnDelegateNodesStore() {
    Future.delayed(Duration.zero, () => _validatorsStore.updateValidators);
  }

  Future<List<EarnDelegateNodeItem>> getNodeIds() async {
    if (keySearch.isNotEmpty) {
      return _nodes
          .where((element) => element.nodeId.contains(keySearch))
          .toList();
    } else if (_nodes.isNotEmpty) {
      return _nodes;
    }
    List<EarnDelegateNodeItem> nodes = [];
    try {
      validators.sort((a, b) {
        final amtA = a.stakeAmountBN;
        final amtB = b.stakeAmountBN;

        if (amtA > amtB) {
          return -1;
        } else if (amtA < amtB) {
          return 1;
        } else {
          return 0;
        }
      });
      final pendingValidators = await _wallet.getPlatformPendingValidators();
      final pendingDelegators = pendingValidators.delegators;
      final minStake = await _wallet.getMinStake();
      final minStakeDelegation = minStake.minDelegatorStakeBN;
      for (var validator in validators) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final endTime = (int.tryParse(validator.endTime) ?? 0) * 1000;
        final diff = endTime - now;

        const MINUTE_MS = 60000;
        const HOUR_MS = MINUTE_MS * 60;
        const DAY_MS = HOUR_MS * 24;

        /// If End time is less than 2 weeks + 1 hour, remove from list they are no use
        if (diff <= ((14 * DAY_MS) + (10 * MINUTE_MS))) {
          continue;
        }

        final validatorStakeAmountBN = validator.stakeAmountBN;
        final stakeAmountDecimal = bnToDecimalAvaxP(validatorStakeAmountBN);
        final stakeAmount =
            decimalToLocaleString(stakeAmountDecimal, decimals: 0);
        final fee = Decimal.tryParse(validator.delegationFee) ?? Decimal.zero;

        // max token validator là 3tr
        final absMaxStake = ONEAVAX * BigInt.parse("3000000");
        final relativeMaxStake = validatorStakeAmountBN * BigInt.from(4);

        var remainingStakeBN =
            min(absMaxStake - validatorStakeAmountBN, relativeMaxStake);

        final delegators = validator.delegators;
        if (delegators != null) {
          final sumOfStakeAmountDelegators = delegators.fold<BigInt>(
              BigInt.zero, (amt, delegator) => amt + delegator.stakeAmountBN);

          remainingStakeBN -= sumOfStakeAmountDelegators;
        }

        final sumOfStakeAmountPendingDelegators = pendingDelegators
            .where((delegator) => delegator.nodeId == validator.nodeId)
            .fold<BigInt>(
                BigInt.zero, (amt, delegator) => amt + delegator.stakeAmountBN);

        remainingStakeBN -= sumOfStakeAmountPendingDelegators;

        if (remainingStakeBN < minStakeDelegation) continue;

        final remainingStakeDecimal = bnToDecimalAvaxP(remainingStakeBN);
        final remainingStake =
            decimalToLocaleString(remainingStakeDecimal, decimals: 0);

        nodes.add(EarnDelegateNodeItem(validator.nodeId, stakeAmount,
            remainingStake, validator.delegators?.length ?? 0, endTime, fee));
      }
    } catch (e) {
      logger.e(e);
    }
    if (_nodes.isEmpty) {
      _nodes.addAll(nodes);
    }
    return nodes;
  }
}

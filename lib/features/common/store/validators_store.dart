import 'dart:math' as dart_math;

import 'package:async/async.dart';
import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/ezc/sdk/utils/bigint.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/wallet/explorer/ezc/requests.dart';
import 'package:wallet/ezc/wallet/explorer/ezc/types.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/earn/delegate/nodes/earn_delegate_node_item.dart';
import 'package:wallet/features/earn/estimate_rewards/earn_estimate_rewards_item.dart';

part 'validators_store.g.dart';

@LazySingleton()
class ValidatorsStore = _ValidatorsStore with _$ValidatorsStore;

abstract class _ValidatorsStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  @readonly
  //ignore: prefer_final_fields
  ObservableList<Validator> _validators = ObservableList.of([]);

  @readonly
  //ignore: prefer_final_fields
  ObservableList<Validator> _pendingValidators = ObservableList.of([]);

  @readonly
  //ignore: prefer_final_fields
  ObservableList<Delegator> _pendingDelegators = ObservableList.of([]);

  @readonly
  //ignore: prefer_final_fields
  ObservableMap<String, EzcValidator> _nodeCustomInformationDict =
      ObservableMap.of({});

  @readonly
  //ignore: prefer_final_fields
  ObservableList<EarnDelegateNodeItem> _delegateNodes = ObservableList.of([]);

  @readonly
  //ignore: prefer_final_fields
  ObservableList<EarnEstimateRewardsItem> _estimateRewards =
      ObservableList.of([]);

  @readonly
  //ignore: prefer_final_fields
  String _totalRewards = '';

  @readonly
  //ignore: prefer_final_fields
  BigInt _minValidatorStake = BigInt.zero;

  @readonly
  //ignore: prefer_final_fields
  BigInt _minDelegatorStake = BigInt.zero;

  CancelableCompleter<void>? _completer;

  @action
  fetch() async {
    if (_completer == null || _completer?.isCompleted == true) {
      _completer = CancelableCompleter();
      _completer?.operation.value.then((value) {
        _mapToNodeItems();
        _mapToEstimateRewardItems();
      }, onError: (e) {
        logger.e(e);
      });
      _completer?.complete(_internalFetch());
    }
  }

  @action
  dispose() {
    _completer?.operation.cancel();
    _validators.clear();
    _nodeCustomInformationDict.clear();
    _pendingValidators.clear();
    _pendingDelegators.clear();
    _delegateNodes.clear();
    _estimateRewards.clear();
    _totalRewards = '';
    _minValidatorStake = BigInt.zero;
    _minDelegatorStake = BigInt.zero;
  }

  Future<void> _internalFetch() async {
    try {
      final minStake = await _wallet.getMinStake();
      final validators = await _wallet.getPlatformValidators();
      final pendingValidators = await _wallet.getPlatformPendingValidators();
      final nodeIds = validators.map((e) => e.nodeId).toList();
      final nodeNameDict = await fetchEzcValidators(nodeIds);
      _validators.clear();
      _validators.addAll(validators);
      _nodeCustomInformationDict.clear();
      _nodeCustomInformationDict.addAll(nodeNameDict);
      _pendingValidators.clear();
      _pendingValidators.addAll(pendingValidators.validators);
      _pendingDelegators.clear();
      _pendingDelegators.addAll(pendingValidators.delegators);
      _minValidatorStake = minStake.minValidatorStakeBN;
      _minDelegatorStake = minStake.minDelegatorStakeBN;
    } catch (e) {
      logger.e(e);
    }
  }

  @action
  _mapToNodeItems() {
    try {
      List<EarnDelegateNodeItem> nodes = [];
      final validators = _validators.toList();
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
      final pendingDelegators = _pendingDelegators.toList();
      final minStakeDelegation = _minDelegatorStake;
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
        final stakeAmountDecimal = validatorStakeAmountBN.toDecimalAvaxP();
        final stakeAmount = stakeAmountDecimal.toLocaleString(
          decimals: 0,
        );
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

        final remainingStakeDecimal = remainingStakeBN.toDecimalAvaxP();
        final remainingStake =
            remainingStakeDecimal.toLocaleString(decimals: 0);

        final nodeCustomInformation =
            _nodeCustomInformationDict[validator.nodeId];

        nodes.add(
          EarnDelegateNodeItem(
            nodeId: validator.nodeId,
            validatorStake: stakeAmount,
            available: remainingStake,
            numberOfDelegators: validator.delegators?.length ?? 0,
            endTime: endTime,
            delegationFee: fee,
            nodeName: nodeCustomInformation?.name,
            nodeLogoUrl: nodeCustomInformation?.logoUrl,
          ),
        );
      }
      _delegateNodes.clear();
      _delegateNodes.addAll(nodes);
    } catch (e) {
      logger.e(e);
    }
  }

  @action
  _mapToEstimateRewardItems() {
    List<EarnEstimateRewardsItem> items = [];
    try {
      final validators = _validators.toList();
      final delegators = validators
          .where((element) =>
              element.delegators != null && element.delegators!.isNotEmpty)
          .map((e) => e.delegators!)
          .expand((element) => element)
          .toList();

      final userAddresses = _wallet.getAllAddressesPSync();

      final resV = _cleanList(userAddresses, validators) as List<Validator>;
      final resD = _cleanList(userAddresses, delegators) as List<Delegator>;

      final validatorsReward = resV.fold<BigInt>(
          BigInt.zero,
          (previousValue, element) =>
              previousValue + element.potentialRewardBN);
      final delegatorsReward = resD.fold<BigInt>(
          BigInt.zero,
          (previousValue, element) =>
              previousValue + element.potentialRewardBN);

      final totalReward = (validatorsReward + delegatorsReward)
          .toDecimalAvaxP()
          .toLocaleString(decimals: 3);

      _totalRewards = "$totalReward $ezcSymbol";

      for (var element in resV) {
        final startTime = (int.tryParse(element.startTime) ?? 0) * 1000;
        final endTime = (int.tryParse(element.endTime) ?? 0) * 1000;
        final now = DateTime.now().millisecondsSinceEpoch;
        final percent =
            dart_math.min((now - startTime) / (endTime - startTime), 1);
        final rewardAmt = element.potentialRewardBN.toDecimalAvaxP()
          ..toLocaleString(decimals: 3);
        final stakingAmt = element.stakeAmountBN.toAvaxP();

        final startDate = element.startTime.parseDateTimeFromTimestamp();
        final endDate = element.startTime.parseDateTimeFromTimestamp();

        final nodeCustomInformation =
            _nodeCustomInformationDict[element.nodeId];

        items.add(EarnEstimateRewardsItem(
          element.nodeId,
          '$stakingAmt $ezcSymbol',
          '$rewardAmt $ezcSymbol',
          startDate != null ? DateFormat.yMd().format(startDate) : '',
          endDate != null ? DateFormat.yMd().format(endDate) : '',
          (percent * 100).toInt(),
          nodeCustomInformation?.name,
          nodeCustomInformation?.logoUrl,
        ));
      }
      for (var element in resD) {
        final startTime = (int.tryParse(element.startTime) ?? 0) * 1000;
        final endTime = (int.tryParse(element.endTime) ?? 0) * 1000;
        final now = DateTime.now().millisecondsSinceEpoch;
        final percent =
            dart_math.min((now - startTime) / (endTime - startTime), 1);
        final rewardAmt = element.potentialRewardBN
            .toDecimalAvaxP()
            .toLocaleString(decimals: 1);
        final stakingAmt = element.stakeAmountBN.toAvaxP();

        final startDate = element.startTime.parseDateTimeFromTimestamp();
        final endDate = element.startTime.parseDateTimeFromTimestamp();

        final nodeCustomInformation =
            _nodeCustomInformationDict[element.nodeId];

        items.add(EarnEstimateRewardsItem(
          element.nodeId,
          '$stakingAmt $ezcSymbol',
          '$rewardAmt $ezcSymbol',
          startDate != null ? DateFormat.yMd().format(startDate) : '',
          endDate != null ? DateFormat.yMd().format(endDate) : '',
          (percent * 100).toInt(),
          nodeCustomInformation?.name,
          nodeCustomInformation?.logoUrl,
        ));
      }
      _estimateRewards.clear();
      _estimateRewards.addAll(items);
    } catch (e) {
      logger.e(e);
    }
  }

  List<dynamic> _cleanList(List<String> userAddresses, List<dynamic> list) {
    final res = list.where((element) {
      final rewardAddresses = element.rewardOwner?.addresses;
      if (rewardAddresses == null) return false;
      final filtered =
          rewardAddresses.where((element) => userAddresses.contains(element));
      return filtered.isNotEmpty;
    }).toList();

    res.sort((a, b) {
      final startA = int.tryParse(a.startTime) ?? 0;
      final startB = int.tryParse(b.startTime) ?? 0;

      if (startA < startB) {
        return -1;
      } else if (startA > startB) {
        return 1;
      } else {
        return 0;
      }
    });

    return res;
  }
}

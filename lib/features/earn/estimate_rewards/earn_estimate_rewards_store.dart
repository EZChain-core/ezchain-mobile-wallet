import 'dart:math' as dart_math;

import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

import 'earn_estimate_rewards_item.dart';

part 'earn_estimate_rewards_store.g.dart';

class EarnEstimateRewardsStore = _EarnEstimateRewardsStore
    with _$EarnEstimateRewardsStore;

abstract class _EarnEstimateRewardsStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;
  final _validatorsStore = getIt<ValidatorsStore>();

  @computed
  List<Validator> get validators => _validatorsStore.validators;

  Future<List<EarnEstimateRewardsItem>> getEstimateRewards() async {
    List<EarnEstimateRewardsItem> items = [];
    try {
      final delegators = validators
          .where((element) =>
              element.delegators != null && element.delegators!.isNotEmpty)
          .map((e) => e.delegators!)
          .expand((element) => element)
          .toList();

      final userAddresses = await _wallet.getAllAddressesP();

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

      final totalReward = bnToAvaxP(validatorsReward + delegatorsReward);

      logger.i("totalReward = $totalReward EZC");

      for (var element in resV) {
        final startTime = (int.tryParse(element.startTime) ?? 0) * 1000;
        final endTime = (int.tryParse(element.endTime) ?? 0) * 1000;
        final now = DateTime.now().millisecondsSinceEpoch;
        final percent =
            dart_math.min((now - startTime) / (endTime - startTime), 1);
        final rewardAmt = bnToAvaxP(element.potentialRewardBN);
        final stakingAmt = bnToAvaxP(element.stakeAmountBN);

        final startDate = element.startTime.parseDateTimeFromTimestamp();
        final endDate = element.startTime.parseDateTimeFromTimestamp();

        items.add(EarnEstimateRewardsItem(
          element.nodeId,
          '$stakingAmt EZC',
          '$rewardAmt EZC',
          startDate != null ? DateFormat.yMd().format(startDate) : '',
          endDate != null ? DateFormat.yMd().format(endDate) : '',
          (percent * 100).toInt(),
        ));

        logger.i(
            "Validator: NodeId = ${element.nodeId}, percent = ${percent * 100}%, stakingAmt = $stakingAmt EZC, rewardAmt = $rewardAmt EZC");
      }
      for (var element in resD) {
        final startTime = (int.tryParse(element.startTime) ?? 0) * 1000;
        final endTime = (int.tryParse(element.endTime) ?? 0) * 1000;
        final now = DateTime.now().millisecondsSinceEpoch;
        final percent =
            dart_math.min((now - startTime) / (endTime - startTime), 1);
        final rewardAmt = bnToAvaxP(element.potentialRewardBN);
        final stakingAmt = bnToAvaxP(element.stakeAmountBN);
        logger.i(
            "Delegator: NodeId = ${element.nodeId}, percent = ${percent * 100}%, stakingAmt = $stakingAmt EZC, rewardAmt = $rewardAmt EZC");

        final startDate = element.startTime.parseDateTimeFromTimestamp();
        final endDate = element.startTime.parseDateTimeFromTimestamp();

        items.add(EarnEstimateRewardsItem(
          element.nodeId,
          '$stakingAmt EZC',
          '$rewardAmt EZC',
          startDate != null ? DateFormat.yMd().format(startDate) : '',
          endDate != null ? DateFormat.yMd().format(endDate) : '',
          (percent * 100).toInt(),
        ));
      }
    } catch (e) {
      logger.e(e);
    }
    return items;
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

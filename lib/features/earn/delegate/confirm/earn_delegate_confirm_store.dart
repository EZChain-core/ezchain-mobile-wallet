import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/earn/delegate/confirm/earn_delegate_confirm.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/ezc/wallet/helpers/staking_helper.dart';
import 'package:wallet/ezc/wallet/utils/fee_utils.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

part 'earn_delegate_confirm_store.g.dart';

class EarnDelegateConfirmStore = _EarnDelegateConfirmStore
    with _$EarnDelegateConfirmStore;

abstract class _EarnDelegateConfirmStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;
  final _validatorsStore = getIt<ValidatorsStore>();

  @observable
  bool isLoading = false;

  @observable
  bool submitSuccess = false;

  @observable
  String estimatedRewardText = '';

  @observable
  String feeText = '';

  @computed
  List<Validator> get validators => _validatorsStore.validators;

  @action
  calculateFee(EarnDelegateConfirmArgs args) async {
    try {
      final amount = args.amount.toDouble();
      final start = args.startDate.millisecondsSinceEpoch;
      final end = args.endDate.millisecondsSinceEpoch;
      final duration = end - start;

      final currentSupply = await _wallet.getCurrentSupply();
      final estimation = await calculateStakingReward(
        numberToBN(amount, 18),
        duration ~/ 1000,
        currentSupply * BigInt.from(10).pow(9),
      );
      final estimatedReward = bnToDecimal(estimation, denomination: 18);
      estimatedRewardText = '${estimatedReward.toStringAsFixed(2)} $ezc';
      final delegationFee = args.delegateItem.delegationFee;
      final cut =
          estimatedReward * (delegationFee / Decimal.fromInt(100)).toDecimal();
      final totalFee = getTxFeeP() * BigInt.from(10).pow(9) +
          decimalToBn(cut, denomination: 18);
      feeText =
          '${bnToDecimal(totalFee, denomination: 18).toStringAsFixed(2)} $ezc';
    } catch (e) {
      logger.e(e);
    }
  }

  @action
  delegate(EarnDelegateConfirmArgs args) async {
    try {
      final nodeId = args.delegateItem.nodeId;
      final amount = args.amount.toDouble();

      final start = args.startDate.millisecondsSinceEpoch;
      final end = args.endDate.millisecondsSinceEpoch;
      isLoading = true;

      final txId =
          await _wallet.delegate(nodeId, numberToBNAvaxP(amount), start, end);
      submitSuccess = true;
      logger.i("txId = $txId");
    } catch (e) {
      showSnackBar(Strings.current.sharedCommonError);
      logger.e(e);
    }
    isLoading = false;
  }
}

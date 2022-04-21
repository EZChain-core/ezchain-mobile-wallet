import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/earn/delegate/confirm/earn_delegate_confirm.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/ezc/wallet/helpers/staking_helper.dart';
import 'package:wallet/ezc/wallet/utils/fee_utils.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

part 'earn_delegate_confirm_store.g.dart';

class EarnDelegateConfirmStore = _EarnDelegateConfirmStore
    with _$EarnDelegateConfirmStore;

abstract class _EarnDelegateConfirmStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  final _balanceStore = getIt<BalanceStore>();

  @readonly
  bool _isLoading = false;

  @readonly
  bool _submitSuccess = false;

  @readonly
  String _estimatedRewardText = '';

  @readonly
  String _feeText = '';

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
      _estimatedRewardText = '${estimatedReward.toStringAsFixed(2)} $ezcSymbol';
      final delegationFee = args.delegateItem.delegationFee;
      final cut =
          estimatedReward * (delegationFee / Decimal.fromInt(100)).toDecimal();
      final totalFee = getTxFeeP() * BigInt.from(10).pow(9) +
          decimalToBn(cut, denomination: 18);
      _feeText =
          '${bnToDecimal(totalFee, denomination: 18).toStringAsFixed(2)} $ezcSymbol';
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
      _isLoading = true;

      final txId = await _wallet.delegate(
        nodeId,
        numberToBNAvaxP(amount),
        start,
        end,
      );
      _balanceStore.updateStake();
      _submitSuccess = true;
      logger.i("txId = $txId");
    } catch (e) {
      showSnackBar(Strings.current.sharedCommonError);
      logger.e(e);
    }
    _isLoading = false;
  }
}

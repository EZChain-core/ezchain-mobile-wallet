import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/earn/delegate/confirm/earn_delegate_confirm.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

part 'earn_delegate_confirm_store.g.dart';

class EarnDelegateConfirmStore = _EarnDelegateConfirmStore
    with _$EarnDelegateConfirmStore;

abstract class _EarnDelegateConfirmStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  @observable
  bool isLoading = false;

  @action
  delegate(EarnDelegateConfirmArgs args) async {
    try {
      final nodeId = args.nodeId;
      final amount = numberToBNAvaxX(args.amount.toDouble());

      final start = args.startDate.millisecondsSinceEpoch;
      final end = args.endDate.millisecondsSinceEpoch;
      isLoading = true;
      logger.i("nodeId = $nodeId");
      logger.i("start = $start");
      logger.i("end = $end");
      logger.i("amount = $amount");
      final txId = await _wallet.delegate(nodeId, amount, start, end);

      logger.i("txId = $txId");
    } catch (e) {
      logger.e(e);
    }
    isLoading = false;
  }
}

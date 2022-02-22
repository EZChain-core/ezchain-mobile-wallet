import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/earn/delegate/confirm/earn_delegate_confirm.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/roi/wallet/helpers/staking_helper.dart';
import 'package:wallet/roi/wallet/utils/fee_utils.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

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

  @computed
  List<Validator> get validators => _validatorsStore.validators;

  _EarnDelegateConfirmStore() {
    _validatorsStore.updateValidators();
  }

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

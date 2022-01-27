import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/roi/wallet/explorer/coingecko/requests.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

import 'balance_store.dart';

part 'validators_store.g.dart';

@LazySingleton()
class ValidatorsStore = _ValidatorsStore with _$ValidatorsStore;

abstract class _ValidatorsStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  @observable
  List<Validator> validators = [];

  _ValidatorsStore() {
    updateValidators();
  }

  @action
  updateValidators() async {
    try {
      validators = await _wallet.getPlatformValidators();
    } catch (e) {
      logger.e(e);
    }
  }
}

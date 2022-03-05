import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_current_validators.dart';

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

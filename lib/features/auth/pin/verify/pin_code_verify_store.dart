import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_current_validators.dart';

part 'pin_code_verify_store.g.dart';

@LazySingleton()
class PinCodeVerifyStore = _PinCodeVerifyStore with _$PinCodeVerifyStore;

abstract class _PinCodeVerifyStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  @observable
  bool isPinWrong = false;

  @action
  removeError() {
    isPinWrong = false;
  }

  @action
  Future<bool> isPinCorrect(String pin) async {
    final isCorrect = await _walletFactory.isPinCodeCorrect(pin);
    isPinWrong = !isCorrect;
    return isCorrect;
  }
}

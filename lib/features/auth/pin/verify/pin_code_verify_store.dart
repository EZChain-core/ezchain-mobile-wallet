import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/setting/wallet_setting.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_current_validators.dart';

part 'pin_code_verify_store.g.dart';

@LazySingleton()
class PinCodeVerifyStore = _PinCodeVerifyStore with _$PinCodeVerifyStore;

abstract class _PinCodeVerifyStore with Store {
  final _walletSetting = getIt<WalletSetting>();

  _PinCodeVerifyStore() {
    init();
  }

  @observable
  bool isPinWrong = false;

  @observable
  bool touchIdEnabled = false;

  init() async {
    touchIdEnabled = await _walletSetting.touchIdEnabled();
    logger.e('vit $touchIdEnabled');
  }

  @action
  removeError() {
    isPinWrong = false;
  }

  @action
  Future<bool> isPinCorrect(String pin) async {
    final isCorrect = await _walletSetting.isPinCodeCorrect(pin);
    isPinWrong = !isCorrect;
    return isCorrect;
  }

  Future<bool> isTouchIdEnable() => _walletSetting.touchIdEnabled();

}

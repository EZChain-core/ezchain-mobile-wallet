import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/common/setting/wallet_setting.dart';
import 'package:wallet/generated/l10n.dart';

part 'pin_code_verify_store.g.dart';

@LazySingleton()
class PinCodeVerifyStore = _PinCodeVerifyStore with _$PinCodeVerifyStore;

abstract class _PinCodeVerifyStore with Store {
  final _walletSetting = getIt<WalletSetting>();
  final _localAuthentication = LocalAuthentication();

  _PinCodeVerifyStore() {
    _init();
  }

  @observable
  bool isPinWrong = false;

  @observable
  bool touchIdEnabled = false;

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

  Future<bool> verifyByTouchId() async {
    bool enabled = await _walletSetting.touchIdEnabled();
    if (!enabled) return false;
    try {
      final isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: Strings.current.sharedCompleteBiometrics,
        biometricOnly: true,
      );
      return isAuthenticated;
    } on PlatformException catch (e) {
      logger.e(e);
      showSnackBar(Strings.current.settingBiometricSystemsNotEnabled);
      return false;
    }
  }

  @action
  _init() async {
    touchIdEnabled = await _walletSetting.touchIdEnabled();
  }
}

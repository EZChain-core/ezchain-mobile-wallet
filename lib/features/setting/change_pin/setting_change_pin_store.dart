import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/setting/wallet_setting.dart';
import 'package:wallet/generated/l10n.dart';

part 'setting_change_pin_store.freezed.dart';

part 'setting_change_pin_store.g.dart';

class SettingChangePinStore = _SettingChangePinStore
    with _$SettingChangePinStore;

abstract class _SettingChangePinStore with Store {
  final _walletSetting = getIt<WalletSetting>();

  @observable
  SettingChangePinState state = const SettingChangePinState.oldPin();

  String? newPin;

  @action
  transitionState(SettingChangePinState pinState) {
    state = pinState;
  }

  @action
  verifyOldPin(String pin) async {
    final isCorrect = await _walletSetting.isPinCodeCorrect(pin);
    state = isCorrect
        ? const SettingChangePinState.newPin()
        : const SettingChangePinState.oldPinError();
  }

  @action
  setNewPin(String pin) {
    newPin = pin;
    state = const SettingChangePinState.confirmNewPin();
  }

  @action
  verifyNewPin(String pin) {
    if (newPin != pin) {
      state = const SettingChangePinState.confirmNewPinError();
    } else {
      _walletSetting.savePinCode(pin);
      getIt<AppRouter>().pop();
    }
  }
}

@freezed
class SettingChangePinState with _$SettingChangePinState {
  const SettingChangePinState._();

  const factory SettingChangePinState.oldPin() = OldPin;

  const factory SettingChangePinState.oldPinError() = OldPinError;

  const factory SettingChangePinState.newPin() = NewPin;

  const factory SettingChangePinState.confirmNewPin() = ConfirmNewPin;

  const factory SettingChangePinState.confirmNewPinError() = ConfirmNewPinError;

  String title() => this.when(
        oldPin: () => Strings.current.settingEnterOldPin,
        oldPinError: () => Strings.current.settingOldPinWrong,
        newPin: () => Strings.current.settingEnterNewPin,
        confirmNewPin: () => Strings.current.settingConfirmNewPin,
        confirmNewPinError: () => Strings.current.settingConfirmNewPin,
      );

  String errorMessage() => maybeWhen(
        oldPinError: () => Strings.current.settingOldPinWrong,
        confirmNewPinError: () => Strings.current.settingConfirmNewPinWrong,
        orElse: () => '',
      );
}

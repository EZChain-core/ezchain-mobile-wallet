import 'package:mobx/mobx.dart';

part 'setting_change_pin_store.g.dart';

class SettingChangePinStore = _SettingChangePinStore with _$SettingChangePinStore;

abstract class _SettingChangePinStore with Store {
  @observable
  SettingChangePinState state = SettingChangePinState.oldPin;

  @action
  transitionState(SettingChangePinState pinState) {
    state = pinState;
  }
}

enum SettingChangePinState {
  oldPin,
  oldPinError,
  newPin,
  confirmNewPin,
  confirmNewPinError,
}
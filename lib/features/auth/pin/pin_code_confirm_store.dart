import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/setting/wallet_setting.dart';

part 'pin_code_confirm_store.g.dart';

class PinCodeConfirmStore = _PinCodeConfirmStore with _$PinCodeConfirmStore;

abstract class _PinCodeConfirmStore with Store {
  final _walletSetting = getIt<WalletSetting>();

  @readonly
  bool _isPinCorrect = true;

  @action
  setPinCorrect(bool isPinCorrect) {
    _isPinCorrect = isPinCorrect;
  }

  savePinCode(String pin) {
    _walletSetting.savePinCode(pin);
  }
}

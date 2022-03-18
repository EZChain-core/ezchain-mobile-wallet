import 'package:injectable/injectable.dart';
import 'package:wallet/common/storage.dart';
import 'package:wallet/features/common/type/network_config_type.dart';
import 'package:wallet/features/common/setting/wallet_setting.dart';

@LazySingleton(as: WalletSetting)
class WalletSettingImpl extends WalletSetting {
  static const pinCodeKey = 'pinCodeKey';
  static const networkConfigKey = 'networkConfigKey';
  static const touchIdKey = 'touchIdKey';

  @override
  savePinCode(String pin) {
    storage.write(key: pinCodeKey, value: pin);
  }

  @override
  Future<bool> isPinCodeCorrect(String pin) async {
    final correctPin = await storage.read(key: pinCodeKey) ?? '';
    return correctPin == pin;
  }

  @override
  saveNetworkConfig(NetworkConfigType network) {
    storage.write(key: networkConfigKey, value: network.name);
  }

  @override
  Future<NetworkConfigType> getNetworkConfig() async {
    final networkName = await storage.read(key: networkConfigKey) ?? '';
    return getNetworkConfigType(networkName);
  }

  @override
  enableTouchId(bool enabled) {
    storage.write(key: touchIdKey, value: enabled.toString());
  }

  @override
  Future<bool> touchIdEnabled() async {
    final enabledString = (await storage.read(key: touchIdKey) ?? 'false');
    return enabledString.toLowerCase() == 'true';
  }
}

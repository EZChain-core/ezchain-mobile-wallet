
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/features/common/network_config_type.dart';
import 'package:wallet/features/common/setting/wallet_setting.dart';

@LazySingleton(as: WalletSetting)
class WalletSettingImpl extends WalletSetting {

  static const pinCodeKey = 'pinCodeKey';
  static const networkConfigKey = 'networkConfigKey';
  static const touchIdKey = 'touchIdKey';

  final _storage = const FlutterSecureStorage();


  @override
  savePinCode(String pin) {
    _storage.write(key: pinCodeKey, value: pin);
  }

  @override
  Future<bool> isPinCodeCorrect(String pin) async {
    final correctPin = await _storage.read(key: pinCodeKey) ?? '';
    return correctPin == pin;
  }

  @override
  saveNetworkConfig(NetworkConfigType network) {
    _storage.write(key: networkConfigKey, value: network.name);
  }

  @override
  Future<NetworkConfigType> getNetworkConfig() async {
    final networkName = await _storage.read(key: networkConfigKey) ?? '';
    return getNetworkConfigType(networkName);
  }

  @override
  enableTouchId(bool enabled) {
    _storage.write(key: touchIdKey, value: enabled.toString());
  }

  @override
  Future<bool> touchIdEnabled() async {
    final enabledString = (await _storage.read(key: touchIdKey) ?? 'false');
    return enabledString.toLowerCase() == 'true';
  }

}
import '../network_config_type.dart';

abstract class WalletSetting {

  savePinCode(String pin);

  Future<bool> isPinCodeCorrect(String pin);

  saveNetworkConfig(NetworkConfigType network);

  Future<NetworkConfigType> getNetworkConfig();

  enableTouchId(bool enabled);

  Future<bool> touchIdEnabled();
}

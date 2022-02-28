import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/sdk/utils/mnemonic.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/network/types.dart';

part 'setting_store.g.dart';

class SettingStore = _SettingStore with _$SettingStore;

abstract class _SettingStore with Store {
  @observable
  NetworkConfig activeNetworkConfig = activeNetwork;

  @action
  setNetworkConfig(NetworkConfig network) {
    setRpcNetwork(network);
    activeNetworkConfig = network;
  }
}

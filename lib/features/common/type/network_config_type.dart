import 'package:wallet/ezc/wallet/network/constants.dart';
import 'package:wallet/ezc/wallet/network/types.dart';

enum NetworkConfigType { mainnet, testnet }

extension NetworkConfigTypeExtension on NetworkConfigType {
  String get name {
    return ["mainnet", "testnet"][index];
  }

  NetworkConfig get config {
    return [mainnetConfig, testnetConfig][index];
  }
}

NetworkConfigType getNetworkConfigType(String name) {
  return NetworkConfigType.values.firstWhere((element) => element.name == name,
      orElse: () => NetworkConfigType.mainnet);
}

NetworkConfigType getNetworkConfigTypeFromConfig(NetworkConfig config) {
  return NetworkConfigType.values.firstWhere(
      (element) => element.config == config,
      orElse: () => NetworkConfigType.mainnet);
}

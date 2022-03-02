import 'package:wallet/roi/wallet/network/constants.dart';
import 'package:wallet/roi/wallet/network/types.dart';

enum NetworkConfigType { mainnest, testnet }

extension NetworkConfigTypeExtension on NetworkConfigType {
  String get name {
    return ["mainnest", "testnet"][index];
  }

  NetworkConfig get config {
    return [mainnetConfig, testnetConfig][index];
  }
}

NetworkConfigType getNetworkConfigType(String name) {
  return NetworkConfigType.values.firstWhere((element) => element.name == name,
      orElse: () => NetworkConfigType.testnet);
}

NetworkConfigType getNetworkConfigTypeFromConfig(NetworkConfig config) {
  return NetworkConfigType.values.firstWhere(
      (element) => element.config == config,
      orElse: () => NetworkConfigType.testnet);
}

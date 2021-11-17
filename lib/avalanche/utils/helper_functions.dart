import 'package:wallet/avalanche/utils/constants.dart';

String getPreferredHRP(int networkId) {
  return networkIDToHRP[networkId] ?? networkIDToHRP[defaultNetworkID]!;
}

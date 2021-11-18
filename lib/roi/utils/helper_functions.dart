import 'package:wallet/roi/utils/constants.dart';

String getPreferredHRP(int networkId) {
  return networkIDToHRP[networkId] ?? networkIDToHRP[defaultNetworkID]!;
}

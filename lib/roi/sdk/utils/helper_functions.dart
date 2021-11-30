import 'package:wallet/roi/sdk/utils/constants.dart';

String getPreferredHRP(int networkId) {
  return networkIdToHRP[networkId] ?? networkIdToHRP[defaultNetworkId]!;
}

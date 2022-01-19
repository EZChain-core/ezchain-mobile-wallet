import 'package:wallet/roi/wallet/network/network.dart';

String idToChainAlias(String id) {
  if (id == activeNetwork.xChainId) {
    return "X";
  } else if (id == activeNetwork.pChainId) {
    return "P";
  } else if (id == activeNetwork.cChainId) {
    return "C";
  } else {
    throw Exception("Unknown chain Id.");
  }
}

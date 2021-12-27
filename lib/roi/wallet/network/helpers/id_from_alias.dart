import 'package:wallet/roi/wallet/network/network.dart';

String chainIdFromAlias(String alias) {
  switch (alias) {
    case "X":
      return xChain.getBlockchainId();
    case "P":
      return pChain.getBlockchainId();
    case "C":
      return cChain.getBlockchainId();
    default:
      throw Exception("Unknown chain alias.");
  }
}

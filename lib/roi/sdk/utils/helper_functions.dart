import 'dart:typed_data';
import 'package:hex/hex.dart';

import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';

String getPreferredHRP(int networkId) {
  return networkIdToHRP[networkId] ?? networkIdToHRP[defaultNetworkId]!;
}

String bufferToNodeIDString(Uint8List pk) {
  return "$nodeIdPrefix${cb58Encode(pk)}";
}

Uint8List nodeIDStringToBuffer(String pk) {
  assert(pk.startsWith(nodeIdPrefix));
  final pkSplit = pk.split("-");
  return cb58Decode(pkSplit[pkSplit.length - 1]);
}

String bufferToPrivateKeyString(Uint8List pk) {
  return "$privateKeyPrefix${cb58Encode(pk)}";
}

Uint8List privateKeyStringToBuffer(String pk) {
  assert(pk.startsWith(privateKeyPrefix));
  final pkSplit = pk.split("-");
  return cb58Decode(pkSplit[pkSplit.length - 1]);
}

BigInt bufferToBigInt16(Uint8List buff) {
  var hex = HEX.encode(buff);
  if (hex.startsWith("0x")) {
    hex = hex.substring(2);
  }
  return BigInt.parse(hex, radix: 16);
}

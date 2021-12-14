import 'dart:typed_data';

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
  var hex = hexEncode(buff);
  if (hex.startsWith("0x")) {
    hex = hex.substring(2);
  }
  return BigInt.parse(hex, radix: 16);
}

BigInt unixNow() {
  return BigInt.from(DateTime.now().toUtc().millisecondsSinceEpoch / 1000);
}

/// https://pub.dev/documentation/libsignal_protocol_dart/latest/libsignal_protocol_dart/ByteUtil/compare.html
int compare(Uint8List left, Uint8List right) {
  int result(int result) {
    return result < 0
        ? -1
        : result > 0
            ? 1
            : 0;
  }

  for (var i = 0, j = 0; i < left.length && j < right.length; i++, j++) {
    final a = left[i] & 0xff;
    final b = right[j] & 0xff;
    if (a != b) {
      return result(a - b);
    }
  }
  return result(left.length - right.length);
}

extension Uint8Lists on List<Uint8List> {
  void sortBuffer() {
    sort((a, b) => compare(a, b));
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? getOrNull(int index) {
    return index > 0 && index < length ? elementAt(index) : null;
  }
}

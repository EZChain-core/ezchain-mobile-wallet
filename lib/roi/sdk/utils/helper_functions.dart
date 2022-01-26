import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/evm/export_tx.dart';
import 'package:wallet/roi/sdk/apis/evm/import_tx.dart';
import 'package:wallet/roi/sdk/apis/evm/tx.dart';
import 'package:wallet/roi/sdk/utils/bintools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';

String getPreferredHRP(int networkId) {
  return networkIdToHRP[networkId] ?? networkIdToHRP[defaultNetworkId]!;
}

String bufferToNodeIdString(Uint8List pk) {
  return "$nodeIdPrefix${cb58Encode(pk)}";
}

Uint8List nodeIdStringToBuffer(String pk) {
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
  return stringToBigInt16(hex);
}

BigInt stringToBigInt16(String hex) {
  if (hex.startsWith("0x")) {
    hex = hex.substring(2);
  }
  return BigInt.parse(hex, radix: 16);
}

BigInt unixNow() {
  return BigInt.from(DateTime.now().toUtc().millisecondsSinceEpoch / 1000);
}

int costImportTx(EvmUnsignedTx tx) {
  var bytesCost = calcBytesCost(tx.toBuffer().lengthInBytes);
  final importTx = tx.getTransaction() as EvmImportTx;
  importTx.getImportInputs().forEach((input) {
    bytesCost += input.getCost();
  });
  const fixedFee = 10000;
  return bytesCost + fixedFee;
}

int calcBytesCost(int length) {
  return length * (networks[1]!.c.txBytesGas ?? 0);
}

int costExportTx(EvmUnsignedTx tx) {
  final bytesCost = calcBytesCost(tx.toBuffer().lengthInBytes);
  final exportTx = tx.getTransaction() as EvmExportTx;
  final numSigs = exportTx.getInputs().length;
  final sigCost = numSigs * (networks[1]!.c.costPerSignature ?? 0);
  const fixedFee = 10000;
  return bytesCost + sigCost + fixedFee;
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

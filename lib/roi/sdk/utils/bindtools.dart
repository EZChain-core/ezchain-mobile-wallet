import 'dart:typed_data';
import 'package:dart_bech32/dart_bech32.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:hash/hash.dart';

String addressToString(String chainId, String hrp, Uint8List address) {
  final words = bech32.toWords(address);
  return "$chainId-${bech32.encode(Decoded(prefix: hrp, words: words))}";
}

String cb58Encode(Uint8List bytes) {
  final x = addChecksum(bytes);
  return Base58Encode(x);
}

Uint8List cb58Decode(dynamic bytes) {
  if (bytes is String) {
    bytes = Uint8List.fromList(Base58Decode(bytes));
  }
  if (validateChecksum(bytes)) {
    return bytes.sublist(0, bytes.length - 4);
  }
  throw Exception("Error - BinTools.cb58Decode: invalid checksum");
}

bool validateChecksum(Uint8List bytes) {
  final checkSlice = bytes.sublist(bytes.length - 4, bytes.length);
  final sha256 = SHA256();
  var hashSlice = sha256.update(bytes.sublist(0, bytes.length - 4)).digest();
  hashSlice = hashSlice.sublist(28, hashSlice.length);
  return checkSlice.toString() == hashSlice.toString();
}

Uint8List addChecksum(Uint8List buff) {
  final sha256 = SHA256();
  var hashSlice = sha256.update(buff).digest();
  hashSlice = hashSlice.sublist(28, hashSlice.length);
  return Uint8List.fromList([...buff, ...hashSlice]);
}

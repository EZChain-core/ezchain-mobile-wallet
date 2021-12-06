import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:dart_bech32/dart_bech32.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:hash/hash.dart';
import 'package:web3dart/credentials.dart';

String addressToString(String chainId, String hrp, Uint8List address) {
  final words = bech32.toWords(address);
  return "$chainId-${bech32.encode(Decoded(prefix: hrp, words: words))}";
}

Uint8List stringToAddress(String address, {String? hrp}) {
  if (address.substring(0, 2) == "0x") {
    // ETH-style address
    if (isEthAddress(address)) {
      Uint8List.fromList(HEX.decode(address.substring(2)));
    } else {
      throw Exception("Error - Invalid address");
    }
  }

  final parts = address.trim().split("-");

  if (parts.length < 2) {
    throw Exception("Error - Valid address should include -");
  }

  if (parts[0].isEmpty) {
    throw Exception("Error - Valid address must have prefix before -");
  }

  final split = parts[1].lastIndexOf("1");
  if (split < 0) {
    throw Exception("Error - Valid address must include separator (1)");
  }

  final humanReadablePart = parts[1].substring(0, split);
  if (humanReadablePart.isEmpty) {
    throw Exception("Error - HRP should be at least 1 character");
  }

  if (humanReadablePart != "avax" &&
      humanReadablePart != "fuji" &&
      humanReadablePart != "local" &&
      humanReadablePart != hrp) {
    throw Exception("Error - Invalid HRP");
  }

  return bech32.fromWords(bech32.decode(parts[1]).words);
}

bool isEthAddress(String address) {
  try {
    EthereumAddress.fromHex(address);
    return true;
  } catch (e) {}
  return false;
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

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hash/hash.dart';
import 'package:wallet/roi/apis/xchain/x_key_chain.dart';
import 'package:bech32/bech32.dart';
import 'package:dart_bech32/dart_bech32.dart';
import 'package:dart_bech32/src/models.dart';

void main() {
  setUp(() async {});

  tearDown(() {});

  test("Test EC", () async {
    final keyChain = XKeyPair(chainId: "chainId", hrp: "local");
    final privateKey = keyChain.privateKey;
    final publicKey = keyChain.publicKey;
    final privateKeyHex = privateKey.toHex();
    final publicKeyHex = publicKey.toCompressedHex();
    print("privateKeyHex = $privateKeyHex");
    print("privateKeyHex.length = ${privateKeyHex.length}");
    print("publicKeyHex = $publicKeyHex");
    print("publicKeyHex.length = ${publicKeyHex.length}");

    // Bech32 bech32 = bech32codec.decode("bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4");
    // print(bech32.data);
    // print(bech32.hrp);
    // print("data = ${"bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4".length}");
    //
    // Uint8List data = Uint8List.fromList([0, 14, 20, 15, 7, 13, 26, 0, 25, 18, 6, 11, 13, 8, 21, 4, 20, 3, 17, 2, 29, 3, 12, 29, 3, 4, 15, 24, 20, 6, 14, 30, 22]);
    // print(bech32codec.encode(Bech32("bc", data)));

    var hash = utf8.encode(publicKeyHex);
    var sha256 = SHA256();
    var ripemd160 = RIPEMD160();
    var test = ripemd160.update(sha256.update(hash).digest()).digest();
    var data = Uint8List.fromList([0, ...test]);
    final words = bech32.toWords(Uint8List.fromList(utf8.encode('foobar')));

    print("test = $data");
    print("test = ${data.length}");
    print(bech32codec.encode(Bech32("bc", data)));
    // https://pub.dev/packages/dart_bech32
  });
}

String encodeHEX(List<int> bytes) {
  var str = '';
  for (var i = 0; i < bytes.length; i++) {
    var s = bytes[i].toRadixString(16);
    str += s.padLeft(2 - s.length, '0');
  }
  return str;
}

List<int> decodeHEX(String hex) {
  var bytes = <int>[];
  var len = hex.length ~/ 2;
  for (var i = 0; i < len; i++) {
    bytes.add(int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16));
  }
  return bytes;
}

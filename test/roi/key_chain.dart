import 'dart:convert';
import 'dart:typed_data';

import 'package:fast_base58/fast_base58.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hash/hash.dart';
import 'package:wallet/roi/apis/xchain/x_key_chain.dart';
import 'package:dart_bech32/dart_bech32.dart';
import 'package:dart_bech32/src/models.dart';

void main() {
  setUp(() async {});

  tearDown(() {});

  test("Test EC", () async {
    final keyChain = XKeyChain(chainId: "chainId", hrp: "local");
    // final privateKey = keyChain.privateKey;
    // final publicKey = keyChain.publicKey;
    // final privateKeyHex = privateKey.toHex();
    // final publicKeyHex = publicKey.toCompressedHex();
    // print("privateKeyHex = $privateKeyHex");
    // print("privateKeyHex.length = ${privateKeyHex.length}");
    // print("publicKeyHex = $publicKeyHex");
    // print("publicKeyHex.length = ${publicKeyHex.length}");
    //
    // var hex = utf8.encode(publicKeyHex);
    // var sha256 = SHA256();
    // var sha256Digest = sha256.update(hex).digest();
    // var ripemd160 = RIPEMD160();
    // var ripemd160Digest = ripemd160.update(sha256Digest).digest();
    // var data = Uint8List.fromList([0, ...ripemd160Digest]);
    // final words = bech32.toWords(data);
    // final address = bech32.encode(Decoded(prefix: "bc", words: words));
    // print("address = ${keyChain.getAddressString()}");
    // print("address = ${keyChain.getAddress()}");

    final newAddress1 = keyChain.makeKey();
    print(
        "newAddress1.getPrivateKeyString = ${newAddress1.getPrivateKeyString()}");

    const myPk = "PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb";
    final newAddress2 = keyChain.importKey(myPk);
    print(
        "newAddress2.getPrivateKeyString = ${newAddress2.getPrivateKeyString()}");

    final addresses = keyChain.getAddresses();
    final addressStrings = keyChain.getAddressStrings();
    final exists = keyChain.hasKey(addresses[0]);
    final keypair = keyChain.getKey(addresses[0]);

    print("addressStrings = $addressStrings");
    print("exists = $exists");
    print("keypair = $exists");
  });
}

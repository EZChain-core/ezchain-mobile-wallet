import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';

import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';

void main() {
  final keyChain = ROIKeyChain(chainId: "X", hrp: "avax");

  const privateKey =
      "PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb";
  const privateKeyHex =
      "27e6693f3122aed61653343559d5cd2702f0dd38ad2ce08e31f72c3c40fd19c4";
  const publicKey = "8khmVHUZVUxMe1WayVt1xkMMF6iUnjs7UonWf8tuy1MQgt9z4h";
  const publicKeyHex =
      "03fd1afba1ffc514f389251746f7791cbf073bb34e170a3e4916bb9867458a8ae6";

  final newAddress = keyChain.importKey(privateKey);
  final addresses = keyChain.getAddresses();
  final keypair = keyChain.getKey(addresses[0])!;

  test("privateKeyString", () {
    String getPrivateKeyString = newAddress.getPrivateKeyString();
    expect(getPrivateKeyString, privateKey);
  });

  test("privateKeyHex", () {
    final privateKey = keypair.privateKeyBytes;
    expect(hexEncode(privateKey), privateKeyHex);
  });

  test("publicKeyString", () {
    String getPublicKeyString = newAddress.getPublicKeyString();
    expect(getPublicKeyString, publicKey);
  });

  test("publicKeyHex", () {
    final publicKey = keypair.publicKeyBytes;
    expect(hexEncode(publicKey), publicKeyHex);
  });

  test("addressStrings", () {
    final addressStrings = keyChain.getAddressStrings();
    expect(addressStrings, ["X-avax129sdwasyyvdlqqsg8d9pguvzlqvup6cm8lrd3j"]);
  });

  const message = "Han Trung Kien";
  final signature = keypair.sign(message);

  test("signature", () {
    expect(hexEncode(signature),
        "4831d5b60028083529fed1d7ba2c23f71c6eaed1465c88b1a222c6f7873909977b17d78848fa8aeab5e8ed9434a2cc9f505197d797f1456b66b3fcce83c3175b00");
  });

  test("recovered publicKey", () {
    final recoveredPublicKey =
        keypair.recover(Uint8List.fromList(utf8.encode(message)), signature);
    expect(hexEncode(recoveredPublicKey), publicKeyHex);
  });

  test("verify signature", () {
    final isValid = keypair.verify(message, signature);
    expect(isValid, true);
  });
}

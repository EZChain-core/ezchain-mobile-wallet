import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:wallet/roi/common/keychain/roi_key_chain.dart';
import 'package:convert/convert.dart';
import 'package:wallet/roi/utils/constants.dart';

void main() {
  setUp(() async {});

  tearDown(() {});

  test("Test EC", () async {
    final keyChain = ROIKeyChain(
        chainId: "6h2s5de1VC65meajE1L2PjvZ1MXvHc3F6eqPCGKuDt4MxiweF",
        hrp: "local");

    const myPk = "PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb";
    final newAddress = keyChain.importKey(myPk);
    print("privateKeyString = ${newAddress.getPrivateKeyString()}");
    print("publicKeyString = ${newAddress.getPublicKeyString()}");

    final addresses = keyChain.getAddresses();
    final addressStrings = keyChain.getAddressStrings();
    final exists = keyChain.hasKey(addresses[0]);
    final keypair = keyChain.getKey(addresses[0])!;

    final privateKey = keypair.privateKey;
    final publicKey = keypair.publicKey;

    print("privateKey = ${hex.encode(privateKey.bytes)}");
    print("publicKey = ${publicKey.toCompressedHex()}");

    const message = "Han Trung Kien";
    final signature = keypair.sign(message);
    print("signature = ${hex.encode(signature)}");
    print("recoverId = ${signature.sublist(64, 65).first}");
    final recoveredPublicKey =
        keypair.recover(Uint8List.fromList(utf8.encode(message)), signature);
    print("recovered publicKey= ${hex.encode(recoveredPublicKey)}");

    final isValid = keypair.verify(message, signature);
    print("valid = $isValid");
  });
}

// AVAX - Private Key
// 527c09de91b4744cddb6b0166cccc18d65d5773a75279d0282fcb94e840860fb

// PrivateKey-dKxUfhpmRUTRQzfvTAzGNwfvkj1PpUisVaXsMkNYTUhcNRqPo

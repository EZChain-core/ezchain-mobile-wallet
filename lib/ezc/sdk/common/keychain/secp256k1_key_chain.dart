import 'dart:convert';
import 'dart:typed_data';

import 'package:hash/hash.dart';
import 'package:wallet/ezc/sdk/common/keychain/base_key_chain.dart';
import 'package:wallet/ezc/sdk/crypto/ecdsa_signer.dart';
import 'package:wallet/ezc/sdk/crypto/secp256k1.dart' as secp256k1;
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';

abstract class SECP256k1KeyPair extends StandardKeyPair {
  @override
  void generateKey() {
    keyPair = secp256k1.generateKeyPair();
  }

  @override
  bool importKey(Uint8List privateKeyBytes) {
    try {
      keyPair = secp256k1.fromPrivateKey(privateKeyBytes);
      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Uint8List sign(dynamic message) {
    if (message is String) {
      message = Uint8List.fromList(utf8.encode(message));
    }
    if (message is! Uint8List) throw Exception();
    return secp256k1.sign(message, privateKeyBytes);
  }

  @override
  Uint8List recover(Uint8List hash, Uint8List signature) {
    return secp256k1.recover(hash, EzcECSignature.fromSignature(signature));
  }

  @override
  bool verify(dynamic message, Uint8List signature) {
    if (message is String) {
      message = Uint8List.fromList(utf8.encode(message));
    }
    if (message is! Uint8List) throw Exception();
    return secp256k1.verify(
        message, publicKeyBytes, EzcECSignature.fromSignature(signature));
  }

  @override
  Uint8List getAddress() {
    return addressFromPublicKey(publicKeyBytes);
  }

  @override
  String getPrivateKeyString() {
    return bufferToPrivateKeyString(privateKeyBytes);
  }

  @override
  String getPublicKeyString() {
    return cb58Encode(publicKeyBytes);
  }

  Uint8List addressFromPublicKey(Uint8List publicKey) {
    var sha256 = SHA256();
    var sha256Digest = sha256.update(publicKey).digest();
    return RIPEMD160().update(sha256Digest).digest();
  }
}

abstract class SECP256k1KeyChain<SECPKPClass extends SECP256k1KeyPair>
    extends StandardKeyChain<SECPKPClass> {}

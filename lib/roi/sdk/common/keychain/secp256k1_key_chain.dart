import 'dart:convert';
import 'dart:typed_data';

import 'package:hash/hash.dart';
import 'package:wallet/roi/sdk/common/keychain/base_key_chain.dart';
import 'package:wallet/roi/sdk/crypto/ecdsa_signer.dart';
import 'package:wallet/roi/sdk/crypto/secp256k1.dart' as secp256k1;
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';

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
  Uint8List sign(String message) {
    return secp256k1.sign(
        Uint8List.fromList(utf8.encode(message)), privateKeyBytes);
  }

  @override
  Uint8List recover(Uint8List hash, Uint8List signature) {
    return secp256k1.recover(hash, ROIECSignature.fromSignature(signature));
  }

  @override
  bool verify(String message, Uint8List signature) {
    return secp256k1.verify(Uint8List.fromList(utf8.encode(message)),
        publicKeyBytes, ROIECSignature.fromSignature(signature));
  }

  @override
  Uint8List getAddress() {
    return addressFromPublicKey(publicKeyBytes);
  }

  @override
  String getPrivateKeyString() {
    return "$privateKeyPrefix${cb58Encode(privateKeyBytes)}";
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

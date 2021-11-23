import 'dart:convert';
import 'dart:typed_data';

import 'package:fast_base58/fast_base58.dart';
import 'package:hash/hash.dart';
import 'package:wallet/roi/common/keychain/base_key_chain.dart';
import 'package:wallet/roi/crypto/ecdsa_signer.dart';
import 'package:wallet/roi/crypto/secp256k1.dart' as secp256k1;
import 'package:wallet/roi/utils/constants.dart';

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
    var sha256 = SHA256();
    var sha256Digest = sha256.update(publicKeyBytes).digest();
    return RIPEMD160().update(sha256Digest).digest();
  }

  @override
  String getPrivateKeyString() {
    return "$privateKeyPrefix${Base58Encode(_addChecksum(privateKeyBytes))}";
  }

  @override
  String getPublicKeyString() {
    return Base58Encode(_addChecksum(publicKeyBytes));
  }

  Uint8List _addChecksum(Uint8List? bytes) {
    if (bytes == null) return Uint8List.fromList([]);
    var sha256 = SHA256();
    var hashSlice = sha256.update(bytes).digest();
    hashSlice = hashSlice.sublist(28, hashSlice.length);
    return Uint8List.fromList([...bytes, ...hashSlice]);
  }
}

abstract class SECP256k1KeyChain<SECPKPClass extends SECP256k1KeyPair>
    extends StandardKeyChain<SECPKPClass> {}
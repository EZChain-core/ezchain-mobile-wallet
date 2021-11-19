import 'dart:convert';
import 'dart:typed_data';

import 'package:elliptic/elliptic.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:hash/hash.dart';
import 'package:wallet/roi/common/key_chain.dart';

final ec = getP256();

abstract class SECP256k1KeyPair extends StandardKeyPair {
  @override
  void generateKey() {
    privateKey = ec.generatePrivateKey();
    publicKey = privateKey.publicKey;
  }

  @override
  bool importKey(List<int> bytes) {
    try {
      privateKey = PrivateKey.fromBytes(ec, bytes);
      publicKey = privateKey.publicKey;
      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Uint8List getAddress() {
    return _addressFromPublicKey(publicKey);
  }

  @override
  String getPrivateKeyString() {
    final bytes = privateKey.bytes;
    return "PrivateKey-${Base58Encode(_addChecksum(bytes))}";
  }

  /// https://stackoverflow.com/questions/63670096/how-to-generate-bech32-address-from-the-public-key-bitcoin/63899012#63899012
  Uint8List _addressFromPublicKey(PublicKey publicKey) {
    var hex = utf8.encode(publicKey.toCompressedHex());
    var sha256 = SHA256();
    var sha256Digest = sha256.update(hex).digest();
    var ripemd160 = RIPEMD160();
    return ripemd160.update(sha256Digest).digest();
  }

  List<int> _addChecksum(List<int> bytes) {
    var sha256 = SHA256();
    var hashSlice = sha256.update(bytes).digest();
    hashSlice = hashSlice.sublist(28, hashSlice.length);
    return bytes..addAll(hashSlice);
  }
}

abstract class SECP256k1KeyChain<SECPKPClass extends SECP256k1KeyPair>
    extends StandardKeyChain<SECPKPClass> {}

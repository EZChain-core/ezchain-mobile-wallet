import 'dart:typed_data';

import 'package:dart_bech32/dart_bech32.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:hash/hash.dart';
import 'package:wallet/roi/common/secp256k1.dart';

class XKeyPair extends SECP256k1KeyPair {
  String chainId;
  final String hrp;

  XKeyPair({required this.chainId, required this.hrp}) {
    generateKey();
  }

  @override
  String getAddressString() {
    final address = getAddress();
    var data = Uint8List.fromList([0, ...address]);
    final words = bech32.toWords(data);
    return bech32.encode(Decoded(prefix: "bc", words: words));
  }

  @override
  void recover() {}

  @override
  void sign() {}

  @override
  bool verify() {
    throw UnimplementedError();
  }
}

class XKeyChain extends SECP256k1KeyChain<XKeyPair> {
  final String chainId;
  final String hrp;

  XKeyChain({required this.chainId, required this.hrp});

  @override
  void addKey(XKeyPair newKey) {
    newKey.chainId = chainId;
    super.addKey(newKey);
  }

  @override
  XKeyPair makeKey() {
    final keypair = XKeyPair(chainId: chainId, hrp: hrp);
    addKey(keypair);
    return keypair;
  }

  @override
  XKeyPair importKey(String privateKey) {
    final keyPair = XKeyPair(chainId: chainId, hrp: hrp);
    var bytes = Base58Decode(privateKey.split("-")[1]);
    if (_validateChecksum(bytes)) {
      bytes = bytes.sublist(0, bytes.length - 4);
    }
    final result = keyPair.importKey(bytes);
    if (result && !keys.containsKey(keyPair.getAddress().toString())) {
      addKey(keyPair);
    }
    return keyPair;
  }

  bool _validateChecksum(List<int> bytes) {
    final checkSlice = bytes.sublist(bytes.length - 4, bytes.length);
    var sha256 = SHA256();
    var hashSlice = sha256.update(bytes.sublist(0, bytes.length - 4)).digest();
    hashSlice = hashSlice.sublist(28, hashSlice.length);
    return checkSlice.toString() == hashSlice.toString();
  }
}

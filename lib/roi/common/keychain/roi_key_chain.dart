import 'dart:typed_data';

import 'package:dart_bech32/dart_bech32.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:hash/hash.dart';
import 'package:wallet/roi/common/keychain/secp256k1_key_chain.dart';

class ROIKeyPair extends SECP256k1KeyPair {
  String chainId;
  final String hrp;

  ROIKeyPair({required this.chainId, required this.hrp}) {
    generateKey();
  }

  @override
  String getAddressString() {
    final address = getAddress();
    final words = bech32.toWords(address);
    return "$chainId-${bech32.encode(Decoded(prefix: hrp, words: words))}";
  }
}

class ROIKeyChain extends SECP256k1KeyChain<ROIKeyPair> {
  final String chainId;
  final String hrp;

  ROIKeyChain({required this.chainId, required this.hrp});

  @override
  void addKey(ROIKeyPair newKey) {
    newKey.chainId = chainId;
    super.addKey(newKey);
  }

  @override
  ROIKeyPair makeKey() {
    final keypair = ROIKeyPair(chainId: chainId, hrp: hrp);
    addKey(keypair);
    return keypair;
  }

  @override
  ROIKeyPair importKey(String privateKey) {
    final keyPair = ROIKeyPair(chainId: chainId, hrp: hrp);
    var bytes = Uint8List.fromList(Base58Decode(privateKey.split("-")[1]));
    if (_validateChecksum(bytes)) {
      bytes = bytes.sublist(0, bytes.length - 4);
    }
    final result = keyPair.importKey(bytes);
    if (result && !keys.containsKey(keyPair.getAddress().toString())) {
      addKey(keyPair);
    }
    return keyPair;
  }

  bool _validateChecksum(Uint8List bytes) {
    final checkSlice = bytes.sublist(bytes.length - 4, bytes.length);
    var sha256 = SHA256();
    var hashSlice = sha256.update(bytes.sublist(0, bytes.length - 4)).digest();
    hashSlice = hashSlice.sublist(28, hashSlice.length);
    return checkSlice.toString() == hashSlice.toString();
  }
}

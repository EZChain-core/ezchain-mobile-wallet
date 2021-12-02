import 'dart:typed_data';

import 'package:wallet/roi/sdk/common/keychain/base_key_chain.dart';
import 'package:wallet/roi/sdk/common/keychain/secp256k1_key_chain.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';

class ROIKeyPair extends SECP256k1KeyPair {
  String chainId;
  final String hrp;

  ROIKeyPair({required this.chainId, required this.hrp}) {
    generateKey();
  }

  @override
  String getAddressString() {
    return addressToString(chainId, hrp, getAddress());
  }

  @override
  ROIKeyPair clone() {
    final newKeyPair = ROIKeyPair(chainId: chainId, hrp: hrp);
    newKeyPair.importKey(privateKeyBytes);
    return newKeyPair;
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
  ROIKeyPair importKey(dynamic privateKey) {
    final keyPair = ROIKeyPair(chainId: chainId, hrp: hrp);
    var bytes = Uint8List.fromList([]);
    if (privateKey is String) {
      bytes = cb58Decode(privateKey.split("-")[1]);
    } else if (privateKey is Uint8List) {
      bytes = privateKey;
    }
    assert(bytes.isNotEmpty);
    final result = keyPair.importKey(bytes);
    if (result && !keys.containsKey(keyPair.getAddress().toString())) {
      addKey(keyPair);
    }
    return keyPair;
  }

  @override
  ROIKeyChain clone() {
    final newKeyChain = ROIKeyChain(chainId: chainId, hrp: hrp);
    for (final key in keys.keys) {
      newKeyChain.addKey(keys[key]!.clone());
    }
    return newKeyChain;
  }

  @override
  ROIKeyChain union(StandardKeyChain<StandardKeyPair> keyChain) {
    final newKeyChain = keyChain.clone() as ROIKeyChain;
    for (final key in keys.keys) {
      newKeyChain.addKey(keys[key]!.clone());
    }
    return newKeyChain;
  }
}

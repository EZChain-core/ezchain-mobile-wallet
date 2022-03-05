import 'dart:typed_data';

import 'package:wallet/ezc/sdk/common/keychain/base_key_chain.dart';
import 'package:wallet/ezc/sdk/common/keychain/secp256k1_key_chain.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';

class EZCKeyPair extends SECP256k1KeyPair {
  String chainId;
  final String hrp;

  EZCKeyPair({required this.chainId, required this.hrp}) {
    generateKey();
  }

  @override
  String getAddressString() {
    return addressToString(chainId, hrp, getAddress());
  }

  @override
  EZCKeyPair clone() {
    final newKeyPair = EZCKeyPair(chainId: chainId, hrp: hrp);
    newKeyPair.importKey(privateKeyBytes);
    return newKeyPair;
  }
}

class EZCKeyChain extends SECP256k1KeyChain<EZCKeyPair> {
  final String chainId;
  final String hrp;

  EZCKeyChain({required this.chainId, required this.hrp});

  @override
  void addKey(EZCKeyPair newKey) {
    newKey.chainId = chainId;
    super.addKey(newKey);
  }

  @override
  EZCKeyPair makeKey() {
    final keypair = EZCKeyPair(chainId: chainId, hrp: hrp);
    addKey(keypair);
    return keypair;
  }

  @override
  EZCKeyPair importKey(dynamic privateKey) {
    final keyPair = EZCKeyPair(chainId: chainId, hrp: hrp);
    var bytes = Uint8List.fromList([]);
    if (privateKey is String) {
      bytes = cb58Decode(privateKey.split("-")[1]);
    } else if (privateKey is Uint8List) {
      bytes = privateKey;
    }
    assert(bytes.isNotEmpty);
    final result = keyPair.importKey(bytes);
    if (result && !hasKey(keyPair.getAddress())) {
      addKey(keyPair);
    }
    return keyPair;
  }

  @override
  EZCKeyChain clone() {
    final newKeyChain = EZCKeyChain(chainId: chainId, hrp: hrp);
    for (final key in keys.keys) {
      newKeyChain.addKey(keys[key]!.clone());
    }
    return newKeyChain;
  }

  @override
  EZCKeyChain union(StandardKeyChain<StandardKeyPair> keyChain) {
    final newKeyChain = keyChain.clone() as EZCKeyChain;
    for (final key in keys.keys) {
      newKeyChain.addKey(keys[key]!.clone());
    }
    return newKeyChain;
  }
}

import 'dart:typed_data';

import 'package:wallet/roi/sdk/crypto/key_pair.dart';

abstract class StandardKeyPair {
  late KeyPair keyPair;

  void generateKey();

  bool importKey(Uint8List privateKeyBytes);

  Uint8List sign(String message);

  Uint8List recover(Uint8List hash, Uint8List signature);

  bool verify(String message, Uint8List signature);

  String getPrivateKeyString();

  String getPublicKeyString();

  Uint8List getAddress();

  String getAddressString();

  StandardKeyPair clone();

  Uint8List get privateKeyBytes {
    return keyPair.privateKey;
  }

  Uint8List get publicKeyBytes {
    return keyPair.publicKey;
  }
}

abstract class StandardKeyChain<KPClass extends StandardKeyPair> {
  final Map<String, KPClass> keys = {};

  KPClass makeKey();

  KPClass importKey(dynamic privateKey);

  StandardKeyChain clone();

  StandardKeyChain union(StandardKeyChain keyChain);

  List<Uint8List> getAddresses() {
    return keys.values.map((e) => e.getAddress()).toList();
  }

  List<String> getAddressStrings() {
    return keys.values.map((e) => e.getAddressString()).toList();
  }

  void addKey(KPClass newKey) {
    keys[newKey.getAddress().toString()] = newKey;
  }

  bool removeKey(KPClass key) {
    final keyAddress = key.getAddress().toString();
    final deletedKey = keys.remove(keyAddress);
    return deletedKey != null;
  }

  bool hasKey(Uint8List address) {
    return keys.containsKey(address.toString());
  }

  KPClass? getKey(Uint8List address) {
    return keys[address.toString()];
  }
}

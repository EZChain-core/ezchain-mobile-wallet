import 'dart:typed_data';

import 'package:wallet/ezc/sdk/crypto/key_pair.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';

abstract class StandardKeyPair {
  late KeyPair keyPair;

  void generateKey();

  bool importKey(Uint8List privateKeyBytes);

  Uint8List sign(dynamic message);

  Uint8List recover(Uint8List hash, Uint8List signature);

  bool verify(dynamic message, Uint8List signature);

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
    keys[hexEncode(newKey.getAddress())] = newKey;
  }

  bool removeKey(KPClass key) {
    final keyAddress = hexEncode(key.getAddress());
    final deletedKey = keys.remove(keyAddress);
    return deletedKey != null;
  }

  bool hasKey(Uint8List address) {
    return keys.containsKey(hexEncode(address));
  }

  KPClass? getKey(Uint8List address) {
    return keys[hexEncode(address)];
  }
}

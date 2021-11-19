import 'package:elliptic/elliptic.dart';

abstract class StandardKeyPair {
  late PrivateKey privateKey;

  late PublicKey publicKey;

  void generateKey();

  bool importKey();

  void sign();

  void recover();

  bool verify();

  String getPrivateKeyString();

  String getPublicKeyString();

  void getAddress();

  String getAddressString();
}

abstract class StandardKeyChain<KPClass extends StandardKeyPair> {
  KPClass makeKey();

  void getAddresses();

  String getAddressStrings();

  void addKey(KPClass newKey);

  bool removeKey(KPClass newKey);

  bool hasKey();

  KPClass getKey();
}

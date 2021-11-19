import 'package:wallet/roi/common/secp256k1.dart';

class XKeyPair extends SECP256k1KeyPair {
  final String chainId;
  final String hrp;

  XKeyPair({required this.chainId, required this.hrp}){
    generateKey();
  }

  @override
  void getAddress() {
    publicKey.toString();
  }

  @override
  String getAddressString() {
    throw "";
  }

  @override
  String getPrivateKeyString() {
    throw UnimplementedError();
  }

  @override
  String getPublicKeyString() {
    throw UnimplementedError();
  }

  @override
  bool importKey() {
    throw UnimplementedError();
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
  @override
  void addKey(XKeyPair newKey) {}

  @override
  String getAddressStrings() {
    throw UnimplementedError();
  }

  @override
  void getAddresses() {}

  @override
  XKeyPair getKey() {
    throw UnimplementedError();
  }

  @override
  bool hasKey() {
    throw UnimplementedError();
  }

  @override
  XKeyPair makeKey() {
    throw UnimplementedError();
  }

  @override
  bool removeKey(XKeyPair newKey) {
    throw UnimplementedError();
  }
}

import 'package:elliptic/elliptic.dart';
import 'package:wallet/roi/common/key_chain.dart';

final ec = getP256();

abstract class SECP256k1KeyPair extends StandardKeyPair {

  @override
  void generateKey() {
    privateKey = ec.generatePrivateKey();
    publicKey = privateKey.publicKey;
  }

}

abstract class SECP256k1KeyChain<SECPKPClass extends SECP256k1KeyPair>
    extends StandardKeyChain<SECPKPClass> {
}

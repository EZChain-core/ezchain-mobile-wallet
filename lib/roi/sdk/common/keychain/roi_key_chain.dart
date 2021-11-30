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
    final bytes = cb58Decode(privateKey.split("-")[1]);
    final result = keyPair.importKey(bytes);
    if (result && !keys.containsKey(keyPair.getAddress().toString())) {
      addKey(keyPair);
    }
    return keyPair;
  }
}

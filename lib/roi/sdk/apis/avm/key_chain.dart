import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';

class AvmKeyPair extends ROIKeyPair {
  AvmKeyPair({required String chainId, required String hrp})
      : super(chainId: chainId, hrp: hrp);
}

class AvmKeyChain extends ROIKeyChain {
  AvmKeyChain({required String chainId, required String hrp})
      : super(chainId: chainId, hrp: hrp);
}

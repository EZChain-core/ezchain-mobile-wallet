import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';

class PvmKeyPair extends ROIKeyPair {
  PvmKeyPair({required String chainId, required String hrp})
      : super(chainId: chainId, hrp: hrp);
}

class PvmKeyChain extends ROIKeyChain {
  PvmKeyChain({required String chainId, required String hrp})
      : super(chainId: chainId, hrp: hrp);
}

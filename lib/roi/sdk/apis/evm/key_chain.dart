import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';

class EvmKeyPair extends ROIKeyPair {
  EvmKeyPair({required String chainId, required String hrp})
      : super(chainId: chainId, hrp: hrp);
}

class EvmKeyChain extends ROIKeyChain {
  EvmKeyChain({required String chainId, required String hrp})
      : super(chainId: chainId, hrp: hrp);
}

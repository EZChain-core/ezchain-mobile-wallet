import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';

class EvmKeyPair extends EZCKeyPair {
  EvmKeyPair({required String chainId, required String hrp})
      : super(chainId: chainId, hrp: hrp);
}

class EvmKeyChain extends EZCKeyChain {
  EvmKeyChain({required String chainId, required String hrp})
      : super(chainId: chainId, hrp: hrp);
}

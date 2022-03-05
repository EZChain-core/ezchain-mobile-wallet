import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';

class PvmKeyPair extends EZCKeyPair {
  PvmKeyPair({required String chainId, required String hrp})
      : super(chainId: chainId, hrp: hrp);
}

class PvmKeyChain extends EZCKeyChain {
  PvmKeyChain({required String chainId, required String hrp})
      : super(chainId: chainId, hrp: hrp);
}

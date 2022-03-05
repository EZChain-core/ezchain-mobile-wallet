import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';

class AvmKeyPair extends EZCKeyPair {
  AvmKeyPair({required String chainId, required String hrp})
      : super(chainId: chainId, hrp: hrp);
}

class AvmKeyChain extends EZCKeyChain {
  AvmKeyChain({required String chainId, required String hrp})
      : super(chainId: chainId, hrp: hrp);
}

import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/hdnode.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/utils/constants.dart';

class HdScanner {
  final HDNode accountKey;

  final String changePath;

  final Map<int, HDNode> addressCache = {};
  final Map<int, EZCKeyPair> keyCacheX = {};
  final Map<int, EZCKeyPair> keyCacheP = {};

  late EZCKeyPair _avmAddressFactory;

  int get index => _index;

  int _index = 0;

  HdScanner({required this.accountKey, bool isInternal = false})
      : changePath = isInternal ? "1" : "0" {
    final hrp = getPreferredHRP(ezc.getNetworkId());
    _avmAddressFactory = EZCKeyPair(chainId: "X", hrp: hrp);
  }

  void setIndex(int index) {
    _index = index;
  }

  int increment() {
    return _index++;
  }

  EZCKeyChain getKeyChainX() {
    final keyChain = xChain.newKeyChain();
    for (int i = 0; i <= index; i++) {
      final key = getKeyForIndexX(i);
      keyChain.addKey(key);
    }
    return keyChain;
  }

  EZCKeyChain getKeyChainP() {
    final keyChain = pChain.newKeyChain();
    for (int i = 0; i <= index; i++) {
      final key = getKeyForIndexP(i);
      keyChain.addKey(key);
    }
    return keyChain;
  }

  String getAddressP() {
    return getAddressForIndex(index, 'P');
  }

  String getAddressX() {
    return getAddressForIndex(index, 'X');
  }

  Future<List<String>> getAllAddresses(String chainId) async {
    final upTo = index;
    return await getAddressesInRange(0, upTo + 1, chainId);
  }

  List<String> getAllAddressesSync(String chainId) {
    final upTo = index;
    return getAddressesInRangeSync(0, upTo + 1, chainId);
  }

  EZCKeyPair getKeyForIndexX(int index) {
    final cache = keyCacheX[index];
    if (cache != null) return cache;
    final hdKey = _getHdKeyForIndex(index);
    final keyChain = xChain.newKeyChain();
    final keyPair = keyChain.importKey(hdKey.privateKey!);
    keyCacheX[index] = keyPair;
    return keyPair;
  }

  EZCKeyPair getKeyForIndexP(int index) {
    final cache = keyCacheP[index];
    if (cache != null) return cache;
    final hdKey = _getHdKeyForIndex(index);
    final keyChain = pChain.newKeyChain();
    final keyPair = keyChain.importKey(hdKey.privateKey!);
    keyCacheP[index] = keyPair;
    return keyPair;
  }

  String getAddressForIndex(int index, String chainId) {
    final key = _getHdKeyForIndex(index);
    final publicKey = key.publicKey!;
    final addressBuffer = _avmAddressFactory.addressFromPublicKey(publicKey);
    final hrp = getPreferredHRP(ezc.getNetworkId());
    return addressToString(chainId, hrp, addressBuffer);
  }

  Future<List<String>> getAddressesInRange(
      int start, int end, String chainId) async {
    final List<String> res = [];
    for (int i = start; i < end; i++) {
      res.add(getAddressForIndex(i, chainId));

      if ((i - start) % DERIVATION_SLEEP_INTERVAL == 0) {
        await Future.delayed(const Duration(milliseconds: 0));
      }
    }
    return res;
  }

  List<String> getAddressesInRangeSync(int start, int end, String chainId) {
    final List<String> res = [];
    for (int i = start; i < end; i++) {
      res.add(getAddressForIndex(i, chainId));
    }
    return res;
  }

  HDNode _getHdKeyForIndex(int index) {
    final cache = addressCache[index];
    if (cache != null) return cache;
    final key = accountKey.derive("m/$changePath/$index");
    addressCache[index] = key;
    return key;
  }
}

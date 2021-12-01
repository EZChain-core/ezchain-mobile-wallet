import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/utils/hdnode.dart';

class HdScanner {
  final HDNode accountKey;

  final String changePath;

  int _index = 0;

  HdScanner({required this.accountKey, bool isInternal = false})
      : changePath = isInternal ? "1" : "0" {}

  ROIKeyChain getKeyChainX() {
    throw UnimplementedError();
  }

  ROIKeyChain getKeyChainP() {
    throw UnimplementedError();
  }

  String getAddressP() {
    return getAddressForIndex(_index, 'P');
  }

  String getAddressX() {
    return getAddressForIndex(_index, 'X');
  }

  Future<List<String>> getAllAddresses(String chainId) async {
    final upTo = _index;
    return await getAddressesInRange(0, upTo, chainId);
  }

  List<String> getAllAddressesSync(String chainId) {
    final upTo = _index;
    return getAddressesInRangeSync(0, upTo, chainId);
  }

  getKeyForIndexX(int index) {
    throw UnimplementedError();
  }

  getKeyForIndexP(int index) {
    throw UnimplementedError();
  }

  String getAddressForIndex(int index, String chainIt) {
    throw UnimplementedError();
  }

  Future<List<String>> getAddressesInRange(
      int start, int end, String chainId) async {
    throw UnimplementedError();
  }

  List<String> getAddressesInRangeSync(int start, int end, String chainId) {
    throw UnimplementedError();
  }
}

import 'package:wallet/ezc/sdk/utils/hdnode.dart';
import 'package:wallet/ezc/wallet/hd_scanner.dart';
import 'package:wallet/ezc/wallet/wallet.dart';

abstract class HDWalletAbstract extends WalletProvider {
  late HdScanner internalScan;
  late HdScanner externalScan;

  late HDNode accountKey;

  void setAccountKey(HDNode accountKey) {
    internalScan = HdScanner(accountKey: accountKey, isInternal: true);
    externalScan = HdScanner(accountKey: accountKey, isInternal: false);
    this.accountKey = accountKey;
  }

  @override
  String getAddressP() {
    return externalScan.getAddressP();
  }

  @override
  String getAddressX() {
    return externalScan.getAddressX();
  }

  @override
  Future<List<String>> getAllAddressesP() async {
    return getExternalAddressesP();
  }

  @override
  List<String> getAllAddressesPSync() {
    return getExternalAddressesPSync();
  }

  @override
  Future<List<String>> getAllAddressesX() async {
    return [...await getExternalAddressesX(), ...await getInternalAddressesX()];
  }

  @override
  List<String> getAllAddressesXSync() {
    return [...getExternalAddressesXSync(), ...getInternalAddressesXSync()];
  }

  @override
  String getChangeAddressX() {
    return internalScan.getAddressX();
  }

  @override
  Future<List<String>> getExternalAddressesP() async {
    return externalScan.getAllAddresses('P');
  }

  @override
  List<String> getExternalAddressesPSync() {
    return externalScan.getAllAddressesSync('P');
  }

  @override
  Future<List<String>> getExternalAddressesX() async {
    return externalScan.getAllAddresses('X');
  }

  @override
  List<String> getExternalAddressesXSync() {
    return externalScan.getAllAddressesSync('X');
  }

  @override
  Future<List<String>> getInternalAddressesX() async {
    return internalScan.getAllAddresses('X');
  }

  @override
  List<String> getInternalAddressesXSync() {
    return internalScan.getAllAddressesSync('X');
  }

  String getAddressAtIndexExternalX(int index) {
    assert(index < 0, "Index must be >= 0");
    return externalScan.getKeyForIndexX(index).getAddressString();
  }

  String getAddressAtIndexInternalX(int index) {
    assert(index < 0, "Index must be >= 0");
    return internalScan.getKeyForIndexX(index).getAddressString();
  }

  String getAddressAtIndexExternalP(int index) {
    assert(index < 0, "Index must be >= 0");
    return externalScan.getKeyForIndexP(index).getAddressString();
  }
}

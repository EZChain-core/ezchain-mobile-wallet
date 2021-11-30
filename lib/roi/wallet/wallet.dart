import 'package:wallet/roi/wallet/evm_wallet.dart';

abstract class UnsafeWallet {
  String getEvmPrivateKeyHex();
}

abstract class WalletProvider {
  EvmWallet get evmWallet;

  Future<void> signEvm(dynamic tx);

  Future<void> signX(dynamic tx);

  Future<void> signP(dynamic tx);

  Future<void> signC(dynamic tx);

  String getAddressX();

  String getChangeAddressX();

  String getAddressP();

  String getAddressC();

  String getEvmAddressBech();

  Future<List<String>> getExternalAddressesX();

  List<String> getExternalAddressesXSync();

  Future<List<String>> getInternalAddressesX();

  List<String> getInternalAddressesXSync();

  Future<List<String>> getExternalAddressesP();

  List<String> getExternalAddressesPSync();

  Future<List<String>> getAllAddressesX();

  List<String> getAllAddressesXSync();

  Future<List<String>> getAllAddressesP();

  List<String> getAllAddressesPSync();
}

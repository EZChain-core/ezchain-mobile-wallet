import 'dart:typed_data';
import 'package:wallet/ezc/sdk/apis/avm/tx.dart';
import 'package:wallet/ezc/sdk/apis/evm/tx.dart';
import 'package:wallet/ezc/sdk/apis/pvm/tx.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';

import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';
import 'package:wallet/ezc/wallet/evm_wallet.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';

class SingletonWallet extends WalletProvider implements UnsafeWallet {
  @override
  EvmWallet get evmWallet => _evmWallet;

  late String _privateKey;

  late Uint8List _keyBuff;

  late EvmWallet _evmWallet;

  SingletonWallet({required String privateKey}) {
    _privateKey = privateKey;
    _keyBuff = cb58Decode(privateKey.split("-")[1]);
    _evmWallet = EvmWallet(privateKey: _keyBuff);
  }

  factory SingletonWallet.fromEvmKey(String key) {
    final avmKeyStr =
        bufferToPrivateKeyString(Uint8List.fromList(hexDecode(key)));
    return SingletonWallet(privateKey: avmKeyStr);
  }

  static SingletonWallet? access(String key) {
    try {
      if (key.startsWith(privateKeyPrefix)) {
        return SingletonWallet(privateKey: key);
      } else {
        return SingletonWallet.fromEvmKey(key);
      }
    } catch (e) {
      return null;
    }
  }

  @override
  String getEvmPrivateKeyHex() {
    return evmWallet.getPrivateKeyHex();
  }

  String getAddressX() {
    return _getKeyChainX().getAddressStrings().first;
  }

  String getAddressP() {
    return _getKeyChainP().getAddressStrings().first;
  }

  @override
  Future<EvmTx> signC(EvmUnsignedTx tx) async {
    return evmWallet.signC(tx);
  }

  @override
  Future<Uint8List> signEvm(Transaction tx) async {
    return evmWallet.signEvm(tx);
  }

  @override
  Future<PvmTx> signP(PvmUnsignedTx tx) async {
    return tx.sign(_getKeyChainP());
  }

  @override
  Future<AvmTx> signX(AvmUnsignedTx tx) async {
    return tx.sign(_getKeyChainX());
  }

  @override
  Future<List<String>> getAllAddressesP() async {
    return [getAddressP()];
  }

  @override
  List<String> getAllAddressesPSync() {
    return [getAddressP()];
  }

  @override
  Future<List<String>> getAllAddressesX() async {
    return [getAddressX()];
  }

  @override
  List<String> getAllAddressesXSync() {
    return [getAddressX()];
  }

  @override
  String getChangeAddressX() {
    return getAddressX();
  }

  @override
  Future<List<String>> getExternalAddressesP() async {
    return [getAddressP()];
  }

  @override
  List<String> getExternalAddressesPSync() {
    return [getAddressP()];
  }

  @override
  Future<List<String>> getExternalAddressesX() async {
    return [getAddressX()];
  }

  @override
  List<String> getExternalAddressesXSync() {
    return [getAddressX()];
  }

  @override
  Future<List<String>> getInternalAddressesX() async {
    return [getAddressX()];
  }

  @override
  List<String> getInternalAddressesXSync() {
    return [getAddressX()];
  }

  EZCKeyChain _getKeyChainX() {
    final avmKeyChain = xChain.newKeyChain() as EZCKeyChain;
    avmKeyChain.importKey(_privateKey);
    return avmKeyChain;
  }

  EZCKeyChain _getKeyChainP() {
    final pvmKeyChain = pChain.newKeyChain() as EZCKeyChain;
    pvmKeyChain.importKey(_privateKey);
    return pvmKeyChain;
  }
}

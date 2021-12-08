import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:wallet/roi/sdk/apis/avm/tx.dart';
import 'package:wallet/roi/sdk/apis/evm/tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/tx.dart';
import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';

import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/wallet/evm_wallet.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/wallet.dart';
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
        bufferToPrivateKeyString(Uint8List.fromList(HEX.decode(key)));
    return SingletonWallet(privateKey: avmKeyStr);
  }

  static SingletonWallet? access(String key) {
    try {
      return SingletonWallet.fromEvmKey(key);
    } catch (e) {
      try {
        return SingletonWallet(privateKey: key);
      } catch (e) {
        return null;
      }
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

  String getAddressC() {
    return evmWallet.address;
  }

  String getEvmAddressBech() {
    final keyPair = ROIKeyPair(chainId: "C", hrp: roi.getHRP());
    keyPair.importKey(_keyBuff);
    return keyPair.getAddressString();
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

  ROIKeyChain _getKeyChainX() {
    return xChain.newKeyChain()..importKey(_privateKey);
  }

  ROIKeyChain _getKeyChainP() {
    return pChain.newKeyChain()..importKey(_privateKey);
  }
}

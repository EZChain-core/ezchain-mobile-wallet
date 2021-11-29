import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:wallet/roi/common/keychain/roi_key_chain.dart';

import 'package:wallet/roi/utils/bindtools.dart';
import 'package:wallet/roi/utils/constants.dart';
import 'package:wallet/roi/wallet/evm_wallet.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/wallet.dart';

class SingletonWallet extends WalletProvider implements UnsafeWallet {
  final String privateKey;

  late Uint8List keyBuff;

  late EvmWallet evmWallet;

  SingletonWallet({required this.privateKey}) {
    keyBuff = cb58Decode(privateKey.split("-")[1]);
    evmWallet = EvmWallet(privateKey: keyBuff);
  }

  factory SingletonWallet.fromEvmKey(String key) {
    final keyBuff = cb58Encode(Uint8List.fromList(HEX.decode(key)));
    final avmKeyStr = "$privateKeyPrefix$keyBuff";
    return SingletonWallet(privateKey: avmKeyStr);
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
    keyPair.importKey(keyBuff);
    return keyPair.getAddressString();
  }

  void signC() async {}

  void signEvm() async {}

  void signP() async {}

  void signX() async {}

  ROIKeyChain _getKeyChainX() {
    return xChain.newKeyChain()..importKey(privateKey);
  }

  ROIKeyChain _getKeyChainP() {
    throw UnimplementedError();
  }
}

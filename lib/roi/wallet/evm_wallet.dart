import 'dart:typed_data';
import 'package:hex/hex.dart';

import 'package:pointycastle/export.dart';
import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/crypto/secp256k1.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

class EvmWallet {
  final Uint8List privateKey;
  late Uint8List publicKey;

  String get address => _address;
  late String _address;

  BigInt get balance => _balance;
  BigInt _balance = BigInt.from(0);

  EvmWallet({required this.privateKey}) {
    publicKey = _privateKeyToPublicKey(privateKey);
    _address = '0x' + HEX.encode(_publicKeyToAddress(publicKey));
  }

  String getAddressBech32() {
    final keyPair = ROIKeyPair(chainId: "C", hrp: roi.getHRP());
    final address = keyPair.addressFromPublicKey(publicKey);
    return addressToString("C", roi.getHRP(), address);
  }

  String getPrivateKeyHex() {
    return HEX.encode(privateKey);
  }

  ROIKeyChain getKeyChain() {
    return ROIKeyChain(chainId: "C", hrp: roi.getHRP())
      ..importKey(_getPrivateKeyBech());
  }

  ROIKeyPair getKeyPair() {
    final keyChain = ROIKeyChain(chainId: "C", hrp: roi.getHRP());
    return keyChain.importKey(_getPrivateKeyBech());
  }

  Future<BigInt> updateBalance() async {
    final bal = await web3.getBalance(EthereumAddress.fromHex(_address));
    _balance = bal.getValueInUnitBI(EtherUnit.ether);
    return _balance;
  }

  Future<void> signEvm(dynamic tx) async {}

  Future<void> signC(dynamic tx) async {}

  String _getPrivateKeyBech() {
    return "$privateKeyPrefix${cb58Encode(privateKey)}";
  }

  Uint8List _privateKeyToPublicKey(Uint8List privateKey) {
    final privateKeyNum = _decodeBigInt(privateKey);
    final p = params.G * privateKeyNum;
    return Uint8List.view(p!.getEncoded(false).buffer, 1);
  }

  BigInt _decodeBigInt(List<int> bytes) {
    BigInt result = BigInt.from(0);
    for (int i = 0; i < bytes.length; i++) {
      result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
    }
    return result;
  }

  Uint8List _publicKeyToAddress(Uint8List publicKey) {
    assert(publicKey.length == 64);
    const shaBytes = 256 ~/ 8;
    final hashed = SHA3Digest(shaBytes * 8).process(publicKey);
    return Uint8List.view(hashed.buffer, shaBytes - 20);
  }
}

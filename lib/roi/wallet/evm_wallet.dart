import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:wallet/roi/sdk/apis/evm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/evm/tx.dart';

import 'package:wallet/roi/sdk/crypto/secp256k1.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import 'package:sha3/sha3.dart';

// ignore: implementation_imports
import 'package:pointycastle/src/utils.dart' as pointycastle_utils;

class EvmWallet {
  final Uint8List privateKey;
  late Uint8List publicKey;

  String get address => _address;
  late String _address;

  BigInt get balance => _balance;
  BigInt _balance = BigInt.zero;

  EvmWallet({required this.privateKey}) {
    publicKey = privateKeyToPublicKey(privateKey);
    _address = '0x' + HEX.encode(publicKeyToAddress(publicKey));
  }

  String getAddressBech32() {
    final keyPair = EvmKeyPair(chainId: "C", hrp: roi.getHRP());
    final address = keyPair.addressFromPublicKey(publicKey);
    return addressToString("C", roi.getHRP(), address);
  }

  String getPrivateKeyHex() {
    return HEX.encode(privateKey);
  }

  EvmKeyChain getKeyChain() {
    return EvmKeyChain(chainId: "C", hrp: roi.getHRP())
      ..importKey(_getPrivateKeyBech());
  }

  EvmKeyPair getKeyPair() {
    final keyChain = EvmKeyChain(chainId: "C", hrp: roi.getHRP());
    return keyChain.importKey(_getPrivateKeyBech()) as EvmKeyPair;
  }

  Future<BigInt> updateBalance() async {
    final bal = await web3.getBalance(EthereumAddress.fromHex(_address));
    _balance = bal.getValueInUnitBI(EtherUnit.ether);
    return _balance;
  }

  Future<Uint8List> signEvm(Transaction tx) async {
    final credentials = EthPrivateKey.fromHex(getPrivateKeyHex());
    var signed = await web3.signTransaction(credentials, tx);
    if (tx.isEIP1559) {
      signed = prependTransactionType(0x02, signed);
    }
    return signed;
  }

  Future<EvmTx> signC(EvmUnsignedTx tx) async {
    return tx.sign(getKeyChain());
  }

  String _getPrivateKeyBech() {
    return bufferToPrivateKeyString(privateKey);
  }

  static Uint8List privateKeyToPublicKey(Uint8List privateKey) {
    assert(privateKey.length == 32);
    final privateKeyNum = pointycastle_utils.decodeBigInt(privateKey);
    final p = params.G * privateKeyNum;
    return Uint8List.view(p!.getEncoded(false).buffer, 1);
  }

  static Uint8List publicKeyToAddress(Uint8List publicKey) {
    assert(publicKey.length == 64);
    final hashed = SHA3(256, KECCAK_PADDING, 256).update(publicKey).digest();
    final length = hashed.length;
    return Uint8List.sublistView(
        Uint8List.fromList(hashed), length - 20, length);
  }

  static Uint8List privateKeyToAddress(Uint8List privateKey) {
    return publicKeyToAddress(privateKeyToPublicKey(privateKey));
  }
}

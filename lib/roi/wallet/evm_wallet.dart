import 'dart:typed_data';
import 'package:wallet/roi/sdk/apis/evm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/evm/tx.dart';

import 'package:wallet/roi/sdk/crypto/secp256k1.dart';
import 'package:wallet/roi/sdk/utils/bigint.dart';
import 'package:wallet/roi/sdk/utils/bintools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:web3dart/web3dart.dart';
import 'package:sha3/sha3.dart';

class EvmWallet {
  final Uint8List privateKey;
  late Uint8List publicKey;

  late String _address;

  BigInt _balance = BigInt.zero;

  EvmWallet({required this.privateKey}) {
    publicKey = privateKeyToPublicKey(privateKey);
    _address = '0x' + hexEncode(publicKeyToAddress(publicKey));
  }

  BigInt getBalance() {
    return _balance;
  }

  String getAddress() {
    return _address;
  }

  String getAddressBech32() {
    final compressedKey = privateKeyToPublicKey(privateKey, compressed: true);
    final keyPair = EvmKeyPair(chainId: "C", hrp: roi.getHRP());
    final address = keyPair.addressFromPublicKey(compressedKey);
    return addressToString("C", roi.getHRP(), address);
  }

  String getPrivateKeyHex() {
    return hexEncode(privateKey);
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
    _balance = bal.getValueInUnitBI(EtherUnit.wei);
    return _balance;
  }

  Future<Uint8List> signEvm(Transaction tx) async {
    final credentials = EthPrivateKey.fromHex(getPrivateKeyHex());
    final chainId = await web3.getChainId();
    var signed =
        await web3.signTransaction(credentials, tx, chainId: chainId.toInt());
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

  static Uint8List privateKeyToPublicKey(Uint8List privateKey,
      {bool compressed = false}) {
    assert(privateKey.length == 32);
    final privateKeyNum = decodeBigInt(privateKey);
    final p = params.G * privateKeyNum;
    return Uint8List.view(p!.getEncoded(compressed).buffer, compressed ? 0 : 1);
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

import 'dart:typed_data';
import 'package:wallet/ezc/sdk/apis/evm/tx.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';

import 'package:wallet/ezc/sdk/crypto/secp256k1.dart';
import 'package:wallet/ezc/sdk/utils/bigint.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
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
    final keyPair = EZCKeyPair(chainId: "C", hrp: ezc.getHRP());
    final address = keyPair.addressFromPublicKey(compressedKey);
    return addressToString("C", ezc.getHRP(), address);
  }

  String getPrivateKeyHex() {
    return hexEncode(privateKey);
  }

  EZCKeyChain getKeyChain() {
    return EZCKeyChain(chainId: "C", hrp: ezc.getHRP())
      ..importKey(_getPrivateKeyBech());
  }

  EZCKeyPair getKeyPair() {
    final keyChain = EZCKeyChain(chainId: "C", hrp: ezc.getHRP());
    return keyChain.importKey(_getPrivateKeyBech());
  }

  Future<BigInt> updateBalance() async {
    final bal = await web3Client.getBalance(EthereumAddress.fromHex(_address));
    _balance = bal.getValueInUnitBI(EtherUnit.wei);
    return _balance;
  }

  Future<Uint8List> signEvm(Transaction tx) async {
    final credentials = EthPrivateKey.fromHex(getPrivateKeyHex());
    final chainId = await web3Client.getChainId();
    var signed = await web3Client.signTransaction(
      credentials,
      tx,
      chainId: chainId.toInt(),
    );
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

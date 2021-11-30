import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:wallet/roi/sdk/apis/evm/tx.dart';

import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/crypto/secp256k1.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import 'package:sha3/sha3.dart';

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

  Future<Uint8List> signEvm(Transaction tx) async {
    final credentials = EthPrivateKey.fromHex(getPrivateKeyHex());
    return web3.signTransaction(credentials, tx);
  }

  Future<EvmTx> signC(EvmUnsignedTx tx) async {
    return tx.sign(getKeyChain());
  }

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
    final hashed = SHA3(256, KECCAK_PADDING, 256).update(publicKey).digest();
    final length = hashed.length;
    return Uint8List.sublistView(
        Uint8List.fromList(hashed), length - 20, length);
  }
}

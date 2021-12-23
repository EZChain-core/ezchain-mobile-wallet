import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/avm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/avm/tx.dart';
import 'package:wallet/roi/sdk/apis/evm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/evm/tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/pvm/tx.dart';
import 'package:wallet/roi/sdk/utils/hdnode.dart';
import 'package:wallet/roi/sdk/utils/mnemonic.dart';
import 'package:wallet/roi/wallet/evm_wallet.dart';
import 'package:wallet/roi/wallet/hd_wallet_abstract.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/utils/derivation_helper.dart';
import 'package:wallet/roi/wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';

class MnemonicWallet extends HDWalletAbstract implements UnsafeWallet {
  @override
  EvmWallet get evmWallet => _evmWallet;

  late EvmWallet _evmWallet;
  late HDNode ethAccountKey;

  final String mnemonic;
  final int accountIndex;

  MnemonicWallet({required this.mnemonic, this.accountIndex = 0}) {
    final seed = Mnemonic.instance.mnemonicToSeed(mnemonic);
    final hdNode = HDNode(from: seed);
    final accountKey = hdNode.derive(getAccountPathAvalanche(accountIndex));
    super.setAccountKey(accountKey);
    final ethAccountKey = hdNode.derive(getAccountPathEVM(accountIndex));
    final ethKey = ethAccountKey.privateKey;
    _evmWallet = EvmWallet(privateKey: ethKey!);
  }

  factory MnemonicWallet.create() {
    final mnemonic = generateMnemonicPhrase();
    return MnemonicWallet(mnemonic: mnemonic);
  }

  static MnemonicWallet? import(String mnemonic) {
    if (!validateMnemonic(mnemonic)) return null;
    return MnemonicWallet(mnemonic: mnemonic);
  }

  static String generateMnemonicPhrase() {
    return Mnemonic.instance.generateMnemonic();
  }

  static bool validateMnemonic(String mnemonic) {
    final words = mnemonic.split(" ");
    if (words.length != 24) return false;
    return Mnemonic.instance.validateMnemonic(mnemonic);
  }

  @override
  String getEvmPrivateKeyHex() {
    return evmWallet.getPrivateKeyHex();
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

  String getEvmAddressBech() {
    final keyPair = EvmKeyPair(chainId: "C", hrp: roi.getHRP());
    keyPair.importKey(ethAccountKey.publicKey!);
    return keyPair.getAddressString();
  }

  String getAddressC() {
    return evmWallet.getAddress();
  }

  AvmKeyChain _getKeyChainX() {
    final internal = internalScan.getKeyChainX();
    final external = internalScan.getKeyChainX();
    return internal.union(external) as AvmKeyChain;
  }

  PvmKeyChain _getKeyChainP() {
    return externalScan.getKeyChainP();
  }
}

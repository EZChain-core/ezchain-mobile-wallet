import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/avm/tx.dart';
import 'package:wallet/roi/sdk/apis/avm/utxos.dart';
import 'package:wallet/roi/sdk/apis/evm/tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/tx.dart';
import 'package:wallet/roi/sdk/utils/wait_tx_utils.dart';
import 'package:wallet/roi/wallet/evm_wallet.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:web3dart/web3dart.dart';

abstract class UnsafeWallet {
  String getEvmPrivateKeyHex();
}

abstract class WalletProvider {
  EvmWallet get evmWallet;

  final utxosX = AvmUTXOSet();

  Future<Uint8List> signEvm(Transaction tx);

  Future<AvmTx> signX(AvmUnsignedTx tx);

  Future<PvmTx> signP(PvmUnsignedTx tx);

  Future<EvmTx> signC(EvmUnsignedTx tx);

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

  Future<String> sendAvaxX(String to, BigInt amount, {String? memo}) async {
    final froms = await getAllAddressesX();
    final changeAddress = getChangeAddressX();
    final avaxId = activeNetwork.avaxId!;
    final Uint8List? memoBuff;
    if (memo != null) {
      memoBuff = Uint8List.fromList([]);
    } else {
      memoBuff = null;
    }
    final tx = await xChain.buildBaseTx(
        utxosX, amount, avaxId, [to], froms, [changeAddress], memoBuff);
    final signedTx = await signX(tx);
    final txId = await xChain.issueTx(signedTx);
    await waitTxX(txId);
    return txId;
  }
}

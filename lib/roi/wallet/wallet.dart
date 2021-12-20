import 'dart:convert';
import 'dart:typed_data';

import 'package:eventify/eventify.dart';
import 'package:wallet/roi/sdk/apis/avm/constants.dart';
import 'package:wallet/roi/sdk/apis/avm/outputs.dart';
import 'package:wallet/roi/sdk/apis/avm/tx.dart';
import 'package:wallet/roi/sdk/apis/avm/utxos.dart';
import 'package:wallet/roi/sdk/apis/evm/tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/tx.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/wallet/asset/assets.dart';
import 'package:wallet/roi/wallet/evm_wallet.dart';
import 'package:wallet/roi/wallet/helpers/utxo_helper.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/types/types.dart';
import 'package:wallet/roi/wallet/utils/wait_tx_utils.dart';
import 'package:web3dart/web3dart.dart';

abstract class UnsafeWallet {
  String getEvmPrivateKeyHex();
}

abstract class WalletProvider {
  EvmWallet get evmWallet;

  AvmUTXOSet utxosX = AvmUTXOSet();

  WalletBalanceX balanceX = {};

  EventEmitter emitter = EventEmitter();

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

  void on(WalletEventType event) {}

  void off(WalletEventType event) {}

  void emit(WalletEventType event, dynamic args) {
    // emitter.emit(event.type);
  }

  void emitBalanceChangeX() {}

  Future<String> sendAvaxX(String to, BigInt amount, {String? memo}) async {
    final Uint8List? memoBuff;
    if (memo != null) {
      memoBuff = Uint8List.fromList(utf8.encode(memo));
    } else {
      memoBuff = null;
    }
    final froms = await getAllAddressesX();
    final changeAddress = getChangeAddressX();
    final utxoSet = utxosX;
    final tx = await xChain.buildBaseTx(
      utxoSet,
      amount,
      activeNetwork.avaxId!,
      [to],
      froms,
      [changeAddress],
      memo: memoBuff,
    );
    final signedTx = await signX(tx);
    final String txId;
    try {
      txId = await xChain.issueTx(signedTx);
    } catch (e) {
      throw Exception("txId cannot be null");
    }
    await waitTxX(txId);
    return txId;
  }

  Future<AvmUTXOSet> updateUtxosX() async {
    final addresses = await getAllAddressesX();
    utxosX = await avmGetAllUTXOs(addresses: addresses);
    await _updateUnknownAssetsX();
    await _updateBalanceX();
    return utxosX;
  }

  Future<void> _updateUnknownAssetsX() async {
    final utxos = utxosX.getAllUTXOs();
    final assetIds =
        utxos.map((utxo) => cb58Encode(utxo.getAssetId())).toSet().toList();
    final futures = assetIds.map((id) => getAssetDescription(id));
    await Future.wait(futures);
  }

  Future<WalletBalanceX> _updateBalanceX() async {
    final utxos = utxosX.getAllUTXOs();
    final now = unixNow();

    final WalletBalanceX balanceX = {};

    for (int i = 0; i < utxos.length; i++) {
      final utxo = utxos[i];
      final out = utxo.getOutput();
      final type = out.getOutputId();
      if (type != SECPXFEROUTPUTID) continue;
      final lockTime = out.getLockTime();
      final amount = (out as AvmAmountOutput).getAmount();
      final assetIdBuff = utxo.getAssetId();
      final assetId = cb58Encode(assetIdBuff);

      var asset = balanceX[assetId];

      if (asset == null) {
        final assetInfo = await getAssetDescription(assetId);
        asset = AssetBalanceX(
            locked: BigInt.zero, unlocked: BigInt.zero, meta: assetInfo);
      }

      if (lockTime <= now) {
        asset.unlocked += amount;
      } else {
        asset.locked += amount;
      }
      balanceX[assetId] = asset;
    }
    final avaxId = activeNetwork.avaxId;

    if (!balanceX.containsKey(avaxId) && avaxId != null) {
      final assetInfo = await getAssetDescription(avaxId);
      balanceX[avaxId] = AssetBalanceX(
          locked: BigInt.zero, unlocked: BigInt.zero, meta: assetInfo);
    }

    this.balanceX = balanceX;

    emitBalanceChangeX();

    return balanceX;
  }

  WalletBalanceX getBalanceX() {
    return balanceX;
  }
}

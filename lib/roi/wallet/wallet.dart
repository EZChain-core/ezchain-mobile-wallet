import 'dart:convert';
import 'dart:typed_data';

import 'package:eventify/eventify.dart';
import 'package:wallet/roi/sdk/apis/avm/constants.dart' as avmConstants;
import 'package:wallet/roi/sdk/apis/avm/outputs.dart';
import 'package:wallet/roi/sdk/apis/avm/tx.dart';
import 'package:wallet/roi/sdk/apis/avm/utxos.dart';
import 'package:wallet/roi/sdk/apis/evm/tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/constants.dart' as pvmConstants;
import 'package:wallet/roi/sdk/apis/pvm/outputs.dart';
import 'package:wallet/roi/sdk/apis/pvm/tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/utxos.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/wallet/asset/assets.dart';
import 'package:wallet/roi/wallet/evm_wallet.dart';
import 'package:wallet/roi/wallet/helpers/tx_helper.dart';
import 'package:wallet/roi/wallet/helpers/utxo_helper.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/types.dart';
import 'package:wallet/roi/wallet/utils/wait_tx_utils.dart';
import 'package:web3dart/web3dart.dart';

abstract class UnsafeWallet {
  String getEvmPrivateKeyHex();
}

abstract class WalletProvider {
  EvmWallet get evmWallet;

  AvmUTXOSet utxosX = AvmUTXOSet();
  PvmUTXOSet utxosP = PvmUTXOSet();

  WalletBalanceX balanceX = {};

  EventEmitter emitter = EventEmitter();

  Future<Uint8List> signEvm(Transaction tx);

  Future<AvmTx> signX(AvmUnsignedTx tx);

  Future<PvmTx> signP(PvmUnsignedTx tx);

  Future<EvmTx> signC(EvmUnsignedTx tx);

  String getAddressX();

  String getChangeAddressX();

  String getAddressP();

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

  void on(WalletEventType event, EventCallback callback) {
    emitter.on(event.type, null, callback);
  }

  void off(WalletEventType event, EventCallback callback) {
    emitter.removeListener(event.type, callback);
  }

  void emit(WalletEventType event, dynamic args) {
    emitter.emit(event.type, null, args);
  }

  void emitAddressChange() {
    emit(WalletEventType.addressChanged, "emitAddressChange Test");
  }

  void emitBalanceChangeX() {
    emit(WalletEventType.balanceChangedX, balanceX);
  }

  void emitBalanceChangeP() {
    emit(WalletEventType.balanceChangedP, getBalanceP());
  }

  void emitBalanceChangeC() {
    emit(WalletEventType.balanceChangedC, getBalanceC());
  }

  String getAddressC() {
    return evmWallet.getAddress();
  }

  String getEvmAddressBech() {
    return evmWallet.getAddressBech32();
  }

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
    updateUtxosX();
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
      if (type != avmConstants.SECPXFEROUTPUTID) continue;
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

  Future<String> sendAvaxC(
      String to, BigInt amount, BigInt gasPrice, int gasLimit) async {
    assert(amount > BigInt.zero);
    final fromAddress = getAddressC();
    final tx = await buildEvmTransferNativeTx(
        fromAddress, to, amount, gasPrice, gasLimit);
    final txId = await issueEvmTx(tx);
    await updateAvaxBalanceC();
    return txId;
  }

  Future<BigInt> estimateGas(String to, String data) async {
    final from = EthereumAddress.fromHex(getAddressC());
    return await web3.estimateGas(
        sender: from,
        to: EthereumAddress.fromHex(to),
        data: Uint8List.fromList(utf8.encode(data)));
  }

  Future<BigInt> estimateAvaxGasLimit(
      String to, BigInt amount, BigInt gasPrice) async {
    final from = getAddressC();
    return await estimateAvaxGas(from, to, amount, gasPrice);
  }

  Future<String> issueEvmTx(Transaction tx) async {
    final signedTx = await signEvm(tx);
    final txHash = await web3.sendRawTransaction(signedTx);
    return await waitTxEvm(txHash);
  }

  Future<BigInt> updateAvaxBalanceC() async {
    final balOld = evmWallet.getBalance();
    final balNew = await evmWallet.updateBalance();
    if (balOld != balNew) {
      emitBalanceChangeC();
    }
    return balNew;
  }

  WalletBalanceC getBalanceC() {
    return WalletBalanceC(balance: evmWallet.getBalance());
  }

  Future<dynamic> updateUtxosP() async {
    final addresses = await getAllAddressesP();
    utxosP = await pvmGetAllUTXOs(addresses: addresses);

    emitBalanceChangeP();

    return utxosP;
  }

  WalletBalanceP getBalanceP() {
    var unlocked = BigInt.zero;
    var locked = BigInt.zero;
    var lockedStakeable = BigInt.zero;

    final utxos = utxosP.getAllUTXOs();
    final now = unixNow();

    for (var i = 0; i < utxos.length; i++) {
      final utxo = utxos[i];
      final out = utxo.getOutput();
      final type = out.getOutputId();
      final amount = (out as PvmAmountOutput).getAmount();
      if (type == pvmConstants.STAKEABLELOCKOUTID) {
        final lockTime = (out as PvmStakeableLockOut).getStakeableLockTime();
        if (lockTime <= now) {
          unlocked += amount;
        } else {
          lockedStakeable += amount;
        }
      } else {
        final lockTime = out.getLockTime();
        if (lockTime <= now) {
          unlocked += amount;
        } else {
          locked += amount;
        }
      }
    }

    return WalletBalanceP(
        unlocked: unlocked, locked: locked, lockedStakeable: lockedStakeable);
  }
}

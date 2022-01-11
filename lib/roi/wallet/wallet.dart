import 'dart:convert';
import 'dart:typed_data';

import 'package:eventify/eventify.dart';
import 'package:wallet/roi/sdk/apis/avm/constants.dart' as avm_constants;
import 'package:wallet/roi/sdk/apis/avm/outputs.dart';
import 'package:wallet/roi/sdk/apis/avm/tx.dart';
import 'package:wallet/roi/sdk/apis/avm/utxos.dart';
import 'package:wallet/roi/sdk/apis/evm/tx.dart';
import 'package:wallet/roi/sdk/apis/evm/utxos.dart';
import 'package:wallet/roi/sdk/apis/pvm/constants.dart' as pvmConstants;
import 'package:wallet/roi/sdk/apis/pvm/model/get_stake.dart';
import 'package:wallet/roi/sdk/apis/pvm/outputs.dart';
import 'package:wallet/roi/sdk/apis/pvm/tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/utxos.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/wallet/asset/assets.dart';
import 'package:wallet/roi/wallet/evm_wallet.dart';
import 'package:wallet/roi/wallet/helpers/gas_helper.dart';
import 'package:wallet/roi/wallet/helpers/tx_helper.dart';
import 'package:wallet/roi/wallet/helpers/utxo_helper.dart';
import 'package:wallet/roi/wallet/network/helpers/id_from_alias.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/types.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';
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
      if (type != avm_constants.SECPXFEROUTPUTID) continue;
      final lockTime = out.getLockTime();
      final amount = (out as AvmAmountOutput).getAmount();
      final assetIdBuff = utxo.getAssetId();
      final assetId = cb58Encode(assetIdBuff);

      var asset = balanceX[assetId];

      if (asset == null) {
        final assetInfo = await getAssetDescription(assetId);
        asset = AssetBalanceX(
          locked: BigInt.zero,
          unlocked: BigInt.zero,
          meta: assetInfo,
        );
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
        locked: BigInt.zero,
        unlocked: BigInt.zero,
        meta: assetInfo,
      );
    }

    this.balanceX = balanceX;

    emitBalanceChangeX();

    return balanceX;
  }

  WalletBalanceX getBalanceX() {
    return balanceX;
  }

  AssetBalanceRawX getAvaxBalanceX() {
    return getBalanceX()[activeNetwork.avaxId] ??
        AssetBalanceRawX(locked: BigInt.zero, unlocked: BigInt.zero);
  }

  /// Exports ROI from X chain to either P or C chain
  /// @remarks
  /// The export fee will be added to the amount automatically. Make sure the exported amount has the import fee for the destination chain.
  ///
  /// @param amt amount of nROI to transfer
  /// @param destinationChain Which chain to export to.
  /// @return returns the transaction id.
  Future<String> exportXChain(
      BigInt amount, ExportChainsX destinationChain) async {
    final destinationAddress = destinationChain == ExportChainsX.P
        ? getAddressP()
        : getEvmAddressBech();
    final fromAddresses = await getAllAddressesX();
    final changeAddress = getChangeAddressX();
    final utxos = utxosX;
    final exportTx = await buildAvmExportTransaction(
      destinationChain,
      utxos,
      fromAddresses,
      destinationAddress,
      amount,
      changeAddress,
    );

    final signedTx = await signX(exportTx);

    final String txId;
    try {
      txId = await xChain.issueTx(signedTx);
    } catch (e) {
      throw Exception("txId cannot be null");
    }

    await waitTxX(txId);
    await updateUtxosX();

    return txId;
  }

  Future<String> importXChain(ExportChainsX sourceChain) async {
    final utxoSet = await getAtomicUTXOsX(sourceChain);
    if (utxoSet.getAllUTXOs().isEmpty) {
      throw Exception("Nothing to import.");
    }
    final xToAddress = getAddressX();
    final hrp = roi.getHRP();
    final utxoAddresses = utxoSet
        .getAddresses()
        .map((address) => addressToString("X", hrp, address))
        .toList();
    final fromAddresses = utxoAddresses;
    final ownerAddresses = utxoAddresses;
    final sourceChainId = chainIdFromAlias(sourceChain.value);
    final unsignedTx = await xChain.buildImportTx(
      utxoSet,
      ownerAddresses,
      sourceChainId,
      [xToAddress],
      fromAddresses,
      changeAddresses: [xToAddress],
    );
    final signedTx = await signX(unsignedTx);
    final String txId;
    try {
      txId = await xChain.issueTx(signedTx);
    } catch (e) {
      throw Exception("txId cannot be null");
    }
    await waitTxX(txId);
    await updateUtxosX();
    return txId;
  }

  Future<AvmUTXOSet> getAtomicUTXOsX(ExportChainsX sourceChain) async {
    final addresses = await getAllAddressesX();
    return await avmGetAtomicUTXOs(addresses, sourceChain);
  }

  Future<String> sendAvaxC(
      String to, BigInt amount, BigInt gasPrice, int gasLimit) async {
    assert(amount > BigInt.zero);
    final fromAddress = getAddressC();
    final tx = await buildEvmTransferNativeTx(
      fromAddress,
      to,
      amount,
      gasPrice,
      gasLimit,
    );
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

  /// Exports ROI from C chain to X chain
  /// @remarks
  /// Make sure the exported `amt` includes the import fee for the destination chain.
  ///
  /// @param amt amount of nROI to transfer
  /// @param destinationChain either `X` or `P`
  /// @param exportFee Export fee in nAVAX
  /// @return returns the transaction id.
  Future<String> exportCChain(BigInt amount, ExportChainsC destinationChain,
      {BigInt? exportFee}) async {
    final hexAddress = getAddressC();
    final bechAddress = getEvmAddressBech();
    final fromAddresses = [hexAddress];
    final destinationAddress =
        destinationChain == ExportChainsC.X ? getAddressX() : getAddressP();

    if (exportFee == null) {
      final exportGas = estimateExportGasFeeFromMockTx(
        destinationChain,
        amount,
        hexAddress,
        destinationAddress,
      );
      final baseFee = await getBaseFeeRecommended();
      exportFee = avaxCtoX(baseFee * BigInt.from(exportGas));
    }

    final unsignedTx = await buildEvmExportTransaction(
      fromAddresses,
      destinationAddress,
      amount,
      bechAddress,
      destinationChain,
      exportFee,
    );

    final signedTx = await signC(unsignedTx);
    final String txId;
    try {
      txId = await cChain.issueTx(signedTx);
    } catch (e) {
      throw Exception("txId cannot be null");
    }
    await waitTxC(txId);
    await updateAvaxBalanceC();
    return txId;
  }

  Future<String> importCChain(ExportChainsC sourceChain,
      {BigInt? fee, EvmUTXOSet? utxoSet}) async {
    final bechAddress = getEvmAddressBech();

    utxoSet ??= await getAtomicUTXOsC(sourceChain);

    final utxos = utxoSet.getAllUTXOs();
    if (utxos.isEmpty) {
      throw Exception('Nothing to import.');
    }
    final toAddress = getAddressC();
    final ownerAddresses = [bechAddress];
    final fromAddresses = ownerAddresses;
    final sourceChainId = chainIdFromAlias(sourceChain.value);
    if (fee == null) {
      final numSigs = utxos.fold<int>(
          0, (acc, utxo) => acc + utxo.getOutput().getAddresses().length);
      final numIns = utxos.length;
      final importGas = estimateImportGasFeeFromMockTx(numIns, numSigs);
      final baseFee = await getBaseFeeRecommended();
      fee = avaxCtoX(baseFee * BigInt.from(importGas));
    }
    final unsignedTx = await cChain.buildImportTx(
      utxoSet,
      toAddress,
      ownerAddresses,
      sourceChainId,
      fromAddresses,
      fee: fee,
    );
    final signedTx = await signC(unsignedTx);
    final String txId;
    try {
      txId = await cChain.issueTx(signedTx);
    } catch (e) {
      throw Exception("txId cannot be null");
    }
    await waitTxC(txId);
    await updateAvaxBalanceC();
    return txId;
  }

  Future<EvmUTXOSet> getAtomicUTXOsC(ExportChainsC sourceChain) async {
    final bechAddress = getEvmAddressBech();
    return await evmGetAtomicUTXOs([bechAddress], sourceChain);
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

  AssetBalanceP getBalanceP() {
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

    return AssetBalanceP(
        unlocked: unlocked, locked: locked, lockedStakeable: lockedStakeable);
  }

  AvaxBalance getAvaxBalance() {
    return AvaxBalance(
      x: getAvaxBalanceX(),
      p: getBalanceP(),
      c: getBalanceC().balance,
    );
  }

  Future<GetStakeResponse> getStake() async {
    final addresses = await getAllAddressesP();
    return await getStakeForAddresses(addresses);
  }

  Future<String> importPChain(ExportChainsP sourceChain,
      {String? toAddress}) async {
    final utxoSet = await getAtomicUTXOsP(sourceChain);
    if (utxoSet.getAllUTXOs().isEmpty) {
      throw Exception("Nothing to import.");
    }
    final walletAddressP = getAddressP();
    final hrp = roi.getHRP();
    final utxoAddresses = utxoSet
        .getAddresses()
        .map((address) => addressToString("P", hrp, address))
        .toList();
    final ownerAddresses = utxoAddresses;
    toAddress ??= walletAddressP;
    final sourceChainId = chainIdFromAlias(sourceChain.value);
    final unsignedTx = await pChain.buildImportTx(
      utxoSet,
      ownerAddresses,
      sourceChainId,
      [toAddress],
      ownerAddresses,
      changeAddresses: [walletAddressP],
    );
    final signedTx = await signP(unsignedTx);
    final String txId;
    try {
      txId = await pChain.issueTx(signedTx);
    } catch (e) {
      throw Exception("txId cannot be null");
    }
    await waitTxP(txId);
    await updateUtxosP();
    return txId;
  }

  /// Exports ROI from P chain to X chain
  /// @remarks
  /// The export fee is added automatically to the amount. Make sure the exported amount includes the import fee for the destination chain.
  ///
  /// @param amt amount of nROI to transfer. Fees excluded.
  /// @param destinationChain Either `X` or `C`
  /// @return returns the transaction id.
  Future<String> exportPChain(
      BigInt amount, ExportChainsP destinationChain) async {
    final pChangeAddress = getAddressP();
    final fromAddresses = await getAllAddressesP();
    final destinationAddress = destinationChain == ExportChainsP.X
        ? getAddressX()
        : getEvmAddressBech();
    final utxoSet = utxosP;

    final unsignedTx = await buildPvmExportTransaction(
      utxoSet,
      fromAddresses,
      destinationAddress,
      amount,
      pChangeAddress,
      destinationChain,
    );
    final signedTx = await signP(unsignedTx);
    final String txId;
    try {
      txId = await pChain.issueTx(signedTx);
    } catch (e) {
      throw Exception("txId cannot be null");
    }
    await waitTxP(txId);
    await updateUtxosP();
    return txId;
  }

  Future<PvmUTXOSet> getAtomicUTXOsP(ExportChainsP sourceChain) async {
    final addresses = await getAllAddressesP();
    return await platformGetAtomicUTXOs(addresses, sourceChain);
  }
}

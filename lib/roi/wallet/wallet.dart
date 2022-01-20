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
import 'package:wallet/roi/wallet/helpers/tx_helper.dart';
import 'package:wallet/roi/wallet/helpers/utxo_helper.dart';
import 'package:wallet/roi/wallet/history/api_helpers.dart';
import 'package:wallet/roi/wallet/history/raw_types.dart';
import 'package:wallet/roi/wallet/network/helpers/id_from_alias.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/types.dart';
import 'package:wallet/roi/wallet/utils/fee_utils.dart';
import 'package:wallet/roi/wallet/utils/wait_tx_utils.dart';
import 'package:web3dart/web3dart.dart' as web3_dart;

abstract class UnsafeWallet {
  String getEvmPrivateKeyHex();
}

abstract class WalletProvider {
  EvmWallet get evmWallet;

  ///  Returns the fetched UTXOs on the X chain that belong to this wallet.
  AvmUTXOSet utxosX = AvmUTXOSet();

  /// Returns the fetched UTXOs on the P chain that belong to this wallet.
  PvmUTXOSet utxosP = PvmUTXOSet();

  WalletBalanceX balanceX = {};

  EventEmitter emitter = EventEmitter();

  Future<Uint8List> signEvm(web3_dart.Transaction tx);

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

  AvaxBalance getAvaxBalance() {
    return AvaxBalance(
      x: getAvaxBalanceX(),
      p: getBalanceP(),
      c: getBalanceC().balance,
    );
  }

  /// Gets the active address on the C chain
  /// @return Hex representation of the EVM address.
  String getAddressC() {
    return evmWallet.getAddress();
  }

  String getEvmAddressBech() {
    return evmWallet.getAddressBech32();
  }

  /// @param to - the address funds are being send to.
  /// @param amount - amount of EZC to send in EZC
  /// @param memo - A MEMO for the transaction
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

  ///  Returns UTXOs on the X chain that belong to this wallet.
  ///  - Makes network request.
  ///  - Updates `this.utxosX` with new UTXOs
  ///  - Calls `this.updateBalanceX()` after success.
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

  /// Uses the X chain UTXOs owned by this wallet, gets asset description for unknown assets,
  /// and returns a dictionary of Asset IDs to balance amounts.
  /// - Updates `this.balanceX`
  /// - Expensive operation if there are unknown assets
  /// - Uses existing UTXOs
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

  /// A helpful method that returns the EZC balance on X, P, C chains.
  /// Internally calls chain specific getEzcBalance methods.
  WalletBalanceX getBalanceX() {
    return balanceX;
  }

  /// Returns the X chain EZC balance of the current wallet state.
  /// - Does not make a network request.
  /// - Does not refresh wallet balance.
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
    BigInt amount,
    ExportChainsX destinationChain,
  ) async {
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

  /// Imports atomic X chain UTXOs to the current active X chain address
  /// @param sourceChain The chain to import from, either `P` or `C`
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

  /// Sends EZC to another address on the C chain using legacy transaction format.
  /// @param to Hex address to send EZC to.
  /// @param amount Amount of EZC to send, represented in WEI format.
  /// @param gasPrice Gas price in WEI format
  /// @param gasLimit Gas limit
  ///
  /// @return Returns the transaction hash
  Future<String> sendAvaxC(
    String to,
    BigInt amount,
    BigInt gasPrice,
    int gasLimit,
  ) async {
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

  /// Estimate gas limit for the given inputs.
  /// @param to
  /// @param data
  Future<BigInt> estimateGas(String to, String data) async {
    final from = web3_dart.EthereumAddress.fromHex(getAddressC());
    return await web3.estimateGas(
        sender: from,
        to: web3_dart.EthereumAddress.fromHex(to),
        data: Uint8List.fromList(utf8.encode(data)));
  }

  /// Estimate the gas needed for a EZC send transaction on the C chain.
  /// @param to Destination address.
  /// @param amount Amount of EZC to send, in WEI.
  Future<BigInt> estimateAvaxGasLimit(
    String to,
    BigInt amount,
    BigInt gasPrice,
  ) async {
    final from = getAddressC();
    return await estimateAvaxGas(from, to, amount, gasPrice);
  }

  /// Given a `Transaction`, it will sign and issue it to the network.
  /// @param tx The unsigned transaction to issue.
  Future<String> issueEvmTx(web3_dart.Transaction tx) async {
    final signedTx = await signEvm(tx);
    final txHash = await web3.sendRawTransaction(signedTx);
    return await waitTxEvm(txHash);
  }

  /// Returns the C chain EZC balance of the wallet in WEI format.
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
  /// @param exportFee Export fee in nEZC
  /// @return returns the transaction id.
  Future<String> exportCChain(
    BigInt amount,
    ExportChainsC destinationChain, {
    BigInt? exportFee,
  }) async {
    final hexAddress = getAddressC();
    final bechAddress = getEvmAddressBech();
    final fromAddresses = [hexAddress];
    final destinationAddress =
        destinationChain == ExportChainsC.X ? getAddressX() : getAddressP();

    exportFee ??= await estimateExportGasFee(
      destinationChain,
      amount,
      hexAddress,
      destinationAddress,
    );

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

  /// @param sourceChain Which chain to import from. `X` or `P`
  /// @param [fee] The import fee to use in the transaction. If omitted the SDK will try to calculate the fee. For deterministic transaction you should always pre calculate and provide this value.
  /// @param [utxoSet] If omitted imports all atomic UTXOs.
  Future<String> importCChain(
    ExportChainsC sourceChain, {
    BigInt? fee,
    EvmUTXOSet? utxoSet,
  }) async {
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
      final numIns = utxos.length;
      final numSigs = utxos.fold<int>(
          0, (acc, utxo) => acc + utxo.getOutput().getAddresses().length);
      fee = await estimateImportGasFee(numIns: numIns, numSigs: numSigs);
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

  ///  Returns UTXOs on the P chain that belong to this wallet.
  ///  - Makes network request.
  ///  - Updates `this.utxosP` with the new UTXOs
  Future<PvmUTXOSet> updateUtxosP() async {
    final addresses = await getAllAddressesP();
    utxosP = await pvmGetAllUTXOs(addresses: addresses);

    emitBalanceChangeP();

    return utxosP;
  }

  /// Returns the P chain EZC balance of the current wallet state.
  /// - Does not make a network request.
  /// - Does not refresh wallet balance.
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
      unlocked: unlocked,
      locked: locked,
      lockedStakeable: lockedStakeable,
    );
  }

  /// Returns the number AZC staked by this wallet.
  Future<GetStakeResponse> getStake() async {
    final addresses = await getAllAddressesP();
    return await getStakeForAddresses(addresses);
  }

  /// Import utxos in atomic memory to the P chain.
  /// @param sourceChain Either `X` or `C`
  /// @param [toAddress] The destination P chain address assets will get imported to. Defaults to the P chain address of the wallet.
  Future<String> importPChain(
    ExportChainsP sourceChain, {
    String? toAddress,
  }) async {
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

  /// Exports EZC from P chain to X chain
  /// @remarks
  /// The export fee is added automatically to the amount. Make sure the exported amount includes the import fee for the destination chain.
  ///
  /// @param amt amount of nEZC to transfer. Fees excluded.
  /// @param destinationChain Either `X` or `C`
  /// @return returns the transaction id.
  Future<String> exportPChain(
    BigInt amount,
    ExportChainsP destinationChain,
  ) async {
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

  Future<List<Transaction>> getHistoryX({int limit = 0}) async {
    final addresses = await getAllAddressesX();
    return await getAddressHistory(
      xChain.getBlockchainId(),
      addresses,
      limit: limit,
    );
  }

  Future<List<Transaction>> getHistoryP({int limit = 0}) async {
    final addresses = await getAllAddressesP();
    return await getAddressHistory(
      pChain.getBlockchainId(),
      addresses,
      limit: limit,
    );
  }

  Future<List<Transaction>> getHistoryC({int limit = 0}) async {
    final addresses = [getEvmAddressBech(), ...(await getAllAddressesP())];
    return await getAddressHistory(
      cChain.getBlockchainId(),
      addresses,
      limit: limit,
    );
  }
}

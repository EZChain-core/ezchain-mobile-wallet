import 'dart:convert';
import 'dart:typed_data';

import 'package:eventify/eventify.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart' as avm_constants;
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/tx.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/apis/evm/tx.dart';
import 'package:wallet/ezc/sdk/apis/evm/utxos.dart';
import 'package:wallet/ezc/sdk/apis/pvm/constants.dart' as pvm_constants;
import 'package:wallet/ezc/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_min_stake.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_pending_validators.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_stake.dart';
import 'package:wallet/ezc/sdk/apis/pvm/outputs.dart';
import 'package:wallet/ezc/sdk/apis/pvm/tx.dart';
import 'package:wallet/ezc/sdk/apis/pvm/utxos.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';
import 'package:wallet/ezc/sdk/utils/payload.dart';
import 'package:wallet/ezc/wallet/asset/assets.dart';
import 'package:wallet/ezc/wallet/asset/types.dart';
import 'package:wallet/ezc/wallet/evm_wallet.dart';
import 'package:wallet/ezc/wallet/explorer/cchain/requests.dart'
    as cchain_explorer_request;
import 'package:wallet/ezc/wallet/explorer/cchain/types.dart';
import 'package:wallet/ezc/wallet/explorer/ortelius/types.dart';
import 'package:wallet/ezc/wallet/helpers/tx_helper.dart';
import 'package:wallet/ezc/wallet/helpers/utxo_helper.dart';
import 'package:wallet/ezc/wallet/history/types.dart';
import 'package:wallet/ezc/wallet/network/helpers/id_from_alias.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/history/parsers.dart';
import 'package:wallet/ezc/wallet/network/utils.dart';
import 'package:wallet/ezc/wallet/types.dart';
import 'package:wallet/ezc/wallet/utils/fee_utils.dart';
import 'package:wallet/ezc/wallet/utils/wait_tx_utils.dart';
import 'package:web3dart/web3dart.dart' as web3_dart;

import 'explorer/ortelius/requests.dart';

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

  var _unknownAssets = <AssetDescriptionClean>[];

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
    final from = await getAllAddressesX();
    final changeAddress = getChangeAddressX();
    final utxoSet = utxosX;
    final tx = await xChain.buildBaseTx(
      utxoSet,
      amount,
      getAvaxAssetId(),
      [to],
      from,
      [changeAddress],
      memo: memoBuff,
    );
    final signedTx = await signX(tx);
    final String txId = await xChain.issueTx(signedTx);
    await waitTxX(txId);
    await updateUtxosX();
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
    _unknownAssets = await Future.wait(futures);
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
    final avaxId = getAvaxAssetId();

    if (!balanceX.containsKey(avaxId)) {
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
  WalletBalanceX getBalanceX() => balanceX;

  List<AssetDescriptionClean> getUnknownAssets() => _unknownAssets;

  /// Returns the X chain EZC balance of the current wallet state.
  /// - Does not make a network request.
  /// - Does not refresh wallet balance.
  AssetBalanceRawX getAvaxBalanceX() {
    return getBalanceX()[getAvaxAssetId()] ??
        AssetBalanceRawX(locked: BigInt.zero, unlocked: BigInt.zero);
  }

  /// Exports EZC from X chain to either P or C chain
  /// @remarks
  /// The export fee will be added to the amount automatically. Make sure the exported amount has the import fee for the destination chain.
  ///
  /// @param amt amount of EZC to transfer
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
    final String txId = await xChain.issueTx(signedTx);
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
    final hrp = ezc.getHRP();
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
    final String txId = await xChain.issueTx(signedTx);
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
      data: Uint8List.fromList(utf8.encode(data)),
    );
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
    final balNew = await evmWallet.updateBalance();
    emitBalanceChangeC();
    return balNew;
  }

  /// Exports EZC from C chain to X chain
  /// @remarks
  /// Make sure the exported `amt` includes the import fee for the destination chain.
  ///
  /// @param amt amount of EZC to transfer
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
    final String txId = await cChain.issueTx(signedTx);
    await waitTxC(txId);
    await updateAvaxBalanceC();
    return txId;
  }

  /// @param sourceChain Which chain to import from. `X` or `P`
  /// @param [fee] The import fee to use in the transactions. If omitted the SDK will try to calculate the fee. For deterministic transactions you should always pre calculate and provide this value.
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
    final String txId = await cChain.issueTx(signedTx);
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
      if (type == pvm_constants.STAKEABLELOCKOUTID) {
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
    final hrp = ezc.getHRP();
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
    final String txId = await pChain.issueTx(signedTx);
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
    final String txId = await pChain.issueTx(signedTx);
    await waitTxP(txId);
    await updateUtxosP();
    return txId;
  }

  Future<PvmUTXOSet> getAtomicUTXOsP(ExportChainsP sourceChain) async {
    final addresses = await getAllAddressesP();
    return await platformGetAtomicUTXOs(addresses, sourceChain);
  }

  Future<List<Validator>> getPlatformValidators({
    String? subnetId,
    List<String>? nodeIds,
  }) async {
    return pChain.getCurrentValidators(subnetId: subnetId, nodeIds: nodeIds);
  }

  Future<GetPendingValidatorsResponse> getPlatformPendingValidators({
    String? subnetId,
    List<String>? nodeIds,
  }) async {
    return pChain.getPendingValidators(subnetId: subnetId, nodeIds: nodeIds);
  }

  Future<GetMinStakeResponse> getMinStake() async {
    return pChain.getMinStake();
  }

  Future<BigInt> getCurrentSupply() async {
    return pChain.getCurrentSupply();
  }

  Future<String> delegate(
    String nodeId,
    BigInt amount,
    num start,
    num end, {
    String? rewardAddress,
    List<PvmUTXO>? utxos,
  }) async {
    var utxoSet = utxosP;
    final pAddressStrings = await getAllAddressesP();

    /// If given custom UTXO set use that
    if (utxos != null) {
      utxoSet = PvmUTXOSet();
      utxoSet.addArray(utxos);
    }

    /// If reward address isn't given use current P address
    rewardAddress ??= getAddressP();

    final stakeReturnAddress = getAddressP();

    /// For change address use the current platform chain
    final changeAddress = getAddressP();

    /// Convert dates to unix time
    final startTime = BigInt.from(start / 1000);
    final endTime = BigInt.from(end / 1000);

    final unsignedTx = await pChain.buildAddDelegatorTx(
        utxoSet,
        [stakeReturnAddress],
        pAddressStrings,
        [changeAddress],
        nodeId,
        startTime,
        endTime,
        amount,
        [rewardAddress]);
    final signedTx = await signP(unsignedTx);
    final String txId = await pChain.issueTx(signedTx);
    await waitTxP(txId);
    await updateUtxosP();
    return txId;
  }

  Future<List<OrteliusTx>> getXTransactions({int limit = 0}) async {
    final addresses = await getAllAddressesX();
    return await getAddressHistory(
      xChain.getBlockchainId(),
      addresses,
      limit: limit,
    );
  }

  Future<List<OrteliusTx>> getPTransactions({int limit = 0}) async {
    final addresses = await getAllAddressesP();
    return await getAddressHistory(
      pChain.getBlockchainId(),
      addresses,
      limit: limit,
    );
  }

  /// Returns atomic history for this wallet on the C chain.
  /// @remarks Excludes EVM transactions.
  /// @param limit
  Future<List<OrteliusTx>> getCTransactions({int limit = 0}) async {
    final addresses = [getEvmAddressBech(), ...(await getAllAddressesX())];
    return await getAddressHistory(
      cChain.getBlockchainId(),
      addresses,
      limit: limit,
    );
  }

  /// Fetches information about the given txId and parses it from the wallet's perspective
  /// @param txId
  Future<OrteliusTx> getTransaction(String txId) async {
    return await getTx(txId);
  }

  /// Returns history for this wallet on the C chain.
  /// @remarks Excludes atomic C chain import/export transactions.
  Future<List<OrteliusEvmTx>> getEvmTransactions() async {
    final address = getAddressC();
    return await getAddressHistoryEVM(address);
  }

  /// Fetches information about the given txId and parses it from the wallet's perspective
  /// @param txId
  Future<OrteliusEvmTx> getEvmTransaction(String txId) async {
    return await getEvmTx(txId);
  }

  Future<List<CChainExplorerTx>> getCChainTransactions({
    int page = 0,
    int offset = 0,
  }) async {
    final address = getAddressC();
    return await cchain_explorer_request.getCChainTransactions(address,
        page: page, offset: offset);
  }

  Future<CChainExplorerTxInfo> getCChainTransaction(String txHash) async {
    return await cchain_explorer_request.getCChainTransaction(txHash);
  }

  /// Fetches information about the given txId and parses it from the wallet's perspective
  /// @param txId
  Future<HistoryItem> getHistoryItemTx(String txId) async {
    final addressesX = await getAllAddressesX();
    final addressesC = getAddressC();
    final transaction = await getTransaction(txId);
    return await getTransactionSummary(transaction, addressesX, addressesC);
  }

  /// final addresses = [
  ///   ...await _wallet.getAllAddressesX(),
  ///   _wallet.getEvmAddressBech()
  /// ];
  /// final addressesC = _wallet.getAddressC();
  Future<HistoryItem> parseOrteliusTx(
    OrteliusTx tx,
    List<String> addresses,
    String addressesC,
  ) async {
    return await getTransactionSummary(tx, addresses, addressesC);
  }

  Future<String> createNFTFamily(
    String name,
    String symbol,
    int groupNum,
  ) async {
    final fromAddresses = await getAllAddressesX();
    final changeAddress = getChangeAddressX();
    final minterAddress = getAddressX();
    final utxoSet = utxosX;

    final unsignedTx = await buildCreateNFTFamilyTx(
      name,
      symbol,
      groupNum,
      fromAddresses,
      minterAddress,
      changeAddress,
      utxoSet,
    );
    final signed = await signX(unsignedTx);
    final txId = await xChain.issueTx(signed);
    await waitTxX(txId);
    await updateUtxosX();
    return txId;
  }

  Future<String> mintNFT(
    AvmUTXO mintUTXO,
    PayloadBase payload,
    int quantity,
  ) async {
    final ownerAddress = getAddressX();
    final changeAddress = getChangeAddressX();
    final sourceAddresses = await getAllAddressesX();
    final utxoSet = utxosX;
    final unsignedTx = await buildMintNFTTx(
      mintUTXO,
      payload,
      quantity,
      ownerAddress,
      changeAddress,
      sourceAddresses,
      utxoSet,
    );
    final signed = await signX(unsignedTx);
    final txId = await xChain.issueTx(signed);
    await waitTxX(txId);
    await updateUtxosX();
    return txId;
  }
}

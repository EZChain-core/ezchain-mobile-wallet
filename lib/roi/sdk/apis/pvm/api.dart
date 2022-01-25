import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/pvm/constants.dart';
import 'package:wallet/roi/sdk/apis/pvm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_stake.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_staking_asset_id.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_tx_status.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_utxos.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/issue_tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/rest_client.dart';
import 'package:wallet/roi/sdk/apis/pvm/tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/utxos.dart';
import 'package:wallet/roi/sdk/apis/roi_api.dart';
import 'package:wallet/roi/sdk/roi.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart' as bindtools;

abstract class PvmApi implements ROIChainApi {
  BigInt getTxFee();

  Future<PvmUnsignedTx> buildImportTx(
    PvmUTXOSet utxoSet,
    List<String> ownerAddresses,
    String sourceChain,
    List<String> toAddresses,
    List<String> fromAddresses, {
    List<String>? changeAddresses,
    Uint8List? memo,
    BigInt? asOf,
    BigInt? lockTime,
    int threshold = 1,
  });

  Future<PvmUnsignedTx> buildExportTx(
    PvmUTXOSet utxoSet,
    BigInt amount,
    String destinationChainId,
    List<String> toAddresses,
    List<String> fromAddresses, {
    List<String>? changeAddresses,
    Uint8List? memo,
    BigInt? asOf,
    BigInt? lockTime,
    int threshold = 1,
  });

  Future<String> issueTx(PvmTx tx);

  Future<GetUTXOsResponse> getUTXOs(
    List<String> addresses, {
    String? sourceChain,
    int limit = 0,
    GetUTXOsStartIndex? startIndex,
  });

  Future<GetStakeResponse> getStake(List<String> addresses);

  Future<Uint8List?> getAVAXAssetId({bool refresh = false});

  Future<GetStakingAssetIdResponse> getStakingAssetId({String? subnetId});

  Future<GetTxStatusResponse> getTxStatus(String txId);

  Future<List<Validator>> getCurrentValidators(
      {String? subnetId, List<String>? nodeIds});

  factory PvmApi.create(
      {required ROINetwork roiNetwork, String endPoint = "/ext/bc/P"}) {
    return _PvmApiImpl(
        roiNetwork: roiNetwork,
        endPoint: endPoint,
        blockChainId: platformChainId);
  }
}

class _PvmApiImpl implements PvmApi {
  @override
  ROINetwork roiNetwork;

  @override
  PvmKeyChain get keyChain => _keyChain;

  late PvmKeyChain _keyChain;

  String blockChainId;

  String? blockchainAlias;

  Uint8List? avaxAssetId;

  BigInt? _txFee;

  late PvmRestClient pvmRestClient;

  _PvmApiImpl(
      {required this.roiNetwork,
      required String endPoint,
      required this.blockChainId}) {
    final networkId = roiNetwork.networkId;
    final network = networks[networkId];
    final String alias;
    if (network != null) {
      alias = network.findAliasByBlockChainId(blockChainId) ?? "";
    } else {
      alias = blockChainId;
    }
    _keyChain = PvmKeyChain(chainId: alias, hrp: roiNetwork.hrp);
    final dio = roiNetwork.dio;
    pvmRestClient = PvmRestClient(dio, baseUrl: dio.options.baseUrl + endPoint);
  }

  @override
  PvmKeyChain newKeyChain() {
    final alias = getBlockchainAlias();
    if (alias == null) {
      _keyChain = PvmKeyChain(chainId: blockChainId, hrp: roiNetwork.hrp);
    } else {
      _keyChain = PvmKeyChain(chainId: alias, hrp: roiNetwork.hrp);
    }
    return keyChain;
  }

  @override
  String? getBlockchainAlias() {
    if (blockchainAlias == null) {
      final networkId = roiNetwork.networkId;
      final network = networks[networkId];
      blockchainAlias = network?.findAliasByBlockChainId(blockChainId);
    }
    return blockchainAlias;
  }

  @override
  String getBlockchainId() => blockChainId;

  @override
  String addressFromBuffer(Uint8List address) {
    final chainId = getBlockchainAlias() ?? blockChainId;
    return Serialization.instance.bufferToType(address, SerializedType.bech32,
        args: [chainId, roiNetwork.hrp]);
  }

  @override
  Uint8List parseAddress(String address) {
    final alias = getBlockchainAlias();
    return bindtools.parseAddress(address, blockChainId,
        alias: alias, addressLength: ADDRESSLENGTH);
  }

  @override
  BigInt getTxFee() {
    _txFee ??= _getDefaultTxFee();
    return _txFee!;
  }

  @override
  Future<Uint8List?> getAVAXAssetId({bool refresh = false}) async {
    if (avaxAssetId == null || refresh) {
      try {
        final response = await getStakingAssetId();
        avaxAssetId = cb58Decode(response.assetId);
      } catch (e) {}
    }
    return avaxAssetId;
  }

  @override
  Future<GetStakingAssetIdResponse> getStakingAssetId(
      {String? subnetId}) async {
    final request = GetStakingAssetIdRequest(subnetId: subnetId).toRpc();
    final response = await pvmRestClient.getStakingAssetId(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }

  @override
  Future<String> issueTx(PvmTx tx) async {
    final transaction = tx.toString();
    final request = IssueTxRequest(tx: transaction).toRpc();
    final response = await pvmRestClient.issueTx(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result.txId;
  }

  @override
  Future<GetUTXOsResponse> getUTXOs(List<String> addresses,
      {String? sourceChain,
      int limit = 0,
      GetUTXOsStartIndex? startIndex}) async {
    final request = GetUTXOsRequest(
            addresses: addresses,
            sourceChain: sourceChain,
            limit: limit,
            startIndex: startIndex)
        .toRpc();
    final response = await pvmRestClient.getUTXOs(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }

  @override
  Future<GetStakeResponse> getStake(List<String> addresses) async {
    final request = GetStakeRequest(addresses: addresses).toRpc();
    final response = await pvmRestClient.getStake(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }

  @override
  Future<GetTxStatusResponse> getTxStatus(String txId) async {
    final request = GetTxStatusRequest(txId: txId).toRpc();
    final response = await pvmRestClient.getTxStatus(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }

  @override
  Future<PvmUnsignedTx> buildImportTx(
      PvmUTXOSet utxoSet,
      List<String> ownerAddresses,
      String sourceChain,
      List<String> toAddresses,
      List<String> fromAddresses,
      {List<String>? changeAddresses,
      Uint8List? memo,
      BigInt? asOf,
      BigInt? lockTime,
      int threshold = 1}) async {
    asOf ??= unixNow();
    lockTime ??= BigInt.zero;

    final to = toAddresses.map((a) => bindtools.stringToAddress(a)).toList();
    final from =
        fromAddresses.map((a) => bindtools.stringToAddress(a)).toList();
    final List<Uint8List>? change;
    if (changeAddresses == null) {
      change = null;
    } else {
      change =
          changeAddresses.map((a) => bindtools.stringToAddress(a)).toList();
    }

    final atomicUTXOs =
        (await getUTXOs(ownerAddresses, sourceChain: sourceChain)).getUTXOs();

    final avaxAssetId = await getAVAXAssetId();

    final atomics = atomicUTXOs.getAllUTXOs();

    final buildUnsignedTx = utxoSet.buildImportTx(
      roiNetwork.networkId,
      bindtools.cb58Decode(blockChainId),
      atomics,
      to,
      from,
      changeAddresses: change,
      sourceChain: bindtools.cb58Decode(sourceChain),
      fee: getTxFee(),
      feeAssetId: avaxAssetId,
      memo: memo,
      asOf: asOf,
      lockTime: lockTime,
      threshold: threshold,
    );
    if (!await _checkGooseEgg(buildUnsignedTx)) {
      throw Exception("Error - PVMAPI.buildBaseTx:Failed Goose Egg Check");
    }
    return buildUnsignedTx;
  }

  @override
  Future<PvmUnsignedTx> buildExportTx(
      PvmUTXOSet utxoSet,
      BigInt amount,
      String destinationChainId,
      List<String> toAddresses,
      List<String> fromAddresses,
      {List<String>? changeAddresses,
      Uint8List? memo,
      BigInt? asOf,
      BigInt? lockTime,
      int threshold = 1}) async {
    asOf ??= unixNow();
    lockTime ??= BigInt.zero;

    final prefixes = <String, bool>{};
    for (var address in toAddresses) {
      prefixes[address.split("-")[0]] = true;
    }
    if (prefixes.keys.length != 1) {
      throw Exception(
          "Error - PVMAPI.buildExportTx: To addresses must have the same chainID prefix.");
    }

    final destinationChain = bindtools.cb58Decode(destinationChainId);

    if (destinationChain.length != 32) {
      throw Exception(
          "Error - PVMAPI.buildExportTx: Destination ChainID must be 32 bytes in length.");
    }

    final to = toAddresses.map((a) => bindtools.stringToAddress(a)).toList();
    final from =
        fromAddresses.map((a) => bindtools.stringToAddress(a)).toList();
    final List<Uint8List>? change;
    if (changeAddresses == null) {
      change = null;
    } else {
      change =
          changeAddresses.map((a) => bindtools.stringToAddress(a)).toList();
    }

    final avaxAssetId = await getAVAXAssetId();

    final builtUnsignedTx = utxoSet.buildExportTx(
      roiNetwork.networkId,
      bindtools.cb58Decode(blockChainId),
      amount,
      avaxAssetId!,
      destinationChain,
      to,
      from,
      changeAddresses: change,
      fee: getTxFee(),
      feeAssetId: avaxAssetId,
      memo: memo,
      asOf: asOf,
      lockTime: lockTime,
      threshold: threshold,
    );

    if (!await _checkGooseEgg(builtUnsignedTx)) {
      throw Exception("Error - PVMAPI.buildExportTx:Failed Goose Egg Check");
    }
    return builtUnsignedTx;
  }

  @override
  Future<List<Validator>> getCurrentValidators(
      {String? subnetId, List<String>? nodeIds}) async {
    final request =
        GetCurrentValidatorsRequest(subnetId: subnetId, nodeIds: nodeIds)
            .toRpc();
    final response = await pvmRestClient.getCurrentValidators(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result.validators;
  }

  BigInt _getDefaultTxFee() {
    final networkId = roiNetwork.networkId;
    return networks[networkId]?.p.txFee ?? BigInt.zero;
  }

  Future<bool> _checkGooseEgg(PvmUnsignedTx utx, {BigInt? outTotal}) async {
    outTotal ??= BigInt.zero;
    final avaxAssetId = await getAVAXAssetId();
    if (avaxAssetId == null) return false;
    final outputTotal =
        outTotal > BigInt.zero ? outTotal : utx.getOutputTotal(avaxAssetId);
    final fee = utx.getBurn(avaxAssetId);
    if (fee <= ONEAVAX * BigInt.from(10) || fee <= outputTotal) {
      return true;
    } else {
      return false;
    }
  }
}

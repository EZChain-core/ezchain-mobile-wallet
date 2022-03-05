import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/pvm/constants.dart';
import 'package:wallet/ezc/sdk/apis/pvm/key_chain.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_current_supply.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_min_stake.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_pending_validators.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_stake.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_staking_asset_id.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_total_of_stake.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_tx_status.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_utxos.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/issue_tx.dart';
import 'package:wallet/ezc/sdk/apis/pvm/rest_client.dart';
import 'package:wallet/ezc/sdk/apis/pvm/tx.dart';
import 'package:wallet/ezc/sdk/apis/pvm/utxos.dart';
import 'package:wallet/ezc/sdk/apis/ezc_api.dart';
import 'package:wallet/ezc/sdk/ezc.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart' as bintools;

abstract class PvmApi implements EZCApi {
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

  Future<PvmUnsignedTx> buildAddDelegatorTx(
    PvmUTXOSet utxoSet,
    List<String> toAddresses,
    List<String> fromAddresses,
    List<String> changeAddresses,
    String nodeId,
    BigInt startTime,
    BigInt endTime,
    BigInt stakeAmount,
    List<String> rewardAddresses, {
    BigInt? rewardLockTime,
    int rewardThreshold = 1,
    Uint8List? memo,
    BigInt? asOf,
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

  Future<List<Validator>> getCurrentValidators({
    String? subnetId,
    List<String>? nodeIds,
  });

  Future<GetPendingValidatorsResponse> getPendingValidators({
    String? subnetId,
    List<String>? nodeIds,
  });

  Future<GetMinStakeResponse> getMinStake({bool refresh = false});

  void setMinStake(BigInt minValidatorStake, BigInt minDelegatorStake);

  Future<BigInt> getCurrentSupply();

  Future<BigInt> getTotalOfStake();

  factory PvmApi.create(
      {required EZCNetwork ezcNetwork, String endPoint = "/ext/bc/P"}) {
    return _PvmApiImpl(
      ezcNetwork: ezcNetwork,
      endPoint: endPoint,
      blockChainId: platformChainId,
    );
  }
}

class _PvmApiImpl implements PvmApi {
  @override
  EZCNetwork ezcNetwork;

  @override
  PvmKeyChain get keyChain => _keyChain;

  late PvmKeyChain _keyChain;

  String blockChainId;

  String? blockchainAlias;

  Uint8List? avaxAssetId;

  BigInt? _txFee;

  BigInt? minValidatorStake;

  BigInt? minDelegatorStake;

  late PvmRestClient pvmRestClient;

  _PvmApiImpl(
      {required this.ezcNetwork,
      required String endPoint,
      required this.blockChainId}) {
    final networkId = ezcNetwork.networkId;
    final network = networks[networkId];
    final String alias;
    if (network != null) {
      alias = network.findAliasByBlockChainId(blockChainId) ?? "";
    } else {
      alias = blockChainId;
    }
    _keyChain = PvmKeyChain(chainId: alias, hrp: ezcNetwork.hrp);
    final dio = ezcNetwork.dio;
    pvmRestClient = PvmRestClient(dio, baseUrl: dio.options.baseUrl + endPoint);
  }

  @override
  PvmKeyChain newKeyChain() {
    final alias = getBlockchainAlias();
    if (alias == null) {
      _keyChain = PvmKeyChain(chainId: blockChainId, hrp: ezcNetwork.hrp);
    } else {
      _keyChain = PvmKeyChain(chainId: alias, hrp: ezcNetwork.hrp);
    }
    return keyChain;
  }

  @override
  String? getBlockchainAlias() {
    if (blockchainAlias == null) {
      final networkId = ezcNetwork.networkId;
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
    return Serialization.instance.bufferToType(
      address,
      SerializedType.bech32,
      args: [chainId, ezcNetwork.hrp],
    );
  }

  @override
  Uint8List parseAddress(String address) {
    final alias = getBlockchainAlias();
    return bintools.parseAddress(
      address,
      blockChainId,
      alias: alias,
      addressLength: ADDRESSLENGTH,
    );
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
        avaxAssetId = bintools.cb58Decode(response.assetId);
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
      startIndex: startIndex,
    ).toRpc();
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

    final to = toAddresses.map((a) => bintools.stringToAddress(a)).toList();
    final from = fromAddresses.map((a) => bintools.stringToAddress(a)).toList();
    final List<Uint8List>? change;
    if (changeAddresses == null) {
      change = null;
    } else {
      change = changeAddresses.map((a) => bintools.stringToAddress(a)).toList();
    }

    final atomicUTXOs =
        (await getUTXOs(ownerAddresses, sourceChain: sourceChain)).getUTXOs();

    final avaxAssetId = await getAVAXAssetId();

    final atomics = atomicUTXOs.getAllUTXOs();

    final buildUnsignedTx = utxoSet.buildImportTx(
      ezcNetwork.networkId,
      bintools.cb58Decode(blockChainId),
      atomics,
      to,
      from,
      changeAddresses: change,
      sourceChain: bintools.cb58Decode(sourceChain),
      fee: getTxFee(),
      feeAssetId: avaxAssetId,
      memo: memo,
      asOf: asOf,
      lockTime: lockTime,
      threshold: threshold,
    );
    if (!await _checkGooseEgg(buildUnsignedTx)) {
      throw Exception("Error - PVMAPI.buildImportTx:Failed Goose Egg Check");
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

    final destinationChain = bintools.cb58Decode(destinationChainId);

    if (destinationChain.length != 32) {
      throw Exception(
          "Error - PVMAPI.buildExportTx: Destination ChainID must be 32 bytes in length.");
    }

    final to = toAddresses.map((a) => bintools.stringToAddress(a)).toList();
    final from = fromAddresses.map((a) => bintools.stringToAddress(a)).toList();
    final List<Uint8List>? change;
    if (changeAddresses == null) {
      change = null;
    } else {
      change = changeAddresses.map((a) => bintools.stringToAddress(a)).toList();
    }

    final avaxAssetId = await getAVAXAssetId();

    final builtUnsignedTx = utxoSet.buildExportTx(
      ezcNetwork.networkId,
      bintools.cb58Decode(blockChainId),
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
  Future<PvmUnsignedTx> buildAddDelegatorTx(
    PvmUTXOSet utxoSet,
    List<String> toAddresses,
    List<String> fromAddresses,
    List<String> changeAddresses,
    String nodeId,
    BigInt startTime,
    BigInt endTime,
    BigInt stakeAmount,
    List<String> rewardAddresses, {
    BigInt? rewardLockTime,
    int rewardThreshold = 1,
    Uint8List? memo,
    BigInt? asOf,
  }) async {
    asOf ??= unixNow();
    final to = toAddresses.map((a) => bintools.stringToAddress(a)).toList();
    final from = fromAddresses.map((a) => bintools.stringToAddress(a)).toList();
    final change =
        changeAddresses.map((a) => bintools.stringToAddress(a)).toList();
    final rewards =
        rewardAddresses.map((a) => bintools.stringToAddress(a)).toList();

    final minStake = await getMinStake();
    final minDelegatorStakeBN = minStake.minDelegatorStakeBN;
    if (stakeAmount < minDelegatorStakeBN) {
      throw Exception(
          "PlatformVMAPI.buildAddDelegatorTx -- stake amount must be at least $minDelegatorStakeBN");
    }
    final avaxAssetId = await getAVAXAssetId();
    final now = unixNow();
    if (startTime < now || endTime <= startTime) {
      throw Exception(
          "PlatformVMAPI.buildAddDelegatorTx -- startTime must be in the future and endTime must come after startTime");
    }

    final builtUnsignedTx = utxoSet.buildAddDelegatorTx(
      ezcNetwork.networkId,
      bintools.cb58Decode(blockChainId),
      avaxAssetId!,
      to,
      from,
      change,
      nodeIdStringToBuffer(nodeId),
      startTime,
      endTime,
      stakeAmount,
      rewardLockTime ?? BigInt.zero,
      rewardThreshold,
      rewards,
      fee: BigInt.zero,
      feeAssetId: avaxAssetId,
      memo: memo,
      asOf: asOf,
    );

    if (!await _checkGooseEgg(builtUnsignedTx)) {
      throw Exception(
          "Error - PVMAPI.buildAddDelegatorTx:Failed Goose Egg Check");
    }
    return builtUnsignedTx;
  }

  @override
  Future<List<Validator>> getCurrentValidators({
    String? subnetId,
    List<String>? nodeIds,
  }) async {
    final request = GetCurrentValidatorsRequest(
      subnetId: subnetId,
      nodeIds: nodeIds,
    ).toRpc();
    final response = await pvmRestClient.getCurrentValidators(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result.validators;
  }

  @override
  Future<GetPendingValidatorsResponse> getPendingValidators({
    String? subnetId,
    List<String>? nodeIds,
  }) async {
    final request = GetPendingValidatorsRequest(
      subnetId: subnetId,
      nodeIds: nodeIds,
    ).toRpc();
    final response = await pvmRestClient.getPendingValidators(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }

  @override
  void setMinStake(BigInt minValidatorStake, BigInt minDelegatorStake) {
    this.minValidatorStake = minValidatorStake;
    this.minDelegatorStake = minDelegatorStake;
  }

  @override
  Future<GetMinStakeResponse> getMinStake({bool refresh = false}) async {
    final minValidatorStake = this.minValidatorStake;
    final minDelegatorStake = this.minDelegatorStake;
    if (!refresh && minValidatorStake != null && minDelegatorStake != null) {
      return GetMinStakeResponse(
        minValidatorStake: minValidatorStake.toString(),
        minDelegatorStake: minDelegatorStake.toString(),
      );
    }
    final request = GetMinStakeRequest().toRpc();
    final response = await pvmRestClient.getMinStake(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    this.minValidatorStake = result.minValidatorStakeBN;
    this.minDelegatorStake = result.minDelegatorStakeBN;
    return result;
  }

  @override
  Future<BigInt> getCurrentSupply() async {
    final request = GetCurrentSupplyRequest().toRpc();
    final response = await pvmRestClient.getCurrentSupply(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result.supplyBN;
  }

  @override
  Future<BigInt> getTotalOfStake() async {
    final request = GetTotalOfStakeRequest().toRpc();
    final response = await pvmRestClient.getTotalOfStake(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result.totalStakeBN;
  }

  BigInt _getDefaultTxFee() {
    final networkId = ezcNetwork.networkId;
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

import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/avm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/avm/model/get_asset_description.dart';
import 'package:wallet/roi/sdk/apis/avm/model/get_utxos.dart';
import 'package:wallet/roi/sdk/apis/avm/rest/avm_rest_client.dart';
import 'package:wallet/roi/sdk/apis/avm/rest/avm_wallet_rest_client.dart';
import 'package:wallet/roi/sdk/apis/avm/tx.dart';
import 'package:wallet/roi/sdk/apis/avm/utxos.dart';
import 'package:wallet/roi/sdk/apis/roi_api.dart';
import 'package:wallet/roi/sdk/roi.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';

abstract class AvmApi implements ROIChainApi {
  Future<AvmUnsignedTx> buildBaseTx(
      AvmUTXOSet utxoSet,
      BigInt amount,
      String assetId,
      List<String> toAddresses,
      List<String> fromAddresses,
      List<String> changeAddresses,
      Uint8List? memo);

  Future<GetUTXOsResponse> getUTXOs(List<String> addresses,
      {String? sourceChain, int limit = 0, GetUTXOsStartIndex? startIndex});

  Future<GetAssetDescriptionResponse> getAssetDescription(String assetId);

  Future<Uint8List?> getAVAXAssetId({bool refresh = false});

  Future<String> issueTx(AvmTx tx);

  factory AvmApi.create(
      {required ROINetwork roiNetwork,
      String endPoint = "/ext/bc/X",
      String blockChainId = ""}) {
    return _AvmApiImpl(
        roiNetwork: roiNetwork, endPoint: endPoint, blockChainId: blockChainId);
  }
}

class _AvmApiImpl implements AvmApi {
  @override
  ROINetwork roiNetwork;

  @override
  AvmKeyChain get keyChain => _keyChain;

  late AvmKeyChain _keyChain;

  String blockChainId;

  String? blockchainAlias;

  Uint8List? avaxAssetId;

  late AvmRestClient avmRestClient;

  late AvmWalletRestClient avmWalletRestClient;

  BigInt? _txFee;

  _AvmApiImpl(
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
    _keyChain = AvmKeyChain(chainId: alias, hrp: roiNetwork.hrp);
    final dio = roiNetwork.dio;
    avmRestClient = AvmRestClient(dio, baseUrl: dio.options.baseUrl + endPoint);
    avmWalletRestClient = AvmWalletRestClient(dio,
        baseUrl: dio.options.baseUrl + "/ext/bc/X/wallet");
  }

  @override
  AvmKeyChain newKeyChain() {
    final alias = getBlockchainAlias();
    if (alias == null) {
      _keyChain = AvmKeyChain(chainId: blockChainId, hrp: roiNetwork.hrp);
    } else {
      _keyChain = AvmKeyChain(chainId: alias, hrp: roiNetwork.hrp);
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
  void refreshBlockchainId(String blockChainId) {
    this.blockChainId = blockChainId;
  }

  @override
  void setAVAXAssetId(String? avaxAssetId) {
    this.avaxAssetId = cb58Decode(avaxAssetId);
  }

  @override
  void setBlockchainAlias(String alias) {
    blockchainAlias = alias;
  }

  @override
  Future<AvmUnsignedTx> buildBaseTx(
      AvmUTXOSet utxoSet,
      BigInt amount,
      String assetId,
      List<String> toAddresses,
      List<String> fromAddresses,
      List<String> changeAddresses,
      Uint8List? memo,
      {int threshold = 1}) async {
    final to = toAddresses.map((e) => stringToAddress(e)).toList();
    final from = fromAddresses.map((e) => stringToAddress(e)).toList();
    final change = changeAddresses.map((e) => stringToAddress(e)).toList();

    final builtUnsignedTx = utxoSet.buildBaseTx(
        roiNetwork.networkId,
        cb58Decode(blockChainId),
        amount,
        cb58Decode(assetId),
        to,
        from,
        change,
        _getTxFee(),
        await getAVAXAssetId(),
        memo,
        threshold: threshold);
    if (!await _checkGooseEgg(builtUnsignedTx)) {
      throw Exception("Error - AVMAPI.buildBaseTx:Failed Goose Egg Check");
    }
    return builtUnsignedTx;
  }

  Future<bool> _checkGooseEgg(AvmUnsignedTx utx, {BigInt? outTotal}) async {
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
    final response = await avmRestClient.getUTXOs(request);
    return response.result!;
  }

  @override
  Future<GetAssetDescriptionResponse> getAssetDescription(
      String assetId) async {
    final response = await avmRestClient.getAssetDescription(
        const GetAssetDescriptionRequest(assetId: primaryAssetAlias).toRpc());
    return response.result!;
  }

  @override
  Future<Uint8List?> getAVAXAssetId({bool refresh = false}) async {
    if (avaxAssetId == null || refresh) {
      final response = await getAssetDescription(primaryAssetAlias);
      setAVAXAssetId(response.assetId);
    }
    return avaxAssetId;
  }

  @override
  Future<String> issueTx(AvmTx tx) async {
    return "";
  }

  BigInt _getTxFee() {
    _txFee ??= _getDefaultTxFee();
    return _txFee!;
  }

  BigInt _getDefaultTxFee() {
    final networkId = roiNetwork.networkId;
    if (networks.containsKey(networkId)) {
      return networks[networkId]!.x.creationTxFee;
    } else {
      return BigInt.zero;
    }
  }
}

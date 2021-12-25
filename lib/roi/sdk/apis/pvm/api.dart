import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/pvm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_stake.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_utxos.dart';
import 'package:wallet/roi/sdk/apis/pvm/rest/pvm_rest_client.dart';
import 'package:wallet/roi/sdk/apis/roi_api.dart';
import 'package:wallet/roi/sdk/roi.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';

abstract class PvmApi implements ROIChainApi {
  BigInt getTxFee();

  Future<GetUTXOsResponse> getUTXOs(List<String> addresses,
      {String? sourceChain, int limit = 0, GetUTXOsStartIndex? startIndex});

  Future<GetStakeResponse> getStake(List<String> addresses);

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
  String addressFromBuffer(Uint8List address) {
    throw UnimplementedError();
  }

  @override
  Uint8List parseAddress(String address) {
    throw UnimplementedError();
  }

  @override
  BigInt getTxFee() {
    _txFee ??= _getDefaultTxFee();
    return _txFee!;
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

  BigInt _getDefaultTxFee() {
    final networkId = roiNetwork.networkId;
    return networks[networkId]?.p.txFee ?? BigInt.zero;
  }
}

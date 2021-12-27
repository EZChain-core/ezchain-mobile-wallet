import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/evm/constants.dart';
import 'package:wallet/roi/sdk/apis/evm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/evm/rest/evm_rest_client.dart';
import 'package:wallet/roi/sdk/apis/roi_api.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request.dart';
import 'package:wallet/roi/sdk/roi.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart' as bindtools;

abstract class EvmApi implements ROIChainApi {
  Future<String> getBaseFee();

  Future<String> getMaxPriorityFeePerGas();

  factory EvmApi.create(
      {required ROINetwork roiNetwork,
      String endPoint = "/ext/bc/C/rpc",
      String blockChainId = ""}) {
    return _EvmApiImpl(
        roiNetwork: roiNetwork, endPoint: endPoint, blockChainId: blockChainId);
  }
}

class _EvmApiImpl implements EvmApi {
  @override
  ROINetwork roiNetwork;

  @override
  EvmKeyChain get keyChain => _keyChain;

  late EvmKeyChain _keyChain;

  String blockChainId;

  String? blockchainAlias;

  Uint8List? avaxAssetId;

  late EvmRestClient evmRestClient;

  _EvmApiImpl(
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
    _keyChain = EvmKeyChain(chainId: alias, hrp: roiNetwork.hrp);
    final dio = roiNetwork.dio;
    evmRestClient = EvmRestClient(dio, baseUrl: dio.options.baseUrl + endPoint);
  }

  @override
  EvmKeyChain newKeyChain() {
    final alias = getBlockchainAlias();
    if (alias == null) {
      _keyChain = EvmKeyChain(chainId: blockChainId, hrp: roiNetwork.hrp);
    } else {
      _keyChain = EvmKeyChain(chainId: alias, hrp: roiNetwork.hrp);
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
  String getBlockchainId() => blockChainId;

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
  Future<String> getBaseFee() async {
    const request = RpcRequest(method: "eth_baseFee", params: []);
    final response = await evmRestClient.getEthBaseFee(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }

  @override
  Future<String> getMaxPriorityFeePerGas() async {
    const request = RpcRequest(method: "eth_maxPriorityFeePerGas", params: []);
    final response = await evmRestClient.getEthMaxPriorityFeePerGas(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }
}

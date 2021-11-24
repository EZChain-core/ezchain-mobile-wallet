import 'package:wallet/roi/apis/avm/model/get_all_balances.dart';
import 'package:wallet/roi/apis/avm/model/get_asset_description.dart';
import 'package:wallet/roi/apis/avm/model/get_balance.dart';
import 'package:wallet/roi/apis/avm/model/get_tx_status.dart';
import 'package:wallet/roi/apis/avm/model/issue_tx.dart';
import 'package:wallet/roi/apis/avm/rest/avm_rest_client.dart';
import 'package:wallet/roi/apis/info/model/get_tx_fee.dart';
import 'package:wallet/roi/apis/roi_api.dart';
import 'package:wallet/roi/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/common/rpc/rpc_request.dart';
import 'package:wallet/roi/common/rpc/rpc_response.dart';
import 'package:wallet/roi/roi.dart';
import 'package:wallet/roi/utils/constants.dart';

abstract class AvmApi implements ROIApi {
  Future<RpcResponse<GetBalanceResponse>> getBalance(
      RpcRequest<GetBalanceRequest> request);

  Future<RpcResponse<GetAllBalancesResponse>> getAllBalances(
      RpcRequest<GetAllBalancesRequest> request);

  Future<RpcResponse<GetAssetDescriptionResponse>> getAssetDescription(
      RpcRequest<GetAssetDescriptionRequest> request);

  Future<RpcResponse<GetTxStatusResponse>> getTxStatus(
      RpcRequest<GetTxStatusRequest> request);

  Future<RpcResponse<GetTxFeeResponse>> getTx(
      RpcRequest<GetTxFeeRequest> request);

  Future<RpcResponse<IssueTxResponse>> issueTx(
      RpcRequest<IssueTxRequest> request);

  factory AvmApi.create(
      {required ROINetwork roiNetwork,
      String baseUrl = "/ext/bc/X",
      String blockChainId = ""}) {
    return _AvmApiImpl(
        roiNetwork: roiNetwork, baseUrl: baseUrl, blockChainId: blockChainId);
  }
}

class _AvmApiImpl implements AvmApi {
  @override
  ROINetwork roiNetwork;

  late ROIKeyChain keyChain;

  String blockChainId;

  late AvmRestClient avmRestClient;

  _AvmApiImpl(
      {required this.roiNetwork,
      required String baseUrl,
      required this.blockChainId}) {
    final networkId = roiNetwork.networkId;

    final network = networks[networkId];
    final String alias;
    if (network != null) {
      if (network.x.blockchainID == blockChainId) {
        alias = network.x.alias;
      } else if (network.p.blockchainID == blockChainId) {
        alias = network.p.alias;
      } else if (network.c.blockchainID == blockChainId) {
        alias = network.c.alias;
      } else {
        alias = "";
      }
    } else {
      alias = blockChainId;
    }
    keyChain = ROIKeyChain(chainId: alias, hrp: roiNetwork.hrp);
    final dio = roiNetwork.dio;
    avmRestClient = AvmRestClient(dio, baseUrl: dio.options.baseUrl + baseUrl);
  }

  @override
  Future<RpcResponse<GetBalanceResponse>> getBalance(
      RpcRequest<GetBalanceRequest> request) {
    return avmRestClient.getBalance(request);
  }

  @override
  Future<RpcResponse<GetAllBalancesResponse>> getAllBalances(
      RpcRequest<GetAllBalancesRequest> request) {
    return avmRestClient.getAllBalances(request);
  }

  @override
  Future<RpcResponse<GetAssetDescriptionResponse>> getAssetDescription(
      RpcRequest<GetAssetDescriptionRequest> request) {
    return avmRestClient.getAssetDescription(request);
  }

  @override
  Future<RpcResponse<IssueTxResponse>> issueTx(
      RpcRequest<IssueTxRequest> request) {
    return avmRestClient.issueTx(request);
  }

  @override
  Future<RpcResponse<GetTxFeeResponse>> getTx(
      RpcRequest<GetTxFeeRequest> request) {
    return avmRestClient.getTx(request);
  }

  @override
  Future<RpcResponse<GetTxStatusResponse>> getTxStatus(
      RpcRequest<GetTxStatusRequest> request) {
    return avmRestClient.getTxStatus(request);
  }
}

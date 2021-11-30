import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/avm/model/get_address_txs.dart';
import 'package:wallet/roi/sdk/apis/avm/model/get_all_balances.dart';
import 'package:wallet/roi/sdk/apis/avm/model/get_asset_description.dart';
import 'package:wallet/roi/sdk/apis/avm/model/get_balance.dart';
import 'package:wallet/roi/sdk/apis/avm/model/get_tx_status.dart';
import 'package:wallet/roi/sdk/apis/avm/model/import_key.dart';
import 'package:wallet/roi/sdk/apis/avm/model/issue_tx.dart';
import 'package:wallet/roi/sdk/apis/avm/model/wallet_issue_tx.dart';
import 'package:wallet/roi/sdk/apis/avm/rest/avm_rest_client.dart';
import 'package:wallet/roi/sdk/apis/avm/rest/avm_wallet_rest_client.dart';
import 'package:wallet/roi/sdk/apis/info/model/get_tx_fee.dart';
import 'package:wallet/roi/sdk/apis/roi_api.dart';
import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_response.dart';
import 'package:wallet/roi/sdk/roi.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';

abstract class AvmApi implements ROIChainApi {
  Future<RpcResponse<GetBalanceResponse>> getBalance(
      RpcRequest<GetBalanceRequest> request);

  Future<RpcResponse<GetAllBalancesResponse>> getAllBalances(
      RpcRequest<GetAllBalancesRequest> request);

  Future<RpcResponse<GetAssetDescriptionResponse>> getAssetDescription(
      RpcRequest<GetAssetDescriptionRequest> request);

  Future<RpcResponse<GetTxStatusResponse>> getTxStatus(
      RpcRequest<GetTxStatusRequest> request);

  Future<RpcResponse<GetAddressTxsResponse>> getAddressTxs(
      RpcRequest<GetAddressTxsRequest> request);

  Future<RpcResponse<GetTxFeeResponse>> getTx(
      RpcRequest<GetTxFeeRequest> request);

  Future<RpcResponse<ImportKeyResponse>> importKey(
      RpcRequest<ImportKeyRequest> request);

  Future<RpcResponse<IssueTxResponse>> issueTx(
      RpcRequest<IssueTxRequest> request);

  Future<RpcResponse<WalletIssueTxResponse>> walletIssueTx(
      RpcRequest<WalletIssueTxRequest> request);

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
  ROIKeyChain get keyChain => _keyChain;

  late ROIKeyChain _keyChain;

  String blockChainId;

  String? blockchainAlias;

  Uint8List? avaxAssetId;

  late AvmRestClient avmRestClient;

  late AvmWalletRestClient avmWalletRestClient;

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
    _keyChain = ROIKeyChain(chainId: alias, hrp: roiNetwork.hrp);
    final dio = roiNetwork.dio;
    avmRestClient = AvmRestClient(dio, baseUrl: dio.options.baseUrl + endPoint);
    avmWalletRestClient = AvmWalletRestClient(dio,
        baseUrl: dio.options.baseUrl + "/ext/bc/X/wallet");
  }

  @override
  ROIKeyChain newKeyChain() {
    final alias = getBlockchainAlias();
    if (alias == null) {
      _keyChain = ROIKeyChain(chainId: blockChainId, hrp: roiNetwork.hrp);
    } else {
      _keyChain = ROIKeyChain(chainId: alias, hrp: roiNetwork.hrp);
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
  Future<RpcResponse<GetAddressTxsResponse>> getAddressTxs(
      RpcRequest<GetAddressTxsRequest> request) {
    return avmRestClient.getAddressTxs(request);
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

  @override
  Future<RpcResponse<ImportKeyResponse>> importKey(
      RpcRequest<ImportKeyRequest> request) {
    return avmRestClient.importKey(request);
  }

  @override
  Future<RpcResponse<WalletIssueTxResponse>> walletIssueTx(
      RpcRequest<WalletIssueTxRequest> request) {
    return avmWalletRestClient.walletIssueTx(request);
  }
}

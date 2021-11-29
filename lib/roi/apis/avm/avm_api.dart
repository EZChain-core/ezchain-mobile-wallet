import 'package:wallet/roi/apis/avm/model/create_address.dart';
import 'package:wallet/roi/apis/avm/model/export.dart';
import 'package:wallet/roi/apis/avm/model/export_key.dart';
import 'package:wallet/roi/apis/avm/model/get_address_txs.dart';
import 'package:wallet/roi/apis/avm/model/get_all_balances.dart';
import 'package:wallet/roi/apis/avm/model/get_asset_description.dart';
import 'package:wallet/roi/apis/avm/model/get_balance.dart';
import 'package:wallet/roi/apis/avm/model/get_tx_status.dart';
import 'package:wallet/roi/apis/avm/model/import.dart';
import 'package:wallet/roi/apis/avm/model/import_key.dart';
import 'package:wallet/roi/apis/avm/model/issue_tx.dart';
import 'package:wallet/roi/apis/avm/model/list_address.dart';
import 'package:wallet/roi/apis/avm/model/send.dart';
import 'package:wallet/roi/apis/avm/model/send_multiple.dart';
import 'package:wallet/roi/apis/avm/model/send_nft.dart';
import 'package:wallet/roi/apis/avm/model/wallet_issue_tx.dart';
import 'package:wallet/roi/apis/avm/model/wallet_send.dart';
import 'package:wallet/roi/apis/avm/model/wallet_send_multiple.dart';
import 'package:wallet/roi/apis/avm/rest/avm_rest_client.dart';
import 'package:wallet/roi/apis/avm/rest/avm_wallet_rest_client.dart';
import 'package:wallet/roi/apis/info/model/get_tx_fee.dart';
import 'package:wallet/roi/apis/roi_api.dart';
import 'package:wallet/roi/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/common/rpc/rpc_request.dart';
import 'package:wallet/roi/common/rpc/rpc_response.dart';
import 'package:wallet/roi/roi.dart';
import 'package:wallet/roi/utils/constants.dart';

abstract class AvmApi implements ROIApi {
  ROIKeyChain get keyChain;

  ROIKeyChain newKeyChain();

  Future<RpcResponse<CreateAddressResponse>> createAddress(
      RpcRequest<CreateAddressRequest> request);

  Future<RpcResponse<ExportResponse>> export(RpcRequest<ExportRequest> request);

  Future<RpcResponse<ExportKeyResponse>> exportKey(
      RpcRequest<ExportKeyRequest> request);

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

  Future<RpcResponse<ImportResponse>> import(RpcRequest<ImportRequest> request);

  Future<RpcResponse<ImportKeyResponse>> importKey(
      RpcRequest<ImportKeyRequest> request);

  Future<RpcResponse<IssueTxResponse>> issueTx(
      RpcRequest<IssueTxRequest> request);

  Future<RpcResponse<ListAddressResponse>> listAddress(
      RpcRequest<ListAddressRequest> request);

  Future<RpcResponse<SendResponse>> send(RpcRequest<SendRequest> request);

  Future<RpcResponse<SendMultipleResponse>> sendMultiple(
      RpcRequest<SendMultipleRequest> request);

  Future<RpcResponse<SendNFTResponse>> sendNFT(
      RpcRequest<SendNFTRequest> request);

  Future<RpcResponse<WalletSendResponse>> walletSend(
      RpcRequest<WalletSendRequest> request);

  Future<RpcResponse<WalletSendMultipleResponse>> walletSendMultiple(
      RpcRequest<WalletSendMultipleRequest> request);

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
    _keyChain = ROIKeyChain(chainId: alias, hrp: roiNetwork.hrp);
    final dio = roiNetwork.dio;
    avmRestClient = AvmRestClient(dio, baseUrl: dio.options.baseUrl + endPoint);
    avmWalletRestClient = AvmWalletRestClient(dio,
        baseUrl: dio.options.baseUrl + "/ext/bc/X/wallet");
  }

  @override
  ROIKeyChain newKeyChain() {
    // TODO: implement newKeyChain
    throw UnimplementedError();
  }

  @override
  Future<RpcResponse<ExportResponse>> export(
      RpcRequest<ExportRequest> request) {
    return avmRestClient.export(request);
  }

  @override
  Future<RpcResponse<ExportKeyResponse>> exportKey(
      RpcRequest<ExportKeyRequest> request) {
    return avmRestClient.exportKey(request);
  }

  @override
  Future<RpcResponse<CreateAddressResponse>> createAddress(
      RpcRequest<CreateAddressRequest> request) {
    return avmRestClient.createAddress(request);
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
  Future<RpcResponse<ImportResponse>> import(
      RpcRequest<ImportRequest> request) {
    return avmRestClient.import(request);
  }

  @override
  Future<RpcResponse<ImportKeyResponse>> importKey(
      RpcRequest<ImportKeyRequest> request) {
    return avmRestClient.importKey(request);
  }

  @override
  Future<RpcResponse<ListAddressResponse>> listAddress(
      RpcRequest<ListAddressRequest> request) {
    return avmRestClient.listAddress(request);
  }

  @override
  Future<RpcResponse<SendResponse>> send(RpcRequest<SendRequest> request) {
    return avmRestClient.send(request);
  }

  @override
  Future<RpcResponse<SendMultipleResponse>> sendMultiple(
      RpcRequest<SendMultipleRequest> request) {
    return avmRestClient.sendMultiple(request);
  }

  @override
  Future<RpcResponse<SendNFTResponse>> sendNFT(
      RpcRequest<SendNFTRequest> request) {
    return avmRestClient.sendNFT(request);
  }

  @override
  Future<RpcResponse<WalletIssueTxResponse>> walletIssueTx(
      RpcRequest<WalletIssueTxRequest> request) {
    return avmWalletRestClient.walletIssueTx(request);
  }

  @override
  Future<RpcResponse<WalletSendResponse>> walletSend(
      RpcRequest<WalletSendRequest> request) {
    return avmWalletRestClient.walletSend(request);
  }

  @override
  Future<RpcResponse<WalletSendMultipleResponse>> walletSendMultiple(
      RpcRequest<WalletSendMultipleRequest> request) {
    return avmWalletRestClient.walletSendMultiple(request);
  }
}

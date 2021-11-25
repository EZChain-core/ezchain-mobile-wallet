import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
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
import 'package:wallet/roi/apis/info/model/get_tx_fee.dart';
import 'package:wallet/roi/common/rpc/rpc_request.dart';
import 'package:wallet/roi/common/rpc/rpc_response.dart';

part 'avm_rest_client.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/exchange-chain-x-chain-api
@RestApi()
abstract class AvmRestClient {
  factory AvmRestClient(Dio dio, {String baseUrl}) = _AvmRestClient;

  @POST("/")
  Future<RpcResponse<CreateAddressResponse>> createAddress(
      @Body() RpcRequest<CreateAddressRequest> request);

  @POST("/")
  Future<RpcResponse<ExportResponse>> export(
      @Body() RpcRequest<ExportRequest> request);

  @POST("/")
  Future<RpcResponse<ExportKeyResponse>> exportKey(
      @Body() RpcRequest<ExportKeyRequest> request);

  @POST("/")
  Future<RpcResponse<GetBalanceResponse>> getBalance(
      @Body() RpcRequest<GetBalanceRequest> request);

  @POST("/")
  Future<RpcResponse<GetAllBalancesResponse>> getAllBalances(
      @Body() RpcRequest<GetAllBalancesRequest> request);

  @POST("/")
  Future<RpcResponse<GetAssetDescriptionResponse>> getAssetDescription(
      @Body() RpcRequest<GetAssetDescriptionRequest> request);

  @POST("/")
  Future<RpcResponse<GetAddressTxsResponse>> getAddressTxs(
      @Body() RpcRequest<GetAddressTxsRequest> request);

  @POST("/")
  Future<RpcResponse<GetTxFeeResponse>> getTx(
      @Body() RpcRequest<GetTxFeeRequest> request);

  @POST("/")
  Future<RpcResponse<GetTxStatusResponse>> getTxStatus(
      @Body() RpcRequest<GetTxStatusRequest> request);

  @POST("/")
  Future<RpcResponse<ImportResponse>> import(
      @Body() RpcRequest<ImportRequest> request);

  @POST("/")
  Future<RpcResponse<ImportKeyResponse>> importKey(
      @Body() RpcRequest<ImportKeyRequest> request);

  @POST("/")
  Future<RpcResponse<IssueTxResponse>> issueTx(
      @Body() RpcRequest<IssueTxRequest> request);

  @POST("/")
  Future<RpcResponse<ListAddressResponse>> listAddress(
      @Body() RpcRequest<ListAddressRequest> request);

  @POST("/")
  Future<RpcResponse<SendResponse>> send(
      @Body() RpcRequest<SendRequest> request);

  @POST("/")
  Future<RpcResponse<SendMultipleResponse>> sendMultiple(
      @Body() RpcRequest<SendMultipleRequest> request);

  @POST("/")
  Future<RpcResponse<SendNFTResponse>> sendNFT(
      @Body() RpcRequest<SendNFTRequest> request);
}

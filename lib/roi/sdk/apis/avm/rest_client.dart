import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:wallet/roi/sdk/apis/avm/model/get_asset_description.dart';
import 'package:wallet/roi/sdk/apis/avm/model/get_tx_status.dart';
import 'package:wallet/roi/sdk/apis/avm/model/get_utxos.dart';
import 'package:wallet/roi/sdk/apis/avm/model/issue_tx.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_response.dart';

part 'rest_client.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/exchange-chain-x-chain-api
@RestApi()
abstract class AvmRestClient {
  factory AvmRestClient(Dio dio, {String baseUrl}) = _AvmRestClient;

  @POST("")
  Future<RpcResponse<GetUTXOsResponse>> getUTXOs(
      @Body() RpcRequest<GetUTXOsRequest> request);

  @POST("")
  Future<RpcResponse<GetAssetDescriptionResponse>> getAssetDescription(
      @Body() RpcRequest<GetAssetDescriptionRequest> request);

  @POST("")
  Future<RpcResponse<GetTxStatusResponse>> getTxStatus(
      @Body() RpcRequest<GetTxStatusRequest> request);

  @POST("")
  Future<RpcResponse<IssueTxResponse>> issueTx(
      @Body() RpcRequest<IssueTxRequest> request);
}

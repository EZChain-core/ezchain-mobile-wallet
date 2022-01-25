import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:wallet/roi/sdk/apis/evm/model/get_asset_description.dart';
import 'package:wallet/roi/sdk/apis/evm/model/get_atomic_tx_status.dart';
import 'package:wallet/roi/sdk/apis/evm/model/get_utxos.dart';
import 'package:wallet/roi/sdk/apis/evm/model/issue_tx.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_response.dart';

part 'rest_client.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/contract-chain-c-chain-api
@RestApi()
abstract class EvmAvaxRestClient {
  factory EvmAvaxRestClient(Dio dio, {String baseUrl}) = _EvmAvaxRestClient;

  @POST("")
  Future<RpcResponse<GetUTXOsResponse>> getUTXOs(
      @Body() RpcRequest<GetUTXOsRequest> request);

  @POST("")
  Future<RpcResponse<IssueTxResponse>> issueTx(
      @Body() RpcRequest<IssueTxRequest> request);

  @POST("")
  Future<RpcResponse<GetAtomicTxStatusResponse>> getAtomicTxStatus(
      @Body() RpcRequest<GetAtomicTxStatusRequest> request);
}

/// https://docs.avax.network/build/avalanchego-apis/contract-chain-c-chain-api
@RestApi()
abstract class EvmRpcRestClient {
  factory EvmRpcRestClient(Dio dio, {String baseUrl}) = _EvmRpcRestClient;

  @POST("")
  Future<RpcResponse<String>> getEthBaseFee(
      @Body() RpcRequest<List<dynamic>> request);

  @POST("")
  Future<RpcResponse<String>> getEthMaxPriorityFeePerGas(
      @Body() RpcRequest<List<dynamic>> request);
}

/// https://docs.avax.network/build/avalanchego-apis/exchange-chain-x-chain-api
@RestApi()
abstract class EvmXRestClient {
  factory EvmXRestClient(Dio dio, {String baseUrl}) = _EvmXRestClient;

  @POST("")
  Future<RpcResponse<GetAssetDescriptionResponse>> getAssetDescription(
      @Body() RpcRequest<GetAssetDescriptionRequest> request);
}

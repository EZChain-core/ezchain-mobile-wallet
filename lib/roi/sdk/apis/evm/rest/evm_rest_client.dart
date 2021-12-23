import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_response.dart';

part 'evm_rest_client.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/contract-chain-c-chain-api
@RestApi()
abstract class EvmRestClient {
  factory EvmRestClient(Dio dio, {String baseUrl}) = _EvmRestClient;

  @POST("")
  Future<RpcResponse<String>> getEthBaseFee(
      @Body() RpcRequest<List<dynamic>> request);

  @POST("")
  Future<RpcResponse<String>> getEthMaxPriorityFeePerGas(
      @Body() RpcRequest<List<dynamic>> request);
}

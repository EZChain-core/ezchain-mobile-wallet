import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_stake.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_utxos.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_response.dart';

part 'pvm_rest_client.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/platform-chain-p-chain-api#platformgetutxos
@RestApi()
abstract class PvmRestClient {
  factory PvmRestClient(Dio dio, {String baseUrl}) = _PvmRestClient;

  @POST("")
  Future<RpcResponse<GetUTXOsResponse>> getUTXOs(
      @Body() RpcRequest<GetUTXOsRequest> request);

  @POST("")
  Future<RpcResponse<GetStakeResponse>> getStake(
      @Body() RpcRequest<GetStakeRequest> request);
}

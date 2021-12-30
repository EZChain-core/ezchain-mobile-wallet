import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:wallet/roi/sdk/apis/evm/model/get_asset_description.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_response.dart';

part 'evm_x_rest_client.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/exchange-chain-x-chain-api
@RestApi()
abstract class EvmXRestClient {
  factory EvmXRestClient(Dio dio, {String baseUrl}) = _EvmXRestClient;

  @POST("")
  Future<RpcResponse<GetAssetDescriptionResponse>> getAssetDescription(
      @Body() RpcRequest<GetAssetDescriptionRequest> request);
}

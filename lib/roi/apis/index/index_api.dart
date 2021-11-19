import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wallet/roi/apis/index/model/get_container_by_id.dart';
import 'package:wallet/roi/apis/index/model/get_container_by_index.dart';
import 'package:wallet/roi/apis/index/model/get_container_range.dart';
import 'package:wallet/roi/apis/index/model/get_index.dart';
import 'package:wallet/roi/apis/index/model/get_last_accepted.dart';
import 'package:wallet/roi/apis/index/model/is_accepted.dart';
import 'package:wallet/roi/common/rpc_request.dart';
import 'package:wallet/roi/common/rpc_response.dart';

part 'index_api.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/index-api
@RestApi()
abstract class IndexApi {
  factory IndexApi(Dio dio, {String baseUrl}) = _IndexApi;

  @POST("/")
  Future<RpcResponse<GetLastAcceptedResponse>> getLastAccepted(
      @Body() RpcRequest<GetLastAcceptedRequest> request);

  @POST("/")
  Future<RpcResponse<GetContainerByIndexResponse>> getContainerByIndex(
      @Body() RpcRequest<GetContainerByIndexRequest> request);

  @POST("/")
  Future<RpcResponse<GetContainerByIdResponse>> getContainerById(
      @Body() RpcRequest<GetContainerByIdRequest> request);

  @POST("/")
  Future<RpcResponse<GetContainerRangeResponse>> getContainerRange(
      @Body() RpcRequest<GetContainerRangeRequest> request);

  @POST("/")
  Future<RpcResponse<GetIndexResponse>> getIndex(
      @Body() RpcRequest<GetIndexRequest> request);

  @POST("/")
  Future<RpcResponse<ISAcceptedResponse>> isAccepted(
      @Body() RpcRequest<ISAcceptedRequest> request);
}

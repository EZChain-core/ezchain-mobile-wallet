import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wallet/roi/apis/info/model/get_blockchain_id.dart';
import 'package:wallet/roi/apis/info/model/get_network_id.dart';
import 'package:wallet/roi/apis/info/model/get_network_name.dart';
import 'package:wallet/roi/apis/info/model/get_node_id.dart';
import 'package:wallet/roi/apis/info/model/get_node_ip.dart';
import 'package:wallet/roi/apis/info/model/get_node_version.dart';
import 'package:wallet/roi/apis/info/model/get_tx_fee.dart';
import 'package:wallet/roi/apis/info/model/is_bootstrapped.dart';
import 'package:wallet/roi/apis/info/model/peers.dart';
import 'package:wallet/roi/apis/info/model/uptime.dart';
import 'package:wallet/roi/common/rpc/rpc_request.dart';
import 'package:wallet/roi/common/rpc/rpc_response.dart';

part 'info_rest_client.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/info-api
@RestApi()
abstract class InfoRestClient {
  factory InfoRestClient(Dio dio) = _InfoRestClient;

  static const endPoint = "/ext/info";

  @POST(endPoint)
  Future<RpcResponse<GetBlockchainIdResponse>> getBlockchainId(
      @Body() RpcRequest<GetBlockchainIdRequest> request);

  @POST(endPoint)
  Future<RpcResponse<GetNetworkIdResponse>> getNetworkId(
      @Body() RpcRequest<GetNetworkIdRequest> request);

  @POST(endPoint)
  Future<RpcResponse<GetNetworkNameResponse>> getNetworkName(
      @Body() RpcRequest<GetNetworkNameRequest> request);

  @POST(endPoint)
  Future<RpcResponse<GetNodeIdResponse>> getNodeId(
      @Body() RpcRequest<GetNodeIdRequest> request);

  @POST(endPoint)
  Future<RpcResponse<GetNodeIpResponse>> getNodeIp(
      @Body() RpcRequest<GetNodeIpRequest> request);

  @POST(endPoint)
  Future<RpcResponse<GetNodeVersionResponse>> getNodeVersion(
      @Body() RpcRequest<GetNodeVersionRequest> request);

  @POST(endPoint)
  Future<RpcResponse<IsBootstrappedResponse>> isBootstrapped(
      @Body() RpcRequest<IsBootstrappedRequest> request);

  @POST(endPoint)
  Future<RpcResponse<PeersResponse>> peers(
      @Body() RpcRequest<PeersRequest> request);

  @POST(endPoint)
  Future<RpcResponse<GetTxFeeResponse>> getTxFee(
      @Body() RpcRequest<GetTxFeeRequest> request);

  @POST(endPoint)
  Future<RpcResponse<UptimeResponse>> uptime(
      @Body() RpcRequest<UptimeRequest> request);
}

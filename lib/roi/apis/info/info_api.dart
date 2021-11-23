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
import 'package:wallet/roi/apis/info/rest/info_rest_client.dart';
import 'package:wallet/roi/apis/roi_api.dart';
import 'package:wallet/roi/common/rpc/rpc_request.dart';
import 'package:wallet/roi/common/rpc/rpc_response.dart';
import 'package:wallet/roi/roi.dart';

abstract class InfoApi implements ROIApi {
  Future<RpcResponse<GetBlockchainIdResponse>> getBlockchainId(
      RpcRequest<GetBlockchainIdRequest> request);

  Future<RpcResponse<GetNetworkIdResponse>> getNetworkId(
      RpcRequest<GetNetworkIdRequest> request);

  Future<RpcResponse<GetNetworkNameResponse>> getNetworkName(
      RpcRequest<GetNetworkNameRequest> request);

  Future<RpcResponse<GetNodeIdResponse>> getNodeId(
      RpcRequest<GetNodeIdRequest> request);

  Future<RpcResponse<GetNodeIpResponse>> getNodeIp(
      RpcRequest<GetNodeIpRequest> request);

  Future<RpcResponse<GetNodeVersionResponse>> getNodeVersion(
      RpcRequest<GetNodeVersionRequest> request);

  Future<RpcResponse<IsBootstrappedResponse>> isBootstrapped(
      RpcRequest<IsBootstrappedRequest> request);

  Future<RpcResponse<PeersResponse>> peers(RpcRequest<PeersRequest> request);

  Future<RpcResponse<GetTxFeeResponse>> getTxFee(
      RpcRequest<GetTxFeeRequest> request);

  Future<RpcResponse<UptimeResponse>> uptime(RpcRequest<UptimeRequest> request);

  factory InfoApi.create({required ROINetwork roiNetwork}) {
    return _InfoApiImpl(roiNetwork: roiNetwork);
  }
}

class _InfoApiImpl implements InfoApi {
  @override
  ROINetwork roiNetwork;

  late InfoRestClient _infoRestClient;

  _InfoApiImpl({required this.roiNetwork}) {
    _infoRestClient = InfoRestClient(roiNetwork.dio);
  }

  @override
  Future<RpcResponse<GetBlockchainIdResponse>> getBlockchainId(
      RpcRequest<GetBlockchainIdRequest> request) {
    return _infoRestClient.getBlockchainId(request);
  }

  @override
  Future<RpcResponse<GetNetworkIdResponse>> getNetworkId(
      RpcRequest<GetNetworkIdRequest> request) {
    return _infoRestClient.getNetworkId(request);
  }

  @override
  Future<RpcResponse<GetNetworkNameResponse>> getNetworkName(
      RpcRequest<GetNetworkNameRequest> request) {
    return _infoRestClient.getNetworkName(request);
  }

  @override
  Future<RpcResponse<GetNodeIdResponse>> getNodeId(
      RpcRequest<GetNodeIdRequest> request) {
    return _infoRestClient.getNodeId(request);
  }

  @override
  Future<RpcResponse<GetNodeIpResponse>> getNodeIp(
      RpcRequest<GetNodeIpRequest> request) {
    return _infoRestClient.getNodeIp(request);
  }

  @override
  Future<RpcResponse<GetNodeVersionResponse>> getNodeVersion(
      RpcRequest<GetNodeVersionRequest> request) {
    return _infoRestClient.getNodeVersion(request);
  }

  @override
  Future<RpcResponse<GetTxFeeResponse>> getTxFee(
      RpcRequest<GetTxFeeRequest> request) {
    return _infoRestClient.getTxFee(request);
  }

  @override
  Future<RpcResponse<IsBootstrappedResponse>> isBootstrapped(
      RpcRequest<IsBootstrappedRequest> request) {
    return _infoRestClient.isBootstrapped(request);
  }

  @override
  Future<RpcResponse<PeersResponse>> peers(RpcRequest<PeersRequest> request) {
    return _infoRestClient.peers(request);
  }

  @override
  Future<RpcResponse<UptimeResponse>> uptime(
      RpcRequest<UptimeRequest> request) {
    return _infoRestClient.uptime(request);
  }
}

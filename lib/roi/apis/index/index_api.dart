import 'package:wallet/roi/apis/index/model/get_container_by_id.dart';
import 'package:wallet/roi/apis/index/model/get_container_by_index.dart';
import 'package:wallet/roi/apis/index/model/get_container_range.dart';
import 'package:wallet/roi/apis/index/model/get_index.dart';
import 'package:wallet/roi/apis/index/model/get_last_accepted.dart';
import 'package:wallet/roi/apis/index/model/is_accepted.dart';
import 'package:wallet/roi/apis/index/rest/index_rest_client.dart';
import 'package:wallet/roi/common/rpc/rpc_request.dart';
import 'package:wallet/roi/common/rpc/rpc_response.dart';
import 'package:wallet/roi/apis/roi_api.dart';
import 'package:wallet/roi/roi.dart';

enum IndexChainType {
  xChainTransactions,
  xChainVertices,
  pChainBlocks,
  cChainBlocks
}

extension _IndexChainTypeEndPoint on IndexChainType {
  String get endPoint {
    switch (this) {
      case IndexChainType.xChainTransactions:
        return "/ext/index/X/tx";
      case IndexChainType.xChainVertices:
        return "/ext/index/X/vtx";
      case IndexChainType.pChainBlocks:
        return "/ext/index/P/block";
      case IndexChainType.cChainBlocks:
        return "/ext/index/C/block";
    }
  }
}

abstract class IndexApi implements ROIApi {
  IndexChainApi get(IndexChainType type);

  factory IndexApi.create({required ROINetwork roiNetwork}) {
    return _IndexApiImpl(roiNetwork: roiNetwork);
  }
}

class _IndexApiImpl implements IndexApi {
  @override
  ROINetwork roiNetwork;

  final Map<IndexChainType, IndexChainApi> _apis = {};

  _IndexApiImpl({required this.roiNetwork}) {
    _apis[IndexChainType.xChainTransactions] = _IndexChainApiImpl(
        roiNetwork: roiNetwork,
        endPoint: IndexChainType.xChainTransactions.endPoint);

    _apis[IndexChainType.xChainVertices] = _IndexChainApiImpl(
        roiNetwork: roiNetwork,
        endPoint: IndexChainType.xChainVertices.endPoint);

    _apis[IndexChainType.pChainBlocks] = _IndexChainApiImpl(
        roiNetwork: roiNetwork, endPoint: IndexChainType.pChainBlocks.endPoint);

    _apis[IndexChainType.cChainBlocks] = _IndexChainApiImpl(
        roiNetwork: roiNetwork, endPoint: IndexChainType.cChainBlocks.endPoint);
  }

  @override
  IndexChainApi get(IndexChainType type) {
    return _apis[type]!;
  }
}

abstract class IndexChainApi implements ROIApi {
  late String endPoint;

  Future<RpcResponse<GetLastAcceptedResponse>> getLastAccepted(
      RpcRequest<GetLastAcceptedRequest> request);

  Future<RpcResponse<GetContainerByIndexResponse>> getContainerByIndex(
      RpcRequest<GetContainerByIndexRequest> request);

  Future<RpcResponse<GetContainerByIdResponse>> getContainerById(
      RpcRequest<GetContainerByIdRequest> request);

  Future<RpcResponse<GetContainerRangeResponse>> getContainerRange(
      RpcRequest<GetContainerRangeRequest> request);

  Future<RpcResponse<GetIndexResponse>> getIndex(
      RpcRequest<GetIndexRequest> request);

  Future<RpcResponse<ISAcceptedResponse>> isAccepted(
      RpcRequest<ISAcceptedRequest> request);
}

class _IndexChainApiImpl implements IndexChainApi {
  @override
  ROINetwork roiNetwork;

  @override
  String endPoint;

  late IndexRestClient _indexRestClient;

  _IndexChainApiImpl({required this.roiNetwork, required this.endPoint}) {
    final dio = roiNetwork.dio;
    _indexRestClient =
        IndexRestClient(dio, baseUrl: dio.options.baseUrl + endPoint);
  }

  @override
  Future<RpcResponse<GetContainerByIdResponse>> getContainerById(
      RpcRequest<GetContainerByIdRequest> request) {
    return _indexRestClient.getContainerById(request);
  }

  @override
  Future<RpcResponse<GetContainerByIndexResponse>> getContainerByIndex(
      RpcRequest<GetContainerByIndexRequest> request) {
    return _indexRestClient.getContainerByIndex(request);
  }

  @override
  Future<RpcResponse<GetContainerRangeResponse>> getContainerRange(
      RpcRequest<GetContainerRangeRequest> request) {
    return _indexRestClient.getContainerRange(request);
  }

  @override
  Future<RpcResponse<GetIndexResponse>> getIndex(
      RpcRequest<GetIndexRequest> request) {
    return _indexRestClient.getIndex(request);
  }

  @override
  Future<RpcResponse<GetLastAcceptedResponse>> getLastAccepted(
      RpcRequest<GetLastAcceptedRequest> request) {
    return _indexRestClient.getLastAccepted(request);
  }

  @override
  Future<RpcResponse<ISAcceptedResponse>> isAccepted(
      RpcRequest<ISAcceptedRequest> request) {
    return _indexRestClient.isAccepted(request);
  }
}

import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc_request_wrapper.dart';

part 'get_node_id.g.dart';

@JsonSerializable()
class GetNodeIdRequest with RpcRequestWrapper<GetNodeIdRequest> {
  const GetNodeIdRequest();

  @override
  String method() {
    return "info.getNodeID";
  }

  factory GetNodeIdRequest.fromJson(Map<String, dynamic> json) =>
      _$GetNodeIdRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetNodeIdRequestToJson(this);
}

@JsonSerializable()
class GetNodeIdResponse {
  @JsonKey(name: "nodeID")
  final String nodeId;

  const GetNodeIdResponse({required this.nodeId});

  factory GetNodeIdResponse.fromJson(Map<String, dynamic> json) =>
      _$GetNodeIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetNodeIdResponseToJson(this);
}

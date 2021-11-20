import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'get_node_ip.g.dart';

@JsonSerializable()
class GetNodeIpRequest with RpcRequestWrapper<GetNodeIpRequest> {
  const GetNodeIpRequest();

  @override
  String method() {
    return "info.getNodeIP";
  }

  factory GetNodeIpRequest.fromJson(Map<String, dynamic> json) =>
      _$GetNodeIpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetNodeIpRequestToJson(this);
}

@JsonSerializable()
class GetNodeIpResponse {
  final String ip;

  const GetNodeIpResponse({required this.ip});

  factory GetNodeIpResponse.fromJson(Map<String, dynamic> json) =>
      _$GetNodeIpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetNodeIpResponseToJson(this);
}

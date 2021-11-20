import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'get_index.g.dart';

@JsonSerializable()
class GetIndexRequest with RpcRequestWrapper<GetIndexRequest> {
  @JsonKey(name: "containerID")
  final String containerId;
  final String encoding;

  const GetIndexRequest({required this.containerId, required this.encoding});

  @override
  String method() {
    return "index.getIndex";
  }

  factory GetIndexRequest.fromJson(Map<String, dynamic> json) =>
      _$GetIndexRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetIndexRequestToJson(this);
}

@JsonSerializable()
class GetIndexResponse {
  final String index;

  const GetIndexResponse({required this.index});

  factory GetIndexResponse.fromJson(Map<String, dynamic> json) =>
      _$GetIndexResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetIndexResponseToJson(this);
}

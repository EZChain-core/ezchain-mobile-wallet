import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc_request_wrapper.dart';

part 'get_container_by_id.g.dart';

@JsonSerializable()
class GetContainerByIdRequest with RpcRequestWrapper<GetContainerByIdRequest> {

  @JsonKey(name: "containerID")
  final String containerId;
  final String encoding;

  const GetContainerByIdRequest({required this.containerId, required this.encoding});

  @override
  String method() {
    return "index.getContainerByID";
  }

  factory GetContainerByIdRequest.fromJson(Map<String, dynamic> json) =>
      _$GetContainerByIdRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetContainerByIdRequestToJson(this);
}

@JsonSerializable()
class GetContainerByIdResponse {
  final String id;
  final String bytes;
  final String timestamp;
  final String encoding;
  final String index;

  const GetContainerByIdResponse(
      {required this.id,
      required this.bytes,
      required this.timestamp,
      required this.encoding,
      required this.index});

  factory GetContainerByIdResponse.fromJson(Map<String, dynamic> json) =>
      _$GetContainerByIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetContainerByIdResponseToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc_request_wrapper.dart';

part 'is_accepted.g.dart';

@JsonSerializable()
class ISAcceptedRequest with RpcRequestWrapper<ISAcceptedRequest> {
  @JsonKey(name: "containerID")
  final String containerId;
  final String encoding;

  const ISAcceptedRequest({required this.containerId, required this.encoding});

  @override
  String method() {
    return "index.isAccepted";
  }

  factory ISAcceptedRequest.fromJson(Map<String, dynamic> json) =>
      _$ISAcceptedRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ISAcceptedRequestToJson(this);
}

@JsonSerializable()
class ISAcceptedResponse {
  final bool isAccepted;

  const ISAcceptedResponse({required this.isAccepted});

  factory ISAcceptedResponse.fromJson(Map<String, dynamic> json) =>
      _$ISAcceptedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ISAcceptedResponseToJson(this);
}

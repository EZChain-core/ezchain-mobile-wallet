import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc_request_wrapper.dart';

part 'get_last_accepted.g.dart';

@JsonSerializable()
class GetLastAcceptedRequest with RpcRequestWrapper<GetLastAcceptedRequest> {
  final String encoding;

  const GetLastAcceptedRequest({required this.encoding});

  @override
  String method() {
    return "index.getLastAccepted";
  }

  factory GetLastAcceptedRequest.fromJson(Map<String, dynamic> json) =>
      _$GetLastAcceptedRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetLastAcceptedRequestToJson(this);
}

@JsonSerializable()
class GetLastAcceptedResponse {
  final String id;
  final String bytes;
  final String timestamp;
  final String encoding;
  final String index;

  const GetLastAcceptedResponse(
      {required this.id,
        required this.bytes,
        required this.timestamp,
        required this.encoding,
        required this.index});

  factory GetLastAcceptedResponse.fromJson(Map<String, dynamic> json) =>
      _$GetLastAcceptedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetLastAcceptedResponseToJson(this);
}

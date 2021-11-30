import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_container_range.g.dart';

@JsonSerializable()
class GetContainerRangeRequest
    with RpcRequestWrapper<GetContainerRangeRequest> {
  final int startIndex;
  final int numToFetch;
  final String encoding;

  const GetContainerRangeRequest(
      {required this.startIndex,
      required this.numToFetch,
      required this.encoding});

  @override
  String method() {
    return "index.getContainerRange";
  }

  factory GetContainerRangeRequest.fromJson(Map<String, dynamic> json) =>
      _$GetContainerRangeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetContainerRangeRequestToJson(this);
}

@JsonSerializable()
class GetContainerRangeResponse {
  final String id;
  final String bytes;
  final String timestamp;
  final String encoding;
  final String index;

  const GetContainerRangeResponse(
      {required this.id,
      required this.bytes,
      required this.timestamp,
      required this.encoding,
      required this.index});

  factory GetContainerRangeResponse.fromJson(Map<String, dynamic> json) =>
      _$GetContainerRangeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetContainerRangeResponseToJson(this);
}

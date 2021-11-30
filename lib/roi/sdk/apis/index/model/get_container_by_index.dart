import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_container_by_index.g.dart';

@JsonSerializable()
class GetContainerByIndexRequest
    with RpcRequestWrapper<GetContainerByIndexRequest> {
  final int index;
  final String encoding;

  const GetContainerByIndexRequest(
      {required this.index, required this.encoding});

  @override
  String method() {
    return "index.getContainerByIndex";
  }

  factory GetContainerByIndexRequest.fromJson(Map<String, dynamic> json) =>
      _$GetContainerByIndexRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetContainerByIndexRequestToJson(this);
}

@JsonSerializable()
class GetContainerByIndexResponse {
  final String id;
  final String bytes;
  final String timestamp;
  final String encoding;
  final String index;

  const GetContainerByIndexResponse(
      {required this.id,
      required this.bytes,
      required this.timestamp,
      required this.encoding,
      required this.index});

  factory GetContainerByIndexResponse.fromJson(Map<String, dynamic> json) =>
      _$GetContainerByIndexResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetContainerByIndexResponseToJson(this);
}

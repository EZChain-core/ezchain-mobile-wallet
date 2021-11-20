import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'get_node_version.g.dart';

@JsonSerializable()
class GetNodeVersionRequest with RpcRequestWrapper<GetNodeVersionRequest> {
  const GetNodeVersionRequest();

  @override
  String method() {
    return "info.getNodeVersion";
  }

  factory GetNodeVersionRequest.fromJson(Map<String, dynamic> json) =>
      _$GetNodeVersionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetNodeVersionRequestToJson(this);
}

@JsonSerializable()
class GetNodeVersionResponse {
  final String version;
  final String databaseVersion;
  final String gitCommit;
  final NodeVmVersion vmVersions;

  const GetNodeVersionResponse(
      {required this.version,
      required this.databaseVersion,
      required this.gitCommit,
      required this.vmVersions});

  factory GetNodeVersionResponse.fromJson(Map<String, dynamic> json) =>
      _$GetNodeVersionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetNodeVersionResponseToJson(this);
}

@JsonSerializable()
class NodeVmVersion {
  final String avm;
  final String evm;
  final String platform;

  const NodeVmVersion(
      {required this.avm, required this.evm, required this.platform});

  factory NodeVmVersion.fromJson(Map<String, dynamic> json) =>
      _$NodeVmVersionFromJson(json);

  Map<String, dynamic> toJson() => _$NodeVmVersionToJson(this);
}

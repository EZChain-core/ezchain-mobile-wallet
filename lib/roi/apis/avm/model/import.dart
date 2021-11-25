import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'import.g.dart';

@JsonSerializable()
class ImportRequest with RpcRequestWrapper<ImportRequest> {
  final String to;

  final String sourceChain;

  final String username;

  final String password;

  const ImportRequest(
      {required this.to,
      required this.sourceChain,
      required this.username,
      required this.password});

  @override
  String method() {
    return "avm.import";
  }

  factory ImportRequest.fromJson(Map<String, dynamic> json) =>
      _$ImportRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ImportRequestToJson(this);
}

@JsonSerializable()
class ImportResponse {
  @JsonKey(name: "txID")
  final String txId;

  const ImportResponse({required this.txId});

  factory ImportResponse.fromJson(Map<String, dynamic> json) =>
      _$ImportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ImportResponseToJson(this);
}

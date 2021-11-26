import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'export_key.g.dart';

@JsonSerializable()
class ExportKeyRequest with RpcRequestWrapper<ExportKeyRequest> {
  final String address;

  final String username;

  final String password;

  const ExportKeyRequest(
      {required this.address, required this.username, required this.password});

  @override
  String method() {
    return "avm.exportKey";
  }

  factory ExportKeyRequest.fromJson(Map<String, dynamic> json) =>
      _$ExportKeyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ExportKeyRequestToJson(this);
}

@JsonSerializable()
class ExportKeyResponse {
  final String privateKey;

  const ExportKeyResponse({required this.privateKey});

  factory ExportKeyResponse.fromJson(Map<String, dynamic> json) =>
      _$ExportKeyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExportKeyResponseToJson(this);
}

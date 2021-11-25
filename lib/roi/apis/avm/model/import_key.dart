import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'import_key.g.dart';

@JsonSerializable()
class ImportKeyRequest with RpcRequestWrapper<ImportKeyRequest> {
  final String privateKey;

  final String username;

  final String password;

  const ImportKeyRequest(
      {required this.privateKey,
      required this.username,
      required this.password});

  @override
  String method() {
    return "avm.importKey";
  }

  factory ImportKeyRequest.fromJson(Map<String, dynamic> json) =>
      _$ImportKeyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ImportKeyRequestToJson(this);
}

@JsonSerializable()
class ImportKeyResponse {
  final String address;

  const ImportKeyResponse({required this.address});

  factory ImportKeyResponse.fromJson(Map<String, dynamic> json) =>
      _$ImportKeyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ImportKeyResponseToJson(this);
}

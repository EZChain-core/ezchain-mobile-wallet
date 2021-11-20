import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'import_user.g.dart';

@JsonSerializable()
class ImportUserRequest with RpcRequestWrapper<ImportUserRequest> {
  final String username;
  final String password;
  final String user;
  final String? encoding;

  const ImportUserRequest(
      {required this.username,
      required this.password,
      required this.user,
      this.encoding});

  @override
  String method() {
    return "keystore.importUser";
  }

  factory ImportUserRequest.fromJson(Map<String, dynamic> json) =>
      _$ImportUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ImportUserRequestToJson(this);
}

@JsonSerializable()
class ImportUserResponse {
  final bool success;

  const ImportUserResponse({required this.success});

  factory ImportUserResponse.fromJson(Map<String, dynamic> json) =>
      _$ImportUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ImportUserResponseToJson(this);
}

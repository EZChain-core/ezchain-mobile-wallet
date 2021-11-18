import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc_request_wrapper.dart';

part 'export_user.g.dart';

@JsonSerializable()
class ExportUserRequest with RpcRequestWrapper<ExportUserRequest> {
  final String username;
  final String password;
  final String? encoding;

  const ExportUserRequest(
      {required this.username, required this.password, this.encoding});

  @override
  String method() {
    return "keystore.exportUser";
  }

  factory ExportUserRequest.fromJson(Map<String, dynamic> json) =>
      _$ExportUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ExportUserRequestToJson(this);
}

@JsonSerializable()
class ExportUserResponse {
  final String user;
  final String encoding;

  const ExportUserResponse({required this.user, required this.encoding});

  factory ExportUserResponse.fromJson(Map<String, dynamic> json) =>
      _$ExportUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExportUserResponseToJson(this);
}

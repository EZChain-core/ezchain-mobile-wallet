import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'delete_user.g.dart';

@JsonSerializable()
class DeleteUserRequest with RpcRequestWrapper<DeleteUserRequest> {
  final String username;
  final String password;

  const DeleteUserRequest({required this.username, required this.password});

  @override
  String method() {
    return "keystore.deleteUser";
  }

  factory DeleteUserRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteUserRequestToJson(this);
}

@JsonSerializable()
class DeleteUserResponse {
  final bool success;

  const DeleteUserResponse({required this.success});

  factory DeleteUserResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteUserResponseToJson(this);
}

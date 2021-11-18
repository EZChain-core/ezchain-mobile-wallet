import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc_request_wrapper.dart';

part 'create_user.g.dart';

@JsonSerializable()
class CreateUserRequest with RpcRequestWrapper<CreateUserRequest> {
  final String username;
  final String password;

  const CreateUserRequest({required this.username, required this.password});

  @override
  String method() {
    return "keystore.createUser";
  }

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);
}

@JsonSerializable()
class CreateUserResponse {
  final bool success;

  const CreateUserResponse({required this.success});

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserResponseToJson(this);
}

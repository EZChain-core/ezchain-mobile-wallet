import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc_request_wrapper.dart';

part 'change_password.g.dart';

@JsonSerializable()
class ChangePasswordRequest with RpcRequestWrapper<ChangePasswordRequest> {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordRequest(
      {required this.oldPassword, required this.newPassword});

  @override
  String method() {
    return "auth.changePassword";
  }

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}

@JsonSerializable()
class ChangePasswordResponse {
  final bool success;

  const ChangePasswordResponse({required this.success});

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordResponseToJson(this);
}

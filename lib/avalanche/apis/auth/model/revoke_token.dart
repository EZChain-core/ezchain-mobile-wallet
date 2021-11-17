import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/avalanche/common/rpc_request_wrapper.dart';

part 'revoke_token.g.dart';

@JsonSerializable()
class RevokeTokenRequest with RpcRequestWrapper<RevokeTokenRequest> {
  final String password;
  final String token;

  RevokeTokenRequest({required this.password, required this.token});

  @override
  String method() {
    return "auth.revokeToken";
  }

  factory RevokeTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RevokeTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RevokeTokenRequestToJson(this);
}

@JsonSerializable()
class RevokeTokenResponse {
  final bool success;

  RevokeTokenResponse({required this.success});

  factory RevokeTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RevokeTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RevokeTokenResponseToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/avalanche/common/rpc_request_wrapper.dart';

part 'new_token.g.dart';

@JsonSerializable()
class NewTokenRequest with RpcRequestWrapper<NewTokenRequest> {
  final String password;
  final List<String> endpoints;

  NewTokenRequest({required this.password, required this.endpoints});

  @override
  String method() {
    return "auth.newToken";
  }

  factory NewTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$NewTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NewTokenRequestToJson(this);
}

@JsonSerializable()
class NewTokenResponse {
  final String token;

  NewTokenResponse({required this.token});

  factory NewTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$NewTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NewTokenResponseToJson(this);
}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wallet/roi/apis/auth/model/change_password.dart';
import 'package:wallet/roi/apis/auth/model/new_token.dart';
import 'package:wallet/roi/apis/auth/model/revoke_token.dart';
import 'package:wallet/roi/common/rpc_request.dart';
import 'package:wallet/roi/common/rpc_response.dart';

part 'auth_api.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/auth-api
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  static const endPoint = "/ext/auth";

  @POST(endPoint)
  Future<RpcResponse<NewTokenResponse>> newToken(
      @Body() RpcRequest<NewTokenRequest> request);

  @POST(endPoint)
  Future<RpcResponse<RevokeTokenResponse>> revokeToken(
      @Body() RpcRequest<RevokeTokenRequest> request);

  @POST(endPoint)
  Future<RpcResponse<ChangePasswordResponse>> changePassword(
      @Body() RpcRequest<ChangePasswordRequest> request);
}

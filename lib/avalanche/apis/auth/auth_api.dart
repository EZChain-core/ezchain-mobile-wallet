import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wallet/avalanche/apis/auth/model/change_password.dart';
import 'package:wallet/avalanche/apis/auth/model/new_token.dart';
import 'package:wallet/avalanche/apis/auth/model/revoke_token.dart';
import 'package:wallet/avalanche/common/rpc_request.dart';
import 'package:wallet/avalanche/common/rpc_response.dart';
import 'package:wallet/avalanche/utils/constants.dart';

part 'auth_api.g.dart';

// https://docs.avax.network/build/avalanchego-apis/auth-api
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @GET(authEndPoint)
  Future<RpcResponse<NewTokenResponse>> newToken(
      @Body() RpcRequest<NewTokenRequest> request);

  @GET(authEndPoint)
  Future<RpcResponse<RevokeTokenResponse>> revokeToken(
      @Body() RpcRequest<RevokeTokenRequest> request);

  @GET(authEndPoint)
  Future<RpcResponse<ChangePasswordResponse>> changePassword(
      @Body() RpcRequest<ChangePasswordRequest> request);
}

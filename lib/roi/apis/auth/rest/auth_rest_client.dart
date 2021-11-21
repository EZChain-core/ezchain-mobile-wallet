import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wallet/roi/apis/auth/model/change_password.dart';
import 'package:wallet/roi/apis/auth/model/new_token.dart';
import 'package:wallet/roi/apis/auth/model/revoke_token.dart';
import 'package:wallet/roi/common/rpc/rpc_request.dart';
import 'package:wallet/roi/common/rpc/rpc_response.dart';

part 'auth_rest_client.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/auth-api
@RestApi()
abstract class AuthRestClient {
  factory AuthRestClient(Dio dio) = _AuthRestClient;

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

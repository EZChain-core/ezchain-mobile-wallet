import 'package:wallet/roi/apis/auth/model/change_password.dart';
import 'package:wallet/roi/apis/auth/model/new_token.dart';
import 'package:wallet/roi/apis/auth/model/revoke_token.dart';
import 'package:wallet/roi/apis/roi_api.dart';
import 'package:wallet/roi/common/rpc/rpc_request.dart';
import 'package:wallet/roi/common/rpc/rpc_response.dart';

abstract class AuthApi implements ROIApi {
  Future<RpcResponse<NewTokenResponse>> newToken(
      RpcRequest<NewTokenRequest> request);

  Future<RpcResponse<RevokeTokenResponse>> revokeToken(
      RpcRequest<RevokeTokenRequest> request);

  Future<RpcResponse<ChangePasswordResponse>> changePassword(
      RpcRequest<ChangePasswordRequest> request);
}

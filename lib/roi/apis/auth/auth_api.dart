import 'package:wallet/roi/apis/auth/model/change_password.dart';
import 'package:wallet/roi/apis/auth/model/new_token.dart';
import 'package:wallet/roi/apis/auth/model/revoke_token.dart';
import 'package:wallet/roi/apis/auth/rest/auth_rest_client.dart';
import 'package:wallet/roi/apis/roi_api.dart';
import 'package:wallet/roi/common/rpc/rpc_request.dart';
import 'package:wallet/roi/common/rpc/rpc_response.dart';
import 'package:wallet/roi/roi.dart';

abstract class AuthApi implements ROIApi {
  Future<RpcResponse<NewTokenResponse>> newToken(
      RpcRequest<NewTokenRequest> request);

  Future<RpcResponse<RevokeTokenResponse>> revokeToken(
      RpcRequest<RevokeTokenRequest> request);

  Future<RpcResponse<ChangePasswordResponse>> changePassword(
      RpcRequest<ChangePasswordRequest> request);

  factory AuthApi.create({required ROINetwork roiNetwork}) {
    return _AuthApiImpl(roiNetwork: roiNetwork);
  }
}

class _AuthApiImpl implements AuthApi {
  @override
  ROINetwork roiNetwork;

  late AuthRestClient _authRestClient;

  _AuthApiImpl({required this.roiNetwork}) {
    _authRestClient = AuthRestClient(roiNetwork.dio);
  }

  @override
  Future<RpcResponse<ChangePasswordResponse>> changePassword(
      RpcRequest<ChangePasswordRequest> request) {
    return _authRestClient.changePassword(request);
  }

  @override
  Future<RpcResponse<NewTokenResponse>> newToken(
      RpcRequest<NewTokenRequest> request) {
    return _authRestClient.newToken(request);
  }

  @override
  Future<RpcResponse<RevokeTokenResponse>> revokeToken(
      RpcRequest<RevokeTokenRequest> request) {
    return _authRestClient.revokeToken(request);
  }
}

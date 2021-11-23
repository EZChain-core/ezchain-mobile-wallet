import 'package:wallet/roi/apis/keystore/rest/keystore_rest_client.dart';
import 'package:wallet/roi/apis/roi_api.dart';
import 'package:wallet/roi/roi.dart';
import 'package:wallet/roi/apis/keystore/model/create_user.dart';
import 'package:wallet/roi/apis/keystore/model/delete_user.dart';
import 'package:wallet/roi/apis/keystore/model/export_user.dart';
import 'package:wallet/roi/apis/keystore/model/import_user.dart';
import 'package:wallet/roi/apis/keystore/model/list_users.dart';
import 'package:wallet/roi/common/rpc/rpc_request.dart';
import 'package:wallet/roi/common/rpc/rpc_response.dart';

abstract class KeyStoreApi implements ROIApi {
  Future<RpcResponse<CreateUserResponse>> createUser(
      RpcRequest<CreateUserRequest> request);

  Future<RpcResponse<DeleteUserResponse>> deleteUser(
      RpcRequest<DeleteUserRequest> request);

  Future<RpcResponse<ExportUserResponse>> exportUser(
      RpcRequest<ExportUserRequest> request);

  Future<RpcResponse<ImportUserResponse>> importUser(
      RpcRequest<ImportUserRequest> request);

  Future<RpcResponse<ListUsersResponse>> listUsers(
      RpcRequest<ListUsersRequest> request);

  factory KeyStoreApi.create({required ROINetwork roiNetwork}) {
    return _KeyStoreApiImpl(roiNetwork: roiNetwork);
  }
}

class _KeyStoreApiImpl implements KeyStoreApi {
  @override
  ROINetwork roiNetwork;

  late KeystoreRestClient _keystoreRestClient;

  _KeyStoreApiImpl({required this.roiNetwork}) {
    _keystoreRestClient = KeystoreRestClient(roiNetwork.dio);
  }

  @override
  Future<RpcResponse<CreateUserResponse>> createUser(
      RpcRequest<CreateUserRequest> request) {
    return _keystoreRestClient.createUser(request);
  }

  @override
  Future<RpcResponse<DeleteUserResponse>> deleteUser(
      RpcRequest<DeleteUserRequest> request) {
    return _keystoreRestClient.deleteUser(request);
  }

  @override
  Future<RpcResponse<ExportUserResponse>> exportUser(
      RpcRequest<ExportUserRequest> request) {
    return _keystoreRestClient.exportUser(request);
  }

  @override
  Future<RpcResponse<ImportUserResponse>> importUser(
      RpcRequest<ImportUserRequest> request) {
    return _keystoreRestClient.importUser(request);
  }

  @override
  Future<RpcResponse<ListUsersResponse>> listUsers(
      RpcRequest<ListUsersRequest> request) {
    return _keystoreRestClient.listUsers(request);
  }
}

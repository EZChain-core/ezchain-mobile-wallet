import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wallet/roi/apis/keystore/model/create_user.dart';
import 'package:wallet/roi/apis/keystore/model/delete_user.dart';
import 'package:wallet/roi/apis/keystore/model/export_user.dart';
import 'package:wallet/roi/apis/keystore/model/import_user.dart';
import 'package:wallet/roi/apis/keystore/model/list_users.dart';
import 'package:wallet/roi/common/rpc/rpc_request.dart';
import 'package:wallet/roi/common/rpc/rpc_response.dart';

part 'keystore_rest_client.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/keystore-api
@RestApi()
abstract class KeystoreRestClient {
  factory KeystoreRestClient(Dio dio) = _KeystoreRestClient;

  static const endPoint = "/ext/keystore";

  @POST(endPoint)
  Future<RpcResponse<CreateUserResponse>> createUser(
      @Body() RpcRequest<CreateUserRequest> request);

  @POST(endPoint)
  Future<RpcResponse<DeleteUserResponse>> deleteUser(
      @Body() RpcRequest<DeleteUserRequest> request);

  @POST(endPoint)
  Future<RpcResponse<ExportUserResponse>> exportUser(
      @Body() RpcRequest<ExportUserRequest> request);

  @POST(endPoint)
  Future<RpcResponse<ImportUserResponse>> importUser(
      @Body() RpcRequest<ImportUserRequest> request);

  @POST(endPoint)
  Future<RpcResponse<ListUsersResponse>> listUsers(
      @Body() RpcRequest<ListUsersRequest> request);
}
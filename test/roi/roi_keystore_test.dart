import 'dart:convert';

import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';
import 'package:wallet/roi/apis/keystore/model/create_user.dart';
import 'package:wallet/roi/apis/keystore/model/delete_user.dart';
import 'package:wallet/roi/apis/keystore/model/export_user.dart';
import 'package:wallet/roi/apis/keystore/model/import_user.dart';
import 'package:wallet/roi/apis/keystore/model/list_users.dart';
import 'package:wallet/roi/roi.dart';
import 'package:wallet/roi/common/rpc_response.dart';

late MockWebServer _server;
late ROI _roi;

const _headers = {
  "Content-Type": "application/json",
};

void main() {
  setUp(() async {
    _server = MockWebServer();
    await _server.start();
    _roi = ROICore(host: _server.host, port: _server.port, protocol: "http");
  });

  tearDown(() {
    _server.shutdown();
  });

  test("Create User Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(
            const RpcResponse(result: CreateUserResponse(success: true))
                .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.keystoreApi.createUser(
      const CreateUserRequest(username: "myUsername", password: "myPassword")
          .toRpc(),
    );

    expect(response.result?.success, true);
  });

  test("Delete User Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(
            const RpcResponse(result: DeleteUserResponse(success: true))
                .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.keystoreApi.deleteUser(
      const DeleteUserRequest(username: "myUsername", password: "myPassword")
          .toRpc(),
    );

    expect(response.result?.success, true);
  });

  test("Export User Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(const RpcResponse(
                result: ExportUserResponse(user: "user", encoding: "cb58"))
            .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.keystoreApi.exportUser(
      const ExportUserRequest(username: "myUsername", password: "myPassword")
          .toRpc(),
    );

    expect(response.result?.user, "user");
    expect(response.result?.encoding, "cb58");
  });

  test("Import User Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(
            const RpcResponse(result: ImportUserResponse(success: true))
                .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.keystoreApi.importUser(
      const ImportUserRequest(
              username: "myUsername", password: "myPassword", user: "user")
          .toRpc(),
    );

    expect(response.result?.success, true);
  });

  test("List Users Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(
            const RpcResponse(result: ListUsersResponse(users: ["myUsername"]))
                .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.keystoreApi.listUsers(
      const ListUsersRequest().toRpc(),
    );

    expect(response.result?.users, ["myUsername"]);
  });
}

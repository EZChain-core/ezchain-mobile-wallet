import 'dart:convert';

import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';
import 'package:wallet/avalanche/apis/auth/model/change_password.dart';
import 'package:wallet/avalanche/apis/auth/model/new_token.dart';
import 'package:wallet/avalanche/apis/auth/model/revoke_token.dart';
import 'package:wallet/avalanche/avalanche.dart';
import 'package:wallet/avalanche/common/rpc_response.dart';

late MockWebServer _server;
late Avalanche _avalanche;

const _headers = {
  "Content-Type": "application/json",
};

void main() {
  setUp(() async {
    _server = MockWebServer();
    await _server.start();
    _avalanche =
        AvalancheCore(host: _server.host, port: _server.port, protocol: "http");
  });

  tearDown(() {
    _server.shutdown();
  });

  test("New Token Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(RpcResponse(result: NewTokenResponse(token: "123"))
            .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _avalanche.authApi.newToken(
      NewTokenRequest(
        password: "password",
        endpoints: [],
      ).toRpc(),
    );

    expect(response.result.token, "123");
  });

  test("Revoke Token Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(
            RpcResponse(result: RevokeTokenResponse(success: true))
                .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _avalanche.authApi.revokeToken(
      RevokeTokenRequest(
        password: "password",
        token: "token",
      ).toRpc(),
    );

    expect(response.result.success, true);
  });

  test("Change Password Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(
            RpcResponse(result: ChangePasswordResponse(success: true))
                .toJson((value) => value.toJson())),
        headers: _headers);
    final response = await _avalanche.authApi.changePassword(
      ChangePasswordRequest(
        oldPassword: "oldPassword",
        newPassword: "newPassword",
      ).toRpc(),
    );

    expect(response.result.success, true);
  });
}

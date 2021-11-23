import 'dart:convert';

import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';
import 'package:wallet/roi/apis/auth/model/change_password.dart';
import 'package:wallet/roi/apis/auth/model/new_token.dart';
import 'package:wallet/roi/apis/auth/model/revoke_token.dart';
import 'package:wallet/roi/roi.dart';
import 'package:wallet/roi/common/rpc/rpc_response.dart';

late MockWebServer _server;
late ROI _roi;

const _headers = {
  "Content-Type": "application/json",
};

void main() {
  setUp(() async {
    _server = MockWebServer();
    await _server.start();
    _roi = ROI.create(host: _server.host, port: _server.port, protocol: "http");
  });

  tearDown(() {
    _server.shutdown();
  });

  test("New Token Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(
            const RpcResponse(result: NewTokenResponse(token: "123"))
                .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.authApi.newToken(
      const NewTokenRequest(
        password: "password",
        endpoints: [],
      ).toRpc(),
    );

    expect(response.result?.token, "123");
  });

  test("New Token Error", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(const RpcResponse(
                error: RpcError(
                    code: -32600,
                    message: "[Some error message here]",
                    data:
                        "[Object with additional information about the error]"))
            .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.authApi.newToken(
      const NewTokenRequest(
        password: "password",
        endpoints: [],
      ).toRpc(),
    );

    expect(response.result, null);
    expect(response.error?.code, -32600);
  });

  test("Revoke Token Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(
            const RpcResponse(result: RevokeTokenResponse(success: true))
                .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.authApi.revokeToken(
      const RevokeTokenRequest(
        password: "password",
        token: "token",
      ).toRpc(),
    );

    expect(response.result?.success, true);
  });

  test("Change Password Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(
            const RpcResponse(result: ChangePasswordResponse(success: true))
                .toJson((value) => value.toJson())),
        headers: _headers);
    final response = await _roi.authApi.changePassword(
      const ChangePasswordRequest(
        oldPassword: "oldPassword",
        newPassword: "newPassword",
      ).toRpc(),
    );

    expect(response.result?.success, true);
  });
}

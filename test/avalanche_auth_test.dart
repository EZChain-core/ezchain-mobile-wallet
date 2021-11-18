import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';
import 'package:wallet/avalanche/apis/auth/model/change_password.dart';
import 'package:wallet/avalanche/avalanche.dart';
import 'package:wallet/avalanche/common/rpc_response.dart';
import 'package:wallet/avalanche/utils/constants.dart';

late MockWebServer _server;
late Avalanche _avalanche;

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

  test("Kien Test", () async {
    _server.enqueue(
        httpCode: 200,
        body: RpcResponse(result: ChangePasswordResponse(success: true), id: 1)
            .toJson((value) => value.toJson()),
        headers: {"Content-Type": "application/json"});
    final response = await _avalanche.authApi.changePassword(
        ChangePasswordRequest(
                oldPassword: "oldPassword", newPassword: "newPassword")
            .createRpcRequest(1));

    print("response = $response");
    // expect(response.data, {'data': true});
  });
}

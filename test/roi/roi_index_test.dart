import 'dart:convert';

import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';
import 'package:wallet/roi/sdk/apis/auth/model/change_password.dart';
import 'package:wallet/roi/sdk/apis/auth/model/new_token.dart';
import 'package:wallet/roi/sdk/apis/auth/model/revoke_token.dart';
import 'package:wallet/roi/sdk/apis/index/index_api.dart';
import 'package:wallet/roi/sdk/apis/index/model/get_last_accepted.dart';
import 'package:wallet/roi/sdk/roi.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_response.dart';

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

  test("Get Last Accepted Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(const RpcResponse(
                result: GetLastAcceptedResponse(
                    id: "6fXf5hncR8LXvwtM8iezFQBpK5cubV6y1dWgpJCcNyzGB1EzY",
                    bytes:
                        "111115HRzXVDSeonLBcv6QdJkQFjPzPEobMWy7PyGuoheggsMCx73MVXZo2hJMEXXvR5gFFasTRJH36aVkLiWHtTTFcghyFTqjaHnBhdXTRiLaYcro3jpseqLAFVn3ngnAB47nebQiBBKmg3nFWKzQUDxMuE6uDGXgnGouDSaEKZxfKreoLHYNUxH56rgi5c8gKFYSDi8AWBgy26siwAWj6V8EgFnPVgm9pmKCfXio6BP7Bua4vrupoX8jRGqdrdkN12dqGAibJ78Rf44SSUXhEvJtPxAzjEGfiTyAm5BWFqPdheKN72HyrBBtwC6y7wG6suHngZ1PMBh93Ubkbt8jjjGoEgs5NjpasJpE8YA9ZMLTPeNZ6ELFxV99zA46wvkjAwYHGzegBXvzGU5pGPbg28iW3iKhLoYAnReysY4x3fBhjPBsags37Z9P3SqioVifVX4wwzxYqbV72u1AWZ4JNmsnhVDP196Gu99QTzmySGTVGP5ABNdZrngTRfmGTFCRbt9CHsgNbhgetkxbsEG7tySi3gFxMzGuJ2Npk2gnSr68LgtYdSHf48Ns",
                    timestamp: "2021-04-02T15:34:00.262979-07:00",
                    encoding: "cb58",
                    index: "0"))
            .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.indexApi
        .get(IndexChainType.xChainTransactions)
        .getLastAccepted(
          const GetLastAcceptedRequest(encoding: "cb58").toRpc(),
        );

    expect(response.result?.id,
        "6fXf5hncR8LXvwtM8iezFQBpK5cubV6y1dWgpJCcNyzGB1EzY");
  });
}

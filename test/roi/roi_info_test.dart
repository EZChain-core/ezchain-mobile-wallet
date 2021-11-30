import 'dart:convert';

import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';
import 'package:wallet/roi/sdk/apis/info/model/get_blockchain_id.dart';
import 'package:wallet/roi/sdk/apis/info/model/get_network_id.dart';
import 'package:wallet/roi/sdk/apis/info/model/get_network_name.dart';
import 'package:wallet/roi/sdk/apis/info/model/get_node_id.dart';
import 'package:wallet/roi/sdk/apis/info/model/get_node_ip.dart';
import 'package:wallet/roi/sdk/apis/info/model/get_node_version.dart';
import 'package:wallet/roi/sdk/apis/info/model/get_tx_fee.dart';
import 'package:wallet/roi/sdk/apis/info/model/is_bootstrapped.dart';
import 'package:wallet/roi/sdk/apis/info/model/peers.dart';
import 'package:wallet/roi/sdk/apis/info/model/uptime.dart';
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

  test("Get Blockchain Id Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(const RpcResponse(
                result: GetBlockchainIdResponse(blockchainId: "123"))
            .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.infoApi.getBlockchainId(
      const GetBlockchainIdRequest(alias: "X").toRpc(),
    );

    expect(response.result?.blockchainId, "123");
  });

  test("Get Network Id Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(
            const RpcResponse(result: GetNetworkIdResponse(networkId: "123"))
                .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.infoApi.getNetworkId(
      const GetNetworkIdRequest().toRpc(),
    );

    expect(response.result?.networkId, "123");
  });

  test("Get Network Name Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(const RpcResponse(
                result: GetNetworkNameResponse(networkName: "local"))
            .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.infoApi.getNetworkName(
      const GetNetworkNameRequest().toRpc(),
    );

    expect(response.result?.networkName, "local");
  });

  test("Get Node Id Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(const RpcResponse(
                result: GetNodeIdResponse(
                    nodeId: "NodeID-5mb46qkSBj81k9g9e4VFjGGSbaaSLFRzD"))
            .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.infoApi.getNodeId(
      const GetNodeIdRequest().toRpc(),
    );

    expect(response.result?.nodeId, "NodeID-5mb46qkSBj81k9g9e4VFjGGSbaaSLFRzD");
  });

  test("Get Node Ip Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(
            const RpcResponse(result: GetNodeIpResponse(ip: "192.168.1.1:9651"))
                .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.infoApi.getNodeIp(
      const GetNodeIpRequest().toRpc(),
    );

    expect(response.result?.ip, "192.168.1.1:9651");
  });

  test("Get Node Version Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(const RpcResponse(
          result: GetNodeVersionResponse(
            version: "avalanche/1.4.10",
            databaseVersion: "v1.4.5",
            gitCommit: "a3930fe3fa115c018e71eb1e97ca8cec34db67f1",
            vmVersions: NodeVmVersion(
              avm: "v1.4.10",
              evm: "v0.5.5-rc.1",
              platform: "v1.4.10",
            ),
          ),
        ).toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.infoApi.getNodeVersion(
      const GetNodeVersionRequest().toRpc(),
    );

    expect(response.result?.version, "avalanche/1.4.10");
    expect(response.result?.databaseVersion, "v1.4.5");
    expect(
        response.result?.gitCommit, "a3930fe3fa115c018e71eb1e97ca8cec34db67f1");
    expect(response.result?.vmVersions.avm, "v1.4.10");
    expect(response.result?.vmVersions.evm, "v0.5.5-rc.1");
    expect(response.result?.vmVersions.platform, "v1.4.10");
  });

  test("Is Bootstrapped Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(const RpcResponse(
                result: IsBootstrappedResponse(isBootstrapped: true))
            .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.infoApi.isBootstrapped(
      const IsBootstrappedRequest(chain: "X").toRpc(),
    );

    expect(response.result?.isBootstrapped, true);
  });

  test("Peers Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(const RpcResponse(
            result: PeersResponse(numPeers: 3, peers: [
          Peer(
              ip: "206.189.137.87:9651",
              publicIp: "206.189.137.87:9651",
              nodeId: "NodeID-8PYXX47kqLDe2wD4oPbvRRchcnSzMA4J4",
              version: "avalanche/0.5.0",
              lastSent: "2020-06-01T15:23:02Z",
              lastReceived: "2020-06-01T15:22:57Z",
              benched: [],
              observedUptime: "99")
        ])).toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.infoApi.peers(
      const PeersRequest(nodeIDs: []).toRpc(),
    );

    expect(response.result?.numPeers, 3);
    expect(response.result?.peers.length, 1);
    expect(response.result?.peers.first.ip, "206.189.137.87:9651");
    expect(response.result?.peers.first.publicIp, "206.189.137.87:9651");
    expect(response.result?.peers.first.nodeId,
        "NodeID-8PYXX47kqLDe2wD4oPbvRRchcnSzMA4J4");
    expect(response.result?.peers.first.version, "avalanche/0.5.0");
    expect(response.result?.peers.first.lastSent, "2020-06-01T15:23:02Z");
    expect(response.result?.peers.first.lastReceived, "2020-06-01T15:22:57Z");
    expect(response.result?.peers.first.benched, []);
    expect(response.result?.peers.first.observedUptime, "99");
  });

  test("Get Tx Fee Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(const RpcResponse(
                result: GetTxFeeResponse(
                    creationTxFee: "10000000", txFee: "1000000"))
            .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.infoApi.getTxFee(
      const GetTxFeeRequest().toRpc(),
    );

    expect(response.result?.creationTxFee, "10000000");
    expect(response.result?.txFee, "1000000");
  });

  test("Uptime Success", () async {
    _server.enqueue(
        httpCode: 200,
        body: json.encode(const RpcResponse(
                result: UptimeResponse(
                    rewardingStakePercentage: "100.0000",
                    weightedAveragePercentage: "99.0000"))
            .toJson((value) => value.toJson())),
        headers: _headers);

    final response = await _roi.infoApi.uptime(
      const UptimeRequest().toRpc(),
    );

    expect(response.result?.rewardingStakePercentage, "100.0000");
    expect(response.result?.weightedAveragePercentage, "99.0000");
  });
}

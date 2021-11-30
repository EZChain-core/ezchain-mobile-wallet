import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'peers.g.dart';

@JsonSerializable()
class PeersRequest with RpcRequestWrapper<PeersRequest> {
  final List<String>? nodeIDs;

  const PeersRequest({this.nodeIDs});

  @override
  String method() {
    return "info.peers";
  }

  factory PeersRequest.fromJson(Map<String, dynamic> json) =>
      _$PeersRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PeersRequestToJson(this);
}

@JsonSerializable()
class PeersResponse {
  final int numPeers;
  final List<Peer> peers;

  const PeersResponse({required this.numPeers, required this.peers});

  factory PeersResponse.fromJson(Map<String, dynamic> json) =>
      _$PeersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PeersResponseToJson(this);
}

@JsonSerializable()
class Peer {
  final String ip;

  @JsonKey(name: "publicIP")
  final String publicIp;

  @JsonKey(name: "nodeID")
  final String nodeId;

  final String version;

  final String lastSent;

  final String lastReceived;

  final List<String> benched;

  final String observedUptime;

  const Peer(
      {required this.ip,
      required this.publicIp,
      required this.nodeId,
      required this.version,
      required this.lastSent,
      required this.lastReceived,
      required this.benched,
      required this.observedUptime});

  factory Peer.fromJson(Map<String, dynamic> json) => _$PeerFromJson(json);

  Map<String, dynamic> toJson() => _$PeerToJson(this);
}

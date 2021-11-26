import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'send_nft.g.dart';

@JsonSerializable()
class SendNFTRequest with RpcRequestWrapper<SendNFTRequest> {
  @JsonKey(name: "assetID")
  final String assetId;

  @JsonKey(name: "groupID")
  final String groupId;

  final String to;

  final List<String> from;

  @JsonKey(name: "changeAddr")
  final String changeAddress;

  final String username;

  final String password;

  const SendNFTRequest(
      {required this.assetId,
      required this.groupId,
      required this.to,
      required this.from,
      required this.changeAddress,
      required this.username,
      required this.password});

  @override
  String method() {
    return "avm.sendNFT";
  }

  factory SendNFTRequest.fromJson(Map<String, dynamic> json) =>
      _$SendNFTRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendNFTRequestToJson(this);
}

@JsonSerializable()
class SendNFTResponse {
  @JsonKey(name: "txID")
  final String txId;

  @JsonKey(name: "changeAddr")
  final String changeAddress;

  const SendNFTResponse({required this.txId, required this.changeAddress});

  factory SendNFTResponse.fromJson(Map<String, dynamic> json) =>
      _$SendNFTResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendNFTResponseToJson(this);
}

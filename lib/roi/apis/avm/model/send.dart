import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'send.g.dart';

@JsonSerializable()
class SendRequest with RpcRequestWrapper<SendRequest> {
  @JsonKey(name: "assetID")
  final String assetId;

  final int amount;

  final String to;

  final String memo;

  final List<String> from;

  @JsonKey(name: "changeAddr")
  final String changeAddress;

  final String username;

  final String password;

  const SendRequest(
      {required this.assetId,
      required this.amount,
      required this.to,
      required this.memo,
      required this.from,
      required this.changeAddress,
      required this.username,
      required this.password});

  @override
  String method() {
    return "avm.send";
  }

  factory SendRequest.fromJson(Map<String, dynamic> json) =>
      _$SendRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendRequestToJson(this);
}

@JsonSerializable()
class SendResponse {
  @JsonKey(name: "txID")
  final String txId;

  @JsonKey(name: "changeAddr")
  final String changeAddress;

  const SendResponse({required this.txId, required this.changeAddress});

  factory SendResponse.fromJson(Map<String, dynamic> json) =>
      _$SendResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendResponseToJson(this);
}

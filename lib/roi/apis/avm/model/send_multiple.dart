import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'send_multiple.g.dart';

@JsonSerializable()
class SendMultipleRequest with RpcRequestWrapper<SendMultipleRequest> {
  final List<Outputs> outputs;

  final String memo;

  final List<String> from;

  @JsonKey(name: "changeAddr")
  final String changeAddress;

  final String username;

  final String password;

  const SendMultipleRequest(
      {required this.outputs,
      required this.memo,
      required this.from,
      required this.changeAddress,
      required this.username,
      required this.password});

  @override
  String method() {
    return "avm.sendMultiple";
  }

  factory SendMultipleRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMultipleRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendMultipleRequestToJson(this);
}

@JsonSerializable()
class Outputs {
  @JsonKey(name: "assetID")
  final String assetId;

  final int amount;

  final String to;

  const Outputs(
      {required this.assetId, required this.amount, required this.to});

  factory Outputs.fromJson(Map<String, dynamic> json) =>
      _$OutputsFromJson(json);

  Map<String, dynamic> toJson() => _$OutputsToJson(this);
}

@JsonSerializable()
class SendMultipleResponse {
  @JsonKey(name: "txID")
  final String txId;

  @JsonKey(name: "changeAddr")
  final String changeAddress;

  const SendMultipleResponse({required this.txId, required this.changeAddress});

  factory SendMultipleResponse.fromJson(Map<String, dynamic> json) =>
      _$SendMultipleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendMultipleResponseToJson(this);
}

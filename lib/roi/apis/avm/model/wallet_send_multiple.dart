import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'wallet_send_multiple.g.dart';

@JsonSerializable()
class WalletSendMultipleRequest
    with RpcRequestWrapper<WalletSendMultipleRequest> {
  final List<Outputs> outputs;

  final String memo;

  final List<String> from;

  @JsonKey(name: "changeAddr")
  final String changeAddress;

  final String username;

  final String password;

  const WalletSendMultipleRequest(
      {required this.outputs,
      required this.memo,
      required this.from,
      required this.changeAddress,
      required this.username,
      required this.password});

  @override
  String method() {
    return "wallet.send";
  }

  factory WalletSendMultipleRequest.fromJson(Map<String, dynamic> json) =>
      _$WalletSendMultipleRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WalletSendMultipleRequestToJson(this);
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
class WalletSendMultipleResponse {
  @JsonKey(name: "txID")
  final String txId;

  @JsonKey(name: "changeAddr")
  final String changeAddress;

  const WalletSendMultipleResponse(
      {required this.txId, required this.changeAddress});

  factory WalletSendMultipleResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletSendMultipleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WalletSendMultipleResponseToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/ezc/sdk/common/rpc/rpc_request_wrapper.dart';

part 'issue_tx.g.dart';

@JsonSerializable()
class IssueTxRequest with RpcRequestWrapper<IssueTxRequest> {
  final String tx;

  final String encoding;

  const IssueTxRequest({required this.tx, this.encoding = "cb58"});

  @override
  String method() {
    return "ezc.issueTx";
  }

  factory IssueTxRequest.fromJson(Map<String, dynamic> json) =>
      _$IssueTxRequestFromJson(json);

  Map<String, dynamic> toJson() => _$IssueTxRequestToJson(this);
}

@JsonSerializable()
class IssueTxResponse {
  @JsonKey(name: "txID")
  final String txId;

  const IssueTxResponse({required this.txId});

  factory IssueTxResponse.fromJson(Map<String, dynamic> json) =>
      _$IssueTxResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IssueTxResponseToJson(this);
}

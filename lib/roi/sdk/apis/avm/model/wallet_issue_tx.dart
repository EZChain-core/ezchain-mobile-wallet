import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'wallet_issue_tx.g.dart';

@JsonSerializable()
class WalletIssueTxRequest with RpcRequestWrapper<WalletIssueTxRequest> {
  final String tx;

  final String encoding;

  const WalletIssueTxRequest({required this.tx, required this.encoding});

  @override
  String method() {
    return "wallet.issueTx";
  }

  factory WalletIssueTxRequest.fromJson(Map<String, dynamic> json) =>
      _$WalletIssueTxRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WalletIssueTxRequestToJson(this);
}

@JsonSerializable()
class WalletIssueTxResponse {
  @JsonKey(name: "txID")
  final String txId;

  const WalletIssueTxResponse({required this.txId});

  factory WalletIssueTxResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletIssueTxResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WalletIssueTxResponseToJson(this);
}

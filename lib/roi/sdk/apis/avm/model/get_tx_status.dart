import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_tx_status.g.dart';

@JsonSerializable()
class GetTxStatusRequest with RpcRequestWrapper<GetTxStatusRequest> {
  @JsonKey(name: "txID")
  final String txId;

  const GetTxStatusRequest({required this.txId});

  @override
  String method() {
    return "avm.getTxStatus";
  }

  factory GetTxStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$GetTxStatusRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetTxStatusRequestToJson(this);
}

@JsonSerializable()
class GetTxStatusResponse {
  final TxStatus status;
  final String? reason;

  const GetTxStatusResponse({required this.status, this.reason});

  factory GetTxStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$GetTxStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetTxStatusResponseToJson(this);
}

enum TxStatus {
  @JsonValue("Accepted")
  accepted,

  @JsonValue("Processing")
  processing,

  @JsonValue("Rejected")
  rejected,

  @JsonValue("Unknown")
  unknown,
}

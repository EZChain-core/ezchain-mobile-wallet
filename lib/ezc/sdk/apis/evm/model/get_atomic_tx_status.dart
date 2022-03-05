import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/ezc/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_atomic_tx_status.g.dart';

@JsonSerializable()
class GetAtomicTxStatusRequest
    with RpcRequestWrapper<GetAtomicTxStatusRequest> {
  @JsonKey(name: "txID")
  final String txId;

  const GetAtomicTxStatusRequest({required this.txId});

  @override
  String method() {
    return "ezc.getAtomicTxStatus";
  }

  factory GetAtomicTxStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$GetAtomicTxStatusRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetAtomicTxStatusRequestToJson(this);
}

@JsonSerializable()
class GetAtomicTxStatusResponse {
  final TxStatus status;
  final String? blockHeight;
  final String? reason;

  const GetAtomicTxStatusResponse({
    required this.status,
    this.blockHeight,
    this.reason,
  });

  factory GetAtomicTxStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAtomicTxStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAtomicTxStatusResponseToJson(this);
}

enum TxStatus {
  @JsonValue("Accepted")
  accepted,

  @JsonValue("Processing")
  processing,

  @JsonValue("Dropped")
  dropped,

  @JsonValue("Unknown")
  unknown,
}

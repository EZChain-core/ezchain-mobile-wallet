import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

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
  final String status;

  const GetTxStatusResponse({required this.status});

  factory GetTxStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$GetTxStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetTxStatusResponseToJson(this);
}

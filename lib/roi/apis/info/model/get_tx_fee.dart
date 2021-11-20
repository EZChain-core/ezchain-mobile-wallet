import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'get_tx_fee.g.dart';

@JsonSerializable()
class GetTxFeeRequest with RpcRequestWrapper<GetTxFeeRequest> {
  const GetTxFeeRequest();

  @override
  String method() {
    return "info.getTxFee";
  }

  factory GetTxFeeRequest.fromJson(Map<String, dynamic> json) =>
      _$GetTxFeeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetTxFeeRequestToJson(this);
}

@JsonSerializable()
class GetTxFeeResponse {
  final String creationTxFee;
  final String txFee;

  const GetTxFeeResponse({required this.creationTxFee, required this.txFee});

  factory GetTxFeeResponse.fromJson(Map<String, dynamic> json) =>
      _$GetTxFeeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetTxFeeResponseToJson(this);
}

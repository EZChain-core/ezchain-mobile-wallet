import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'export.g.dart';

@JsonSerializable()
class ExportRequest with RpcRequestWrapper<ExportRequest> {
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

  const ExportRequest(
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
    return "avm.export";
  }

  factory ExportRequest.fromJson(Map<String, dynamic> json) =>
      _$ExportRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ExportRequestToJson(this);
}

@JsonSerializable()
class ExportResponse {
  @JsonKey(name: "txID")
  final String txId;

  @JsonKey(name: "changeAddr")
  final String changeAddress;

  const ExportResponse({required this.txId, required this.changeAddress});

  factory ExportResponse.fromJson(Map<String, dynamic> json) =>
      _$ExportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExportResponseToJson(this);
}

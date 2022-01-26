import 'package:json_annotation/json_annotation.dart';

part 'types.g.dart';

@JsonSerializable()
class GetCChainExplorerTxsResponse {
  final String message;
  final List<CChainExplorerTx> result;
  final String status;

  GetCChainExplorerTxsResponse({
    required this.message,
    required this.result,
    required this.status,
  });

  factory GetCChainExplorerTxsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCChainExplorerTxsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetCChainExplorerTxsResponseToJson(this);
}

@JsonSerializable()
class CChainExplorerTx {
  final String? blockHash;
  final String blockNumber;
  final String confirmations;
  final String contractAddress;
  final String cumulativeGasUsed;
  final String from;
  final String gas;
  final String gasPrice;
  final String gasUsed;
  final String hash;
  final String input;
  final String isError;
  final String nonce;
  final String timeStamp;
  final String to;
  final String transactionIndex;

  @JsonKey(name: "txreceipt_status")
  final CChainExplorerTxReceiptStatus txReceiptStatus;

  final String value;

  CChainExplorerTx({
    required this.blockHash,
    required this.blockNumber,
    required this.confirmations,
    required this.contractAddress,
    required this.cumulativeGasUsed,
    required this.from,
    required this.gas,
    required this.gasPrice,
    required this.gasUsed,
    required this.hash,
    required this.input,
    required this.isError,
    required this.nonce,
    required this.timeStamp,
    required this.to,
    required this.transactionIndex,
    required this.txReceiptStatus,
    required this.value,
  });

  factory CChainExplorerTx.fromJson(Map<String, dynamic> json) =>
      _$CChainExplorerTxFromJson(json);

  Map<String, dynamic> toJson() => _$CChainExplorerTxToJson(this);
}

enum CChainExplorerTxReceiptStatus {
  @JsonValue("0")
  error,

  @JsonValue("1")
  ok,
}

@JsonSerializable()
class GetCChainExplorerTxInfoResponse {
  final String message;
  final CChainExplorerTxInfo result;
  final String status;

  GetCChainExplorerTxInfoResponse({
    required this.message,
    required this.result,
    required this.status,
  });

  factory GetCChainExplorerTxInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCChainExplorerTxInfoResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetCChainExplorerTxInfoResponseToJson(this);
}

@JsonSerializable()
class CChainExplorerTxInfo {
  final String revertReason;
  final String blockNumber;
  final String confirmations;
  final String from;
  final String gasLimit;
  final String gasPrice;
  final String gasUsed;
  final String hash;
  final String input;
  final bool success;
  @JsonKey(name: "timeStamp")
  final String timestamp;
  final String to;
  final String value;

  CChainExplorerTxInfo({
    required this.revertReason,
    required this.blockNumber,
    required this.confirmations,
    required this.from,
    required this.gasLimit,
    required this.gasPrice,
    required this.gasUsed,
    required this.hash,
    required this.input,
    required this.success,
    required this.timestamp,
    required this.to,
    required this.value,
  });

  factory CChainExplorerTxInfo.fromJson(Map<String, dynamic> json) =>
      _$CChainExplorerTxInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CChainExplorerTxInfoToJson(this);
}

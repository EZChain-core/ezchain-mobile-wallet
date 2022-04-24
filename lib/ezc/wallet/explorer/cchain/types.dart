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

  BigInt get valueBN => BigInt.tryParse(value) ?? BigInt.zero;

  BigInt get gasPriceBN => BigInt.tryParse(gasPrice) ?? BigInt.zero;

  BigInt get gasUsedBN => BigInt.tryParse(gasUsed) ?? BigInt.zero;

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

  BigInt get valueBN => BigInt.tryParse(value) ?? BigInt.zero;

  BigInt get gasPriceBN => BigInt.tryParse(gasPrice) ?? BigInt.zero;

  BigInt get gasUsedBN => BigInt.tryParse(gasUsed) ?? BigInt.zero;

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

@JsonSerializable()
class CChainErc20Tx {
  final String blockNumber;
  final String timeStamp;
  final String hash;
  final String nonce;
  final String blockHash;
  final String from;
  final String contractAddress;
  final String to;
  final String value;
  final String tokenName;
  final String tokenSymbol;
  final String tokenDecimal;
  final String transactionIndex;
  final String gas;
  final String gasPrice;
  final String gasUsed;
  final String cumulativeGasUsed;
  final String input;
  final String confirmations;
  final bool? success;

  BigInt get valueBN => BigInt.tryParse(value) ?? BigInt.zero;

  BigInt get gasPriceBN => BigInt.tryParse(gasPrice) ?? BigInt.zero;

  BigInt get gasUsedBN => BigInt.tryParse(gasUsed) ?? BigInt.zero;

  CChainErc20Tx(
    this.blockNumber,
    this.timeStamp,
    this.hash,
    this.nonce,
    this.blockHash,
    this.from,
    this.contractAddress,
    this.to,
    this.value,
    this.tokenName,
    this.tokenSymbol,
    this.tokenDecimal,
    this.transactionIndex,
    this.gas,
    this.gasPrice,
    this.gasUsed,
    this.cumulativeGasUsed,
    this.input,
    this.confirmations,
    this.success,
  );

  factory CChainErc20Tx.fromJson(Map<String, dynamic> json) =>
      _$CChainErc20TxFromJson(json);

  Map<String, dynamic> toJson() => _$CChainErc20TxToJson(this);
}

@JsonSerializable()
class GetErc20TransactionsResponse {
  String? status;
  String? message;
  List<CChainErc20Tx> result;

  GetErc20TransactionsResponse(this.status, this.message, this.result);

  factory GetErc20TransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetErc20TransactionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetErc20TransactionsResponseToJson(this);
}

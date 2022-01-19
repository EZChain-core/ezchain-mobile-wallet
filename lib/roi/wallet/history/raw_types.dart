import 'package:json_annotation/json_annotation.dart';

part 'raw_types.g.dart';

@JsonSerializable()
class GetTransactionsResponse {
  final String startTime;

  final String endTime;

  final List<Transaction> transactions;

  final String? next;

  GetTransactionsResponse(
    this.startTime,
    this.endTime,
    this.transactions,
    this.next,
  );

  factory GetTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetTransactionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetTransactionsResponseToJson(this);
}

@JsonSerializable()
class GetTransactionsRequest {
  final List<String> addresses;

  final List<String> sort;

  final List<String> disableCount;

  @JsonKey(name: "chainID")
  final List<String> chainId;

  final List<String> disableGenesis;

  final List<String>? limit;

  final List<String>? endTime;

  GetTransactionsRequest(
    this.addresses,
    this.sort,
    this.disableCount,
    this.chainId,
    this.disableGenesis,
    this.limit,
    this.endTime,
  );

  factory GetTransactionsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetTransactionsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetTransactionsRequestToJson(this);
}

@JsonSerializable()
class Transaction {
  final String id;

  @JsonKey(name: "chainID")
  final String chainId;

  final TransactionType type;

  final List<TransactionInput>? inputs;

  final List<TransactionOutput>? outputs;

  final String? memo;

  final Map<String, String> inputTotals;

  final Map<String, String> outputTotals;

  final String? reusedAddressTotals;

  final String? timestamp;

  final int txFee;

  final bool genesis;

  final int validatorStart;

  final int validatorEnd;

  @JsonKey(name: "validatorNodeID")
  final String validatorNodeId;

  final bool rewarded;

  Transaction(
    this.id,
    this.chainId,
    this.type,
    this.inputs,
    this.outputs,
    this.memo,
    this.inputTotals,
    this.outputTotals,
    this.reusedAddressTotals,
    this.timestamp,
    this.txFee,
    this.genesis,
    this.validatorStart,
    this.validatorEnd,
    this.validatorNodeId,
    this.rewarded,
  );

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class TransactionInput {
  final List<TransactionCredential>? credentials;

  final TransactionOutput output;

  TransactionInput(this.credentials, this.output);

  factory TransactionInput.fromJson(Map<String, dynamic> json) =>
      _$TransactionInputFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionInputToJson(this);
}

@JsonSerializable()
class TransactionCredential {
  final String address;

  @JsonKey(name: "public_key")
  final String publicKey;

  final String signature;

  TransactionCredential(
    this.address,
    this.publicKey,
    this.signature,
  );

  factory TransactionCredential.fromJson(Map<String, dynamic> json) =>
      _$TransactionCredentialFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionCredentialToJson(this);
}

@JsonSerializable()
class TransactionOutput {
  final String id;

  @JsonKey(name: "transactionID")
  final String transactionId;

  final String amount;

  @JsonKey(name: "assetID")
  final String assetId;

  @JsonKey(name: "chainID")
  final String chainId;

  @JsonKey(name: "groupID")
  final int groupId;

  final int outputType;

  final int outputIndex;

  @JsonKey(name: "locktime")
  final int lockTime;

  final int threshold;

  final List<String>? addresses;

  @JsonKey(name: "caddresses")
  final List<String>? cAddresses;

  final String timestamp;

  final String? payload;

  @JsonKey(name: "inChainID")
  final String inChainId;

  @JsonKey(name: "outChainID")
  final String outChainId;

  final bool? stake;

  final bool rewardUtxo;

  @JsonKey(name: "redeemingTransactionID")
  final String redeemingTransactionId;

  final int nonce;

  TransactionOutput(
    this.id,
    this.transactionId,
    this.amount,
    this.assetId,
    this.chainId,
    this.groupId,
    this.outputType,
    this.outputIndex,
    this.lockTime,
    this.threshold,
    this.addresses,
    this.cAddresses,
    this.timestamp,
    this.payload,
    this.inChainId,
    this.outChainId,
    this.stake,
    this.rewardUtxo,
    this.redeemingTransactionId,
    this.nonce,
  );

  factory TransactionOutput.fromJson(Map<String, dynamic> json) =>
      _$TransactionOutputFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionOutputToJson(this);
}

enum TransactionType {
  @JsonValue("base")
  base,

  @JsonValue("create_asset")
  createAsset,

  @JsonValue("operation")
  operation,

  @JsonValue("import")
  import,

  @JsonValue("export")
  export,

  @JsonValue("add_validator")
  addValidator,

  @JsonValue("add_subnet_validator")
  addSubnetValidator,

  @JsonValue("add_delegator")
  addDelegator,

  @JsonValue("create_chain")
  createChain,

  @JsonValue("create_subnet")
  createSubnet,

  @JsonValue("pvm_import")
  pvmImport,

  @JsonValue("pvm_export")
  pvmExport,

  @JsonValue("atomic_import_tx")
  atomicImportTx,

  @JsonValue("atomic_export_tx")
  atomicExportTx,

  @JsonValue("advance_time")
  advanceTime,

  @JsonValue("reward_validator")
  rewardValidator,
}

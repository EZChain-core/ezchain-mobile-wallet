import 'package:json_annotation/json_annotation.dart';

part 'types.g.dart';

@JsonSerializable()
class GetOrteliusTxsResponse {
  final String startTime;

  final String endTime;

  final List<OrteliusTx> transactions;

  final String? next;

  GetOrteliusTxsResponse(
    this.startTime,
    this.endTime,
    this.transactions,
    this.next,
  );

  factory GetOrteliusTxsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetOrteliusTxsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetOrteliusTxsResponseToJson(this);
}

@JsonSerializable()
class GetOrteliusTxsRequest {
  final List<String> addresses;

  final List<String> sort;

  final List<String> disableCount;

  @JsonKey(name: "chainID")
  final List<String> chainId;

  final List<String> disableGenesis;

  final List<String>? limit;

  final List<String>? endTime;

  GetOrteliusTxsRequest(
    this.addresses,
    this.sort,
    this.disableCount,
    this.chainId,
    this.disableGenesis,
    this.limit,
    this.endTime,
  );

  factory GetOrteliusTxsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetOrteliusTxsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetOrteliusTxsRequestToJson(this);
}

@JsonSerializable()
class OrteliusTx {
  final String id;

  @JsonKey(name: "chainID")
  final String chainId;

  final OrteliusTxType type;

  final List<OrteliusTxInput>? inputs;

  final List<OrteliusTxOutput>? outputs;

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

  final String? txBlockId;

  OrteliusTx(
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
    this.txBlockId,
  );

  factory OrteliusTx.fromJson(Map<String, dynamic> json) =>
      _$OrteliusTxFromJson(json);

  Map<String, dynamic> toJson() => _$OrteliusTxToJson(this);
}

@JsonSerializable()
class OrteliusTxInput {
  final List<OrteliusTxCredential>? credentials;

  final OrteliusTxOutput output;

  OrteliusTxInput(this.credentials, this.output);

  factory OrteliusTxInput.fromJson(Map<String, dynamic> json) =>
      _$OrteliusTxInputFromJson(json);

  Map<String, dynamic> toJson() => _$OrteliusTxInputToJson(this);
}

@JsonSerializable()
class OrteliusTxCredential {
  final String address;

  @JsonKey(name: "public_key")
  final String publicKey;

  final String signature;

  OrteliusTxCredential(
    this.address,
    this.publicKey,
    this.signature,
  );

  factory OrteliusTxCredential.fromJson(Map<String, dynamic> json) =>
      _$OrteliusTxCredentialFromJson(json);

  Map<String, dynamic> toJson() => _$OrteliusTxCredentialToJson(this);
}

@JsonSerializable()
class OrteliusTxOutput {
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

  @JsonKey(name: "stakeLocktime")
  final int? stakeLockTime;

  OrteliusTxOutput(
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
    this.stakeLockTime,
  );

  factory OrteliusTxOutput.fromJson(Map<String, dynamic> json) =>
      _$OrteliusTxOutputFromJson(json);

  Map<String, dynamic> toJson() => _$OrteliusTxOutputToJson(this);
}

enum OrteliusTxType {
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

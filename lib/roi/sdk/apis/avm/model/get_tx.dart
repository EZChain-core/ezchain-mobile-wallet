import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_tx.g.dart';

@JsonSerializable()
class GetTxRequest with RpcRequestWrapper<GetTxRequest> {
  final String tx;

  final String encoding;

  const GetTxRequest({required this.tx, required this.encoding});

  @override
  String method() {
    return "avm.getTx";
  }

  factory GetTxRequest.fromJson(Map<String, dynamic> json) =>
      _$GetTxRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetTxRequestToJson(this);
}

@JsonSerializable()
class GetTxResponse {
  final Transaction tx;
  final String encoding;

  const GetTxResponse({required this.tx, required this.encoding});

  factory GetTxResponse.fromJson(Map<String, dynamic> json) =>
      _$GetTxResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetTxResponseToJson(this);
}

@JsonSerializable()
class Transaction {
  final UnsignedTransaction unsignedTx;
  final List<Credentials> credentials;

  const Transaction({required this.unsignedTx, required this.credentials});

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class UnsignedTransaction {
  @JsonKey(name: "networkID")
  final int networkId;

  @JsonKey(name: "blockchainID")
  final String blockchainId;

  final List<Outputs> outputs;

  final String memo;

  final String sourceChain;

  final List<ImportedInputs> importedInputs;

  UnsignedTransaction(
      {required this.networkId,
      required this.blockchainId,
      required this.outputs,
      required this.memo,
      required this.sourceChain,
      required this.importedInputs});

  factory UnsignedTransaction.fromJson(Map<String, dynamic> json) =>
      _$UnsignedTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$UnsignedTransactionToJson(this);
}

@JsonSerializable()
class Outputs {
  @JsonKey(name: "assetID")
  final String assetId;

  @JsonKey(name: "fxID")
  final String fxId;

  final Output output;

  Outputs({required this.assetId, required this.fxId, required this.output});

  factory Outputs.fromJson(Map<String, dynamic> json) =>
      _$OutputsFromJson(json);

  Map<String, dynamic> toJson() => _$OutputsToJson(this);
}

@JsonSerializable()
class Output {
  final List<String> addresses;

  final int amount;

  final int locktime;

  final int threshold;

  Output(
      {required this.addresses,
      required this.amount,
      required this.locktime,
      required this.threshold});

  factory Output.fromJson(Map<String, dynamic> json) => _$OutputFromJson(json);

  Map<String, dynamic> toJson() => _$OutputToJson(this);
}

@JsonSerializable()
class ImportedInputs {
  @JsonKey(name: "txID")
  final String txId;

  final int outputIndex;

  @JsonKey(name: "assetID")
  final String assetId;

  @JsonKey(name: "fxID")
  final String fxId;

  final ImportedInput input;

  ImportedInputs(
      {required this.txId,
      required this.outputIndex,
      required this.assetId,
      required this.fxId,
      required this.input});

  factory ImportedInputs.fromJson(Map<String, dynamic> json) =>
      _$ImportedInputsFromJson(json);

  Map<String, dynamic> toJson() => _$ImportedInputsToJson(this);
}

@JsonSerializable()
class ImportedInput {
  final int amount;

  final List<int> signatureIndices;

  const ImportedInput({required this.amount, required this.signatureIndices});

  factory ImportedInput.fromJson(Map<String, dynamic> json) =>
      _$ImportedInputFromJson(json);

  Map<String, dynamic> toJson() => _$ImportedInputToJson(this);
}

@JsonSerializable()
class Credentials {
  @JsonKey(name: "fxID")
  final String fxId;

  final Credential credential;

  const Credentials({required this.fxId, required this.credential});

  factory Credentials.fromJson(Map<String, dynamic> json) =>
      _$CredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$CredentialsToJson(this);
}

@JsonSerializable()
class Credential {
  final List<String> signatures;

  const Credential({required this.signatures});

  factory Credential.fromJson(Map<String, dynamic> json) =>
      _$CredentialFromJson(json);

  Map<String, dynamic> toJson() => _$CredentialToJson(this);
}

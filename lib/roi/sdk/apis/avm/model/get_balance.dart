import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_balance.g.dart';

@JsonSerializable()
class GetBalanceRequest with RpcRequestWrapper<GetBalanceRequest> {
  final String address;

  @JsonKey(name: "assetID")
  final String assetId;

  const GetBalanceRequest({required this.address, required this.assetId});

  @override
  String method() {
    return "avm.getBalance";
  }

  factory GetBalanceRequest.fromJson(Map<String, dynamic> json) =>
      _$GetBalanceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetBalanceRequestToJson(this);
}

@JsonSerializable()
class GetBalanceResponse {
  final String balance;

  @JsonKey(name: "utxoIDs")
  final List<UTXOId> utxoIds;

  const GetBalanceResponse({required this.balance, required this.utxoIds});

  factory GetBalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$GetBalanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetBalanceResponseToJson(this);
}

@JsonSerializable()
class UTXOId {
  @JsonKey(name: "txID")
  final String txId;

  final int outputIndex;

  const UTXOId({required this.txId, required this.outputIndex});

  factory UTXOId.fromJson(Map<String, dynamic> json) => _$UTXOIdFromJson(json);

  Map<String, dynamic> toJson() => _$UTXOIdToJson(this);
}

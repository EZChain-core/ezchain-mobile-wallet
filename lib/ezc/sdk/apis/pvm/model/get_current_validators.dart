import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/ezc/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_current_validators.g.dart';

@JsonSerializable()
class GetCurrentValidatorsRequest
    with RpcRequestWrapper<GetCurrentValidatorsRequest> {
  @JsonKey(name: "subnetID")
  final String? subnetId;

  @JsonKey(name: "nodeIDs")
  final List<String>? nodeIds;

  GetCurrentValidatorsRequest({
    this.subnetId,
    this.nodeIds,
  });

  @override
  String method() {
    return "platform.getCurrentValidators";
  }

  factory GetCurrentValidatorsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetCurrentValidatorsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetCurrentValidatorsRequestToJson(this);
}

@JsonSerializable()
class GetCurrentValidatorsResponse {
  final List<Validator> validators;

  GetCurrentValidatorsResponse({
    required this.validators,
  });

  factory GetCurrentValidatorsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCurrentValidatorsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetCurrentValidatorsResponseToJson(this);
}

@JsonSerializable()
class Validator {
  @JsonKey(name: "txID")
  final String txId;

  final String startTime;

  final String endTime;

  final String? stakeAmount;

  @JsonKey(name: "nodeID")
  final String nodeId;

  final String? weight;

  final ValidatorRewardOwner? rewardOwner;

  final String? potentialReward;

  final String delegationFee;

  final String uptime;

  final bool connected;

  final List<Delegator>? delegators;

  BigInt get stakeAmountBN =>
      BigInt.tryParse(stakeAmount ?? "0") ?? BigInt.zero;

  BigInt get potentialRewardBN =>
      BigInt.tryParse(potentialReward ?? "0") ?? BigInt.zero;

  Decimal get delegationFeeDecimal =>
      Decimal.tryParse(delegationFee) ?? Decimal.zero;

  Validator({
    required this.txId,
    required this.startTime,
    required this.endTime,
    this.stakeAmount,
    required this.nodeId,
    this.weight,
    this.rewardOwner,
    this.potentialReward,
    required this.delegationFee,
    required this.uptime,
    required this.connected,
    this.delegators,
  });

  factory Validator.fromJson(Map<String, dynamic> json) =>
      _$ValidatorFromJson(json);

  Map<String, dynamic> toJson() => _$ValidatorToJson(this);
}

@JsonSerializable()
class ValidatorRewardOwner {
  @JsonKey(name: "locktime")
  final String lockTime;

  final String threshold;

  final List<String> addresses;

  ValidatorRewardOwner({
    required this.lockTime,
    required this.threshold,
    required this.addresses,
  });

  factory ValidatorRewardOwner.fromJson(Map<String, dynamic> json) =>
      _$ValidatorRewardOwnerFromJson(json);

  Map<String, dynamic> toJson() => _$ValidatorRewardOwnerToJson(this);
}

@JsonSerializable()
class Delegator {
  @JsonKey(name: "txID")
  final String txId;

  final String startTime;

  final String endTime;

  final String? stakeAmount;

  @JsonKey(name: "nodeID")
  final String nodeId;

  final ValidatorRewardOwner? rewardOwner;

  final String? potentialReward;

  BigInt get stakeAmountBN =>
      BigInt.tryParse(stakeAmount ?? "0") ?? BigInt.zero;

  BigInt get potentialRewardBN =>
      BigInt.tryParse(potentialReward ?? "0") ?? BigInt.zero;

  Delegator({
    required this.txId,
    required this.startTime,
    required this.endTime,
    this.stakeAmount,
    required this.nodeId,
    this.rewardOwner,
    this.potentialReward,
  });

  factory Delegator.fromJson(Map<String, dynamic> json) =>
      _$DelegatorFromJson(json);

  Map<String, dynamic> toJson() => _$DelegatorToJson(this);
}

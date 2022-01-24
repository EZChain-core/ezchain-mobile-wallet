import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

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

  final ValidatorRewardOwner rewardOwner;

  final String potentialReward;

  final String delegationFee;

  final String uptime;

  final bool connected;

  final List<ValidatorDelegator>? delegators;

  Validator({
    required this.txId,
    required this.startTime,
    required this.endTime,
    this.stakeAmount,
    required this.nodeId,
    this.weight,
    required this.rewardOwner,
    required this.potentialReward,
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
class ValidatorDelegator {
  @JsonKey(name: "txID")
  final String txId;

  final String startTime;

  final String endTime;

  final String? stakeAmount;

  @JsonKey(name: "nodeID")
  final String nodeId;

  final ValidatorRewardOwner rewardOwner;

  final String potentialReward;

  ValidatorDelegator({
    required this.txId,
    required this.startTime,
    required this.endTime,
    this.stakeAmount,
    required this.nodeId,
    required this.rewardOwner,
    required this.potentialReward,
  });

  factory ValidatorDelegator.fromJson(Map<String, dynamic> json) =>
      _$ValidatorDelegatorFromJson(json);

  Map<String, dynamic> toJson() => _$ValidatorDelegatorToJson(this);
}

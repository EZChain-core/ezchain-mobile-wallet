import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/ezc/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_min_stake.g.dart';

@JsonSerializable()
class GetMinStakeRequest with RpcRequestWrapper<GetMinStakeRequest> {
  GetMinStakeRequest();

  @override
  String method() {
    return "platform.getMinStake";
  }

  factory GetMinStakeRequest.fromJson(Map<String, dynamic> json) =>
      _$GetMinStakeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetMinStakeRequestToJson(this);
}

@JsonSerializable()
class GetMinStakeResponse {
  final String minValidatorStake;
  final String minDelegatorStake;

  BigInt get minValidatorStakeBN =>
      BigInt.tryParse(minValidatorStake) ?? BigInt.zero;

  BigInt get minDelegatorStakeBN =>
      BigInt.tryParse(minDelegatorStake) ?? BigInt.zero;

  GetMinStakeResponse(
      {required this.minValidatorStake, required this.minDelegatorStake});

  factory GetMinStakeResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMinStakeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetMinStakeResponseToJson(this);
}

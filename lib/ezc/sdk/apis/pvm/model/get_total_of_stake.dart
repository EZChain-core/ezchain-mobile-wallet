import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/ezc/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_total_of_stake.g.dart';

@JsonSerializable()
class GetTotalOfStakeRequest with RpcRequestWrapper<GetTotalOfStakeRequest> {
  GetTotalOfStakeRequest();

  @override
  String method() {
    return "platform.getTotalOfStake";
  }

  factory GetTotalOfStakeRequest.fromJson(Map<String, dynamic> json) =>
      _$GetTotalOfStakeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetTotalOfStakeRequestToJson(this);
}

@JsonSerializable()
class GetTotalOfStakeResponse {
  final String totalStake;

  BigInt get totalStakeBN => BigInt.tryParse(totalStake) ?? BigInt.zero;

  GetTotalOfStakeResponse({required this.totalStake});

  factory GetTotalOfStakeResponse.fromJson(Map<String, dynamic> json) =>
      _$GetTotalOfStakeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetTotalOfStakeResponseToJson(this);
}

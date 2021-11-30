import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'uptime.g.dart';

@JsonSerializable()
class UptimeRequest with RpcRequestWrapper<UptimeRequest> {
  const UptimeRequest();

  @override
  String method() {
    return "info.uptime";
  }

  factory UptimeRequest.fromJson(Map<String, dynamic> json) =>
      _$UptimeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UptimeRequestToJson(this);
}

@JsonSerializable()
class UptimeResponse {
  final String rewardingStakePercentage;
  final String weightedAveragePercentage;

  const UptimeResponse(
      {required this.rewardingStakePercentage,
      required this.weightedAveragePercentage});

  factory UptimeResponse.fromJson(Map<String, dynamic> json) =>
      _$UptimeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UptimeResponseToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/ezc/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_pending_validators.g.dart';

@JsonSerializable()
class GetPendingValidatorsRequest
    with RpcRequestWrapper<GetPendingValidatorsRequest> {
  @JsonKey(name: "subnetID")
  final String? subnetId;

  @JsonKey(name: "nodeIDs")
  final List<String>? nodeIds;

  GetPendingValidatorsRequest({
    this.subnetId,
    this.nodeIds,
  });

  @override
  String method() {
    return "platform.getPendingValidators";
  }

  factory GetPendingValidatorsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetPendingValidatorsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetPendingValidatorsRequestToJson(this);
}

@JsonSerializable()
class GetPendingValidatorsResponse {
  final List<Validator> validators;
  final List<Delegator> delegators;

  GetPendingValidatorsResponse({
    required this.validators,
    required this.delegators,
  });

  factory GetPendingValidatorsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPendingValidatorsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetPendingValidatorsResponseToJson(this);
}

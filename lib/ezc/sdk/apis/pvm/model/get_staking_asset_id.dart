import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/ezc/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_staking_asset_id.g.dart';

@JsonSerializable()
class GetStakingAssetIdRequest
    with RpcRequestWrapper<GetStakingAssetIdRequest> {
  @JsonKey(name: "subnetID")
  final String? subnetId;

  GetStakingAssetIdRequest({this.subnetId});

  @override
  String method() {
    return "platform.getStakingAssetID";
  }

  factory GetStakingAssetIdRequest.fromJson(Map<String, dynamic> json) =>
      _$GetStakingAssetIdRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetStakingAssetIdRequestToJson(this);
}

@JsonSerializable()
class GetStakingAssetIdResponse {
  @JsonKey(name: "assetID")
  final String assetId;

  GetStakingAssetIdResponse({required this.assetId});

  factory GetStakingAssetIdResponse.fromJson(Map<String, dynamic> json) =>
      _$GetStakingAssetIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetStakingAssetIdResponseToJson(this);
}

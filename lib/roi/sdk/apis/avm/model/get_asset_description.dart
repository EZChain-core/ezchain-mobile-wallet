import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_asset_description.g.dart';

@JsonSerializable()
class GetAssetDescriptionRequest
    with RpcRequestWrapper<GetAssetDescriptionRequest> {
  @JsonKey(name: "assetID")
  final String assetId;

  const GetAssetDescriptionRequest({required this.assetId});

  @override
  String method() {
    return "avm.getAssetDescription";
  }

  factory GetAssetDescriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$GetAssetDescriptionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetAssetDescriptionRequestToJson(this);
}

@JsonSerializable()
class GetAssetDescriptionResponse {
  @JsonKey(name: "assetID")
  final String assetId;
  final String name;
  final String symbol;
  final String denomination;

  const GetAssetDescriptionResponse(
      {required this.assetId,
      required this.name,
      required this.symbol,
      required this.denomination});

  factory GetAssetDescriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAssetDescriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAssetDescriptionResponseToJson(this);
}

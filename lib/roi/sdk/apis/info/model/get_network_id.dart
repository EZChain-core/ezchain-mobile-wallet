import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_network_id.g.dart';

@JsonSerializable()
class GetNetworkIdRequest with RpcRequestWrapper<GetNetworkIdRequest> {
  const GetNetworkIdRequest();

  @override
  String method() {
    return "info.getNetworkID";
  }

  factory GetNetworkIdRequest.fromJson(Map<String, dynamic> json) =>
      _$GetNetworkIdRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetNetworkIdRequestToJson(this);
}

@JsonSerializable()
class GetNetworkIdResponse {
  @JsonKey(name: "networkID")
  final String networkId;

  const GetNetworkIdResponse({required this.networkId});

  factory GetNetworkIdResponse.fromJson(Map<String, dynamic> json) =>
      _$GetNetworkIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetNetworkIdResponseToJson(this);
}

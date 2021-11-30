import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_network_name.g.dart';

@JsonSerializable()
class GetNetworkNameRequest with RpcRequestWrapper<GetNetworkNameRequest> {
  const GetNetworkNameRequest();

  @override
  String method() {
    return "info.getNetworkName";
  }

  factory GetNetworkNameRequest.fromJson(Map<String, dynamic> json) =>
      _$GetNetworkNameRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetNetworkNameRequestToJson(this);
}

@JsonSerializable()
class GetNetworkNameResponse {
  final String networkName;

  const GetNetworkNameResponse({required this.networkName});

  factory GetNetworkNameResponse.fromJson(Map<String, dynamic> json) =>
      _$GetNetworkNameResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetNetworkNameResponseToJson(this);
}

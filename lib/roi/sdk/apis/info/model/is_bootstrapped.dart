import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'is_bootstrapped.g.dart';

@JsonSerializable()
class IsBootstrappedRequest with RpcRequestWrapper<IsBootstrappedRequest> {
  final String chain;

  const IsBootstrappedRequest({required this.chain});

  @override
  String method() {
    return "info.isBootstrapped";
  }

  factory IsBootstrappedRequest.fromJson(Map<String, dynamic> json) =>
      _$IsBootstrappedRequestFromJson(json);

  Map<String, dynamic> toJson() => _$IsBootstrappedRequestToJson(this);
}

@JsonSerializable()
class IsBootstrappedResponse {
  final bool isBootstrapped;

  const IsBootstrappedResponse({required this.isBootstrapped});

  factory IsBootstrappedResponse.fromJson(Map<String, dynamic> json) =>
      _$IsBootstrappedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IsBootstrappedResponseToJson(this);
}

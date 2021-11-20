import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'get_blockchain_id.g.dart';

@JsonSerializable()
class GetBlockchainIdRequest with RpcRequestWrapper<GetBlockchainIdRequest> {
  final String alias;

  const GetBlockchainIdRequest({required this.alias});

  @override
  String method() {
    return "info.getBlockchainID";
  }

  factory GetBlockchainIdRequest.fromJson(Map<String, dynamic> json) =>
      _$GetBlockchainIdRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetBlockchainIdRequestToJson(this);
}

@JsonSerializable()
class GetBlockchainIdResponse {
  @JsonKey(name: "blockchainID")
  final String blockchainId;

  const GetBlockchainIdResponse({required this.blockchainId});

  factory GetBlockchainIdResponse.fromJson(Map<String, dynamic> json) =>
      _$GetBlockchainIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetBlockchainIdResponseToJson(this);
}

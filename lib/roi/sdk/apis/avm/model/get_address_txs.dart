import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_address_txs.g.dart';

@JsonSerializable()
class GetAddressTxsRequest with RpcRequestWrapper<GetAddressTxsRequest> {
  final String address;

  @JsonKey(name: "assetID")
  final String assetId;

  final String pageSize;

  const GetAddressTxsRequest(
      {required this.address, required this.assetId, required this.pageSize});

  @override
  String method() {
    return "avm.getAddressTxs";
  }

  factory GetAddressTxsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetAddressTxsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetAddressTxsRequestToJson(this);
}

@JsonSerializable()
class GetAddressTxsResponse {
  @JsonKey(name: "txIDs")
  final List<String> txIds;

  final String cursor;

  const GetAddressTxsResponse({required this.txIds, required this.cursor});

  factory GetAddressTxsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAddressTxsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAddressTxsResponseToJson(this);
}

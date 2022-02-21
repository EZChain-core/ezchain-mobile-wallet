import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request_wrapper.dart';

part 'get_current_supply.g.dart';

@JsonSerializable()
class GetCurrentSupplyRequest with RpcRequestWrapper<GetCurrentSupplyRequest> {
  GetCurrentSupplyRequest();

  @override
  String method() {
    return "platform.getCurrentSupply";
  }

  factory GetCurrentSupplyRequest.fromJson(Map<String, dynamic> json) =>
      _$GetCurrentSupplyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetCurrentSupplyRequestToJson(this);
}

@JsonSerializable()
class GetCurrentSupplyResponse {
  final String supply;

  BigInt get supplyBN => BigInt.tryParse(supply) ?? BigInt.zero;

  GetCurrentSupplyResponse({required this.supply});

  factory GetCurrentSupplyResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCurrentSupplyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetCurrentSupplyResponseToJson(this);
}

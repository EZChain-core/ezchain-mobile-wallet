import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'get_all_balances.g.dart';

@JsonSerializable()
class GetAllBalancesRequest with RpcRequestWrapper<GetAllBalancesRequest> {
  final String address;

  const GetAllBalancesRequest({required this.address});

  @override
  String method() {
    return "avm.getAllBalances";
  }

  factory GetAllBalancesRequest.fromJson(Map<String, dynamic> json) =>
      _$GetAllBalancesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllBalancesRequestToJson(this);
}

@JsonSerializable()
class GetAllBalancesResponse {
  final List<Balance> balances;

  const GetAllBalancesResponse({required this.balances});

  factory GetAllBalancesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllBalancesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllBalancesResponseToJson(this);
}

@JsonSerializable()
class Balance {
  final String asset;

  final String balance;

  const Balance({required this.asset, required this.balance});

  factory Balance.fromJson(Map<String, dynamic> json) =>
      _$BalanceFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceToJson(this);
}

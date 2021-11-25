import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'list_address.g.dart';

@JsonSerializable()
class ListAddressRequest with RpcRequestWrapper<ListAddressRequest> {
  final String username;

  final String password;

  const ListAddressRequest({required this.username, required this.password});

  @override
  String method() {
    return "avm.listAddress";
  }

  factory ListAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$ListAddressRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListAddressRequestToJson(this);
}

@JsonSerializable()
class ListAddressResponse {
  final List<String> addresses;

  const ListAddressResponse({required this.addresses});

  factory ListAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$ListAddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListAddressResponseToJson(this);
}

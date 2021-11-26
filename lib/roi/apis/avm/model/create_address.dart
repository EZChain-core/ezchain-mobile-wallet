import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'create_address.g.dart';

@JsonSerializable()
class CreateAddressRequest with RpcRequestWrapper<CreateAddressRequest> {
  final String username;

  final String password;

  const CreateAddressRequest({required this.username, required this.password});

  @override
  String method() {
    return "avm.createAddress";
  }

  factory CreateAddressRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAddressRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAddressRequestToJson(this);
}

@JsonSerializable()
class CreateAddressResponse {
  final String address;

  const CreateAddressResponse({required this.address});

  factory CreateAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateAddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAddressResponseToJson(this);
}

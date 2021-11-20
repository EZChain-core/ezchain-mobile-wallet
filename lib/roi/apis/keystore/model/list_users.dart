import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/roi/common/rpc/rpc_request_wrapper.dart';

part 'list_users.g.dart';

@JsonSerializable()
class ListUsersRequest with RpcRequestWrapper<ListUsersRequest> {
  const ListUsersRequest();

  @override
  String method() {
    return "keystore.listUsers";
  }

  factory ListUsersRequest.fromJson(Map<String, dynamic> json) =>
      _$ListUsersRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ListUsersRequestToJson(this);
}

@JsonSerializable()
class ListUsersResponse {
  final List<String> users;

  const ListUsersResponse({required this.users});

  factory ListUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$ListUsersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListUsersResponseToJson(this);
}

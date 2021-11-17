import 'package:json_annotation/json_annotation.dart';

part 'rpc_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class RpcResponse<R> {
  @JsonKey(name: 'jsonrpc')
  final String jsonRpc;

  @JsonKey(name: 'result')
  final R result;

  @JsonKey(name: 'id')
  final int id;

  RpcResponse({required this.jsonRpc, required this.result, required this.id});

  factory RpcResponse.fromJson(
    Map<String, dynamic> json,
    R Function(Object json) fromJsonR,
  ) =>
      _$RpcResponseFromJson(json, fromJsonR);

  Map<String, dynamic> toJson(Object Function(R value) toJsonR) =>
      _$RpcResponseToJson(this, toJsonR);
}

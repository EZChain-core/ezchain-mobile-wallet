import 'package:json_annotation/json_annotation.dart';

part 'rpc_request.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class RpcRequest<P> {
  @JsonKey(name: 'jsonrpc')
  final String jsonRpc;

  @JsonKey(name: 'method')
  final String method;

  @JsonKey(name: 'params')
  final P params;

  @JsonKey(name: 'id')
  final int id;

  RpcRequest(
      {this.jsonRpc = "2.0",
      required this.method,
      required this.params,
      required this.id});

  factory RpcRequest.fromJson(
    Map<String, dynamic> json,
    P Function(Object? json) fromJsonP,
  ) =>
      _$RpcRequestFromJson(json, fromJsonP);

  Map<String, dynamic> toJson(Object Function(P value) toJsonP) =>
      _$RpcRequestToJson(this, toJsonP);
}

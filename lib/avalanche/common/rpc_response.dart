import 'package:json_annotation/json_annotation.dart';

part 'rpc_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class RpcResponse<R> {
  @JsonKey(name: 'result')
  final R result;

  RpcResponse({required this.result});

  factory RpcResponse.fromJson(
    Map<String, dynamic> json,
    R Function(Object? json) fromJsonR,
  ) =>
      _$RpcResponseFromJson(json, fromJsonR);

  Map<String, dynamic> toJson(Object Function(R value) toJsonR) =>
      _$RpcResponseToJson(this, toJsonR);
}

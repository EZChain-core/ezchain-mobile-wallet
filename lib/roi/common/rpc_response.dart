import 'package:json_annotation/json_annotation.dart';

part 'rpc_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class RpcResponse<R> {
  @JsonKey(name: 'result')
  final R? result;

  final RpcError? error;

  const RpcResponse({this.result, this.error});

  factory RpcResponse.fromJson(
    Map<String, dynamic> json,
    R Function(Object? json) fromJsonR,
  ) =>
      _$RpcResponseFromJson(json, fromJsonR);

  Map<String, dynamic> toJson(Object Function(R value) toJsonR) =>
      _$RpcResponseToJson(this, toJsonR);
}

@JsonSerializable()
class RpcError {
  final int code;
  final String message;
  final String data;

  const RpcError(
      {required this.code, required this.message, required this.data});

  factory RpcError.fromJson(Map<String, dynamic> json) =>
      _$RpcErrorFromJson(json);

  Map<String, dynamic> toJson() => _$RpcErrorToJson(this);
}

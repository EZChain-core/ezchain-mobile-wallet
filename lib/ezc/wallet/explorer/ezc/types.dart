import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';

part 'types.g.dart';

@JsonSerializable()
class EzcValidator {
  @JsonKey(name: "id")
  final String id;

  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "node_id")
  final String nodeId;

  EzcValidator(
    this.id,
    this.name,
    this.nodeId,
  );

  factory EzcValidator.fromJson(Map<String, dynamic> json) =>
      _$EzcValidatorFromJson(json);

  Map<String, dynamic> toJson() => _$EzcValidatorToJson(this);
}

@JsonSerializable()
class GetEzcValidatorsResponse {
  @JsonKey(name: "message")
  final String? message;

  @JsonKey(name: "error_code")
  final int errorCode;

  @JsonKey(name: "data")
  final List<EzcValidator> validators;

  GetEzcValidatorsResponse(this.message, this.errorCode, this.validators);

  factory GetEzcValidatorsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetEzcValidatorsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetEzcValidatorsResponseToJson(this);
}

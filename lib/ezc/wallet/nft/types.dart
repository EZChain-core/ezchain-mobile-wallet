import 'package:json_annotation/json_annotation.dart';

part 'types.g.dart';

@JsonSerializable()
class GenericFormType {
  final GenericNft? avalanche;

  GenericFormType({this.avalanche});

  factory GenericFormType.fromJson(Map<String, dynamic> json) =>
      _$GenericFormTypeFromJson(json);

  Map<String, dynamic> toJson() => _$GenericFormTypeToJson(this);
}

@JsonSerializable()
class GenericNft {
  final int version;
  final String type;
  final String title;
  final String img;
  final String? desc;
  final int? radius;

  @JsonKey(name: "img_b")
  final String? imgB;

  @JsonKey(name: "img_m")
  final String? imgM;

  GenericNft({
    required this.version,
    required this.type,
    required this.title,
    required this.img,
    this.desc,
    this.radius,
    this.imgB,
    this.imgM,
  });

  factory GenericNft.fromJson(Map<String, dynamic> json) =>
      _$GenericNftFromJson(json);

  Map<String, dynamic> toJson() => _$GenericNftToJson(this);
}

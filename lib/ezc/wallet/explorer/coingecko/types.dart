import 'package:json_annotation/json_annotation.dart';
import 'package:wallet/ezc/wallet/explorer/coingecko/requests.dart';

part 'types.g.dart';

@JsonSerializable()
class GetAvaxPriceResponse {
  @JsonKey(name: avaxCoinId)
  final Map<String, num> price;

  GetAvaxPriceResponse({required this.price});

  factory GetAvaxPriceResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAvaxPriceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAvaxPriceResponseToJson(this);
}

@JsonSerializable()
class GetAvaxPriceHistoryResponse {
  final List<List<num>> prices;

  GetAvaxPriceHistoryResponse({required this.prices});

  factory GetAvaxPriceHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAvaxPriceHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAvaxPriceHistoryResponseToJson(this);
}

import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';

part 'types.g.dart';

@JsonSerializable()
class EzcPrice {
  @JsonKey(name: "id")
  final String id;

  @JsonKey(name: "name")
  final String name;

  @JsonKey(name: "symbol")
  final String symbol;

  @JsonKey(name: "contracts")
  final List<EzcPriceContract> contracts;

  @JsonKey(name: "current_price")
  final num currentPrice;

  @JsonKey(name: "image")
  final String? image;

  Decimal get currentPriceDecimal =>
      Decimal.tryParse(currentPrice.toString()) ?? Decimal.zero;

  EzcPrice(
    this.id,
    this.name,
    this.symbol,
    this.contracts,
    this.currentPrice,
    this.image,
  );

  factory EzcPrice.fromJson(Map<String, dynamic> json) =>
      _$EzcPriceFromJson(json);

  Map<String, dynamic> toJson() => _$EzcPriceToJson(this);
}

@JsonSerializable()
class EzcPriceContract {
  @JsonKey(name: "chain")
  final String chain;

  @JsonKey(name: "contract_address")
  final String contractAddress;

  EzcPriceContract(this.chain, this.contractAddress);

  factory EzcPriceContract.fromJson(Map<String, dynamic> json) =>
      _$EzcPriceContractFromJson(json);

  Map<String, dynamic> toJson() => _$EzcPriceContractToJson(this);
}

@JsonSerializable()
class GetEzcPricesResponse {
  @JsonKey(name: "message")
  final String? message;

  @JsonKey(name: "error_code")
  final int errorCode;

  @JsonKey(name: "data")
  final List<EzcPrice> prices;

  GetEzcPricesResponse(this.message, this.errorCode, this.prices);

  factory GetEzcPricesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetEzcPricesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetEzcPricesResponseToJson(this);
}

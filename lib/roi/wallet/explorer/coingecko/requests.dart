import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:wallet/roi/sdk/utils/dio_logger.dart';

const AVAX_COIN_ID = "avalanche-2";
final coingeckoApi =
    Dio(BaseOptions(baseUrl: "https://api.coingecko.com/api/v3"))
      ..interceptors.add(prettyDioLogger);

/// Fetches the current AVAX price using Coin Gecko.
/// @remarks
/// You might get rate limited if you use this function frequently.
///
/// @return Current USD price of 1 AVAX
Future<num> getAvaxPrice({String currentCurrency = "USD"}) async {
  final response = await coingeckoApi.get<Map<String, dynamic>>(
      "/simple/price?ids=$AVAX_COIN_ID&vs_currencies=$currentCurrency");
  final avalanche = response.data?[AVAX_COIN_ID];
  final usd = avalanche[currentCurrency.toLowerCase()] as num;
  return usd;
}

/// Gets daily price history using Coin Gecko.
/// @param currency
Future<List<dynamic>> getAvaxPriceHistory(
    {String currentCurrency = "USD"}) async {
  final response = await coingeckoApi.get<Map<String, dynamic>>(
    "/coins/$AVAX_COIN_ID/market_chart",
    queryParameters: {
      "vs_currency": currentCurrency.toLowerCase(),
      "days": "max",
      "interval": "daily"
    },
  );
  return response.data?["prices"];
}

Future<Decimal> getAvaxPriceDecimal() async {
  final price = await getAvaxPrice();
  return Decimal.tryParse(price.toString()) ?? Decimal.zero;
}

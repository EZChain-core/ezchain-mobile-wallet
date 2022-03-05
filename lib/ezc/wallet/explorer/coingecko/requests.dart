import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:wallet/ezc/sdk/utils/dio_logger.dart';
import 'package:wallet/ezc/wallet/explorer/coingecko/rest_client.dart';

const avaxCoinId = "avalanche-2";
final _coinGeckoApi =
    Dio(BaseOptions(baseUrl: "https://api.coingecko.com/api/v3/"))
      ..interceptors.add(prettyDioLogger);

final _coinGeckoRestClient = CoingeckoRestClient(_coinGeckoApi);

/// Fetches the current AVAX price using Coin Gecko.
/// @remarks
/// You might get rate limited if you use this function frequently.
///
/// @return Current USD price of 1 AVAX
Future<num> getAvaxPrice({String currentCurrency = "USD"}) async {
  final response = await _coinGeckoRestClient.getAvaxPrice(
    avaxCoinId,
    currentCurrency,
  );
  return response.price[currentCurrency.toLowerCase()] ?? 0;
}

/// Gets daily price history using Coin Gecko.
/// @param currency
Future<List<dynamic>> getAvaxPriceHistory({
  String currentCurrency = "USD",
}) async {
  final queries = {
    "vs_currency": currentCurrency.toLowerCase(),
    "days": "max",
    "interval": "daily"
  };
  final response = await _coinGeckoRestClient.getAvaxPriceHistory(
    avaxCoinId,
    queries,
  );
  return response.prices;
}

Future<Decimal> getAvaxPriceDecimal() async {
  final price = await getAvaxPrice();
  return Decimal.tryParse(price.toString()) ?? Decimal.zero;
}

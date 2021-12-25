import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';

const COINGECKO_URL =
    'https://api.coingecko.com/api/v3/simple/price?ids=avalanche-2&vs_currencies=usd';

/// Fetches the current AVAX price using Coin Gecko.
/// @remarks
/// You might get rate limited if you use this function frequently.
///
/// @return Current USD price of 1 AVAX
Future<num> getAvaxPrice() async {
  var dio = Dio();
  final response = await dio.get<Map<String, dynamic>>(COINGECKO_URL);
  final avalanche = response.data?["avalanche-2"];
  final usd = avalanche["usd"] as num;
  return usd;
}

Future<Decimal> getAvaxPriceDecimal() async {
  final price = await getAvaxPrice();
  return Decimal.tryParse(price.toString()) ?? Decimal.zero;
}

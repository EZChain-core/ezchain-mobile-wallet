import 'package:dio/dio.dart';
import 'package:wallet/common/dio_logger.dart';
import 'package:wallet/ezc/wallet/explorer/price/rest_client.dart';
import 'package:wallet/ezc/wallet/explorer/price/types.dart';

final _ezcPriceApi = Dio(BaseOptions(baseUrl: "https://price.ezchain.com/v1/"))
  ..interceptors.add(prettyDioLogger);

final _ezcPriceRestClient = EzcPriceRestClient(_ezcPriceApi);

Future<Map<String, EzcPrice>> fetchEzcPrices(
  List<String> contractAddresses,
  String currency,
) async {
  final response = await _ezcPriceRestClient.getEzcPrices(
    contractAddresses.join(","),
    currency,
  );
  return {for (var price in response.prices) price.symbol.toLowerCase(): price};
}

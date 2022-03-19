import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:wallet/ezc/wallet/explorer/price/types.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class EzcPriceRestClient {
  factory EzcPriceRestClient(Dio dio, {String baseUrl}) = _EzcPriceRestClient;

  @GET("service/tokens")
  Future<GetEzcPricesResponse> getEzcPrices(
    @Query("contracts") String contractAddresses, {
    @Query("chain") String chain = "ezchain",
  });
}

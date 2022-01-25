import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:wallet/roi/wallet/explorer/coingecko/types.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class CoingeckoRestClient {
  factory CoingeckoRestClient(Dio dio, {String baseUrl}) = _CoingeckoRestClient;

  @GET("simple/price")
  Future<GetAvaxPriceResponse> getAvaxPrice(
    @Query("ids") String ids,
    @Query("vs_currencies") String currency,
  );

  @GET("coins/{coin_id}/market_chart")
  Future<GetAvaxPriceHistoryResponse> getAvaxPriceHistory(
    @Path("coin_id") String coinId,
    @Queries() Map<String, dynamic> queries,
  );
}

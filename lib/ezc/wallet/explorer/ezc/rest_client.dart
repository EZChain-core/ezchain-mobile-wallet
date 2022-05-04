import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:wallet/ezc/wallet/explorer/ezc/types.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class EzcServiceRestClient {
  factory EzcServiceRestClient(Dio dio, {String baseUrl}) =
      _EzcServiceRestClient;

  @GET("service/validators")
  Future<GetEzcValidatorsResponse> getValidators(
    @Query("node_ids") String nodeIds,
  );
}

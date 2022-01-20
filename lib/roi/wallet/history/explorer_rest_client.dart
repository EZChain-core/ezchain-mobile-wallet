import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:wallet/roi/wallet/history/raw_types.dart';

part 'explorer_rest_client.g.dart';

@RestApi()
abstract class ExplorerRestClient {
  factory ExplorerRestClient(Dio dio, {String baseUrl}) = _ExplorerRestClient;

  @POST("/v2/transaction")
  Future<GetTransactionsResponse> getGetTransactions(
    @Body() GetTransactionsRequest request,
  );
}

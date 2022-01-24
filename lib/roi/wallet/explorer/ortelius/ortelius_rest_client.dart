import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:wallet/roi/wallet/explorer/ortelius/types.dart';

part 'ortelius_rest_client.g.dart';

@RestApi()
abstract class OrteliusRestClient {
  factory OrteliusRestClient(Dio dio, {String baseUrl}) = _OrteliusRestClient;

  @GET("/v2/ctransactions")
  Future<GetOrteliusEvmTxsResponse> getEvmTransactions(
    @Query("address") String address,
  );

  @GET("/v2/ctransactions")
  Future<GetOrteliusEvmTxsResponse> getEvmTransaction(
    @Query("hash") String hash,
  );

  @POST("/v2/transactions")
  Future<GetOrteliusTxsResponse> getTransactions(
    @Body() GetOrteliusTxsRequest request,
  );

  @GET("/v2/transactions/{txId}")
  Future<OrteliusTx> getTransaction(@Path() String txId);
}

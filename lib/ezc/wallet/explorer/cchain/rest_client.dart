import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:wallet/ezc/wallet/explorer/cchain/types.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class CChainExplorerRestClient {
  factory CChainExplorerRestClient(Dio dio, {String baseUrl}) =
      _CChainExplorerRestClient;

  @GET("api?module=account&action=txlist&sort=desc")
  Future<GetCChainExplorerTxsResponse> getCChainTransactions(
    @Query("address") String address,
    @Query("page") int page,
    @Query("offset") int offset,
  );

  @GET("api?module=transaction&action=gettxinfo")
  Future<GetCChainExplorerTxInfoResponse> getCChainTransaction(
    @Query("txhash") String txHash,
  );

  @GET("api?module=account&action=tokentx")
  Future<GetErc20TransactionsResponse> getErc20Transactions(
    @Query("address") String address,
    @Query("sort") String sort,
    @Query("page") int page,
    @Query("offset") int offset,
    @Query("contractaddress") String? contractAddress,
  );

  @GET("api?module=account&action=tokentx")
  Future<GetErc20TransactionsResponse> getErc20Transaction(
    @Query("txHash") String txHash,
    @Query("address") String address,
    @Query("contractaddress") String? contractAddress,
  );
}

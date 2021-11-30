import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:wallet/roi/sdk/apis/avm/model/wallet_issue_tx.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_response.dart';

part 'avm_wallet_rest_client.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/exchange-chain-x-chain-api
@RestApi()
abstract class AvmWalletRestClient {
  factory AvmWalletRestClient(Dio dio, {String baseUrl}) = _AvmWalletRestClient;

  @POST("/")
  Future<RpcResponse<WalletIssueTxResponse>> walletIssueTx(
      @Body() RpcRequest<WalletIssueTxRequest> request);
}

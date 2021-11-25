import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:wallet/roi/apis/avm/model/wallet_issue_tx.dart';
import 'package:wallet/roi/apis/avm/model/wallet_send.dart';
import 'package:wallet/roi/apis/avm/model/wallet_send_multiple.dart';
import 'package:wallet/roi/common/rpc/rpc_request.dart';
import 'package:wallet/roi/common/rpc/rpc_response.dart';

part 'avm_wallet_rest_client.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/exchange-chain-x-chain-api
@RestApi()
abstract class AvmWalletRestClient {
  factory AvmWalletRestClient(Dio dio, {String baseUrl}) = _AvmWalletRestClient;

  @POST("/")
  Future<RpcResponse<WalletSendResponse>> walletSend(
      @Body() RpcRequest<WalletSendRequest> request);

  @POST("/")
  Future<RpcResponse<WalletSendMultipleResponse>> walletSendMultiple(
      @Body() RpcRequest<WalletSendMultipleRequest> request);

  @POST("/")
  Future<RpcResponse<WalletIssueTxResponse>> walletIssueTx(
      @Body() RpcRequest<WalletIssueTxRequest> request);
}

import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import 'package:wallet/roi/sdk/apis/evm/model/get_atomic_tx_status.dart';
import 'package:wallet/roi/sdk/apis/evm/model/issue_tx.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_response.dart';

part 'evm_avax_rest_client.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/contract-chain-c-chain-api
@RestApi()
abstract class EvmAvaxRestClient {
  factory EvmAvaxRestClient(Dio dio, {String baseUrl}) = _EvmAvaxRestClient;

  @POST("")
  Future<RpcResponse<IssueTxResponse>> issueTx(
      @Body() RpcRequest<IssueTxRequest> request);

  @POST("")
  Future<RpcResponse<GetAtomicTxStatusResponse>> getAtomicTxStatus(
      @Body() RpcRequest<GetAtomicTxStatusRequest> request);
}

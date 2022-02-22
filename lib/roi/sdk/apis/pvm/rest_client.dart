import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_current_supply.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_min_stake.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_pending_validators.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_stake.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_staking_asset_id.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_total_of_stake.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_tx_status.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_utxos.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/issue_tx.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_request.dart';
import 'package:wallet/roi/sdk/common/rpc/rpc_response.dart';

part 'rest_client.g.dart';

/// https://docs.avax.network/build/avalanchego-apis/platform-chain-p-chain-api#platformgetutxos
@RestApi()
abstract class PvmRestClient {
  factory PvmRestClient(Dio dio, {String baseUrl}) = _PvmRestClient;

  @POST("")
  Future<RpcResponse<GetUTXOsResponse>> getUTXOs(
      @Body() RpcRequest<GetUTXOsRequest> request);

  @POST("")
  Future<RpcResponse<GetStakeResponse>> getStake(
      @Body() RpcRequest<GetStakeRequest> request);

  @POST("")
  Future<RpcResponse<GetStakingAssetIdResponse>> getStakingAssetId(
      @Body() RpcRequest<GetStakingAssetIdRequest> request);

  @POST("")
  Future<RpcResponse<IssueTxResponse>> issueTx(
      @Body() RpcRequest<IssueTxRequest> request);

  @POST("")
  Future<RpcResponse<GetTxStatusResponse>> getTxStatus(
      @Body() RpcRequest<GetTxStatusRequest> request);

  @POST("")
  Future<RpcResponse<GetCurrentValidatorsResponse>> getCurrentValidators(
      @Body() RpcRequest<GetCurrentValidatorsRequest> request);

  @POST("")
  Future<RpcResponse<GetPendingValidatorsResponse>> getPendingValidators(
      @Body() RpcRequest<GetPendingValidatorsRequest> request);

  @POST("")
  Future<RpcResponse<GetMinStakeResponse>> getMinStake(
      @Body() RpcRequest<GetMinStakeRequest> request);

  @POST("")
  Future<RpcResponse<GetCurrentSupplyResponse>> getCurrentSupply(
      @Body() RpcRequest<GetCurrentSupplyRequest> request);

  @POST("")
  Future<RpcResponse<GetTotalOfStakeResponse>> getTotalOfStake(
      @Body() RpcRequest<GetTotalOfStakeRequest> request);
}

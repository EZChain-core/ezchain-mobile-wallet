import 'package:dio/dio.dart';
import 'package:wallet/ezc/sdk/utils/dio_logger.dart';
import 'package:wallet/ezc/wallet/explorer/cchain/constants.dart';
import 'package:wallet/ezc/wallet/explorer/cchain/rest_client.dart';
import 'package:wallet/ezc/wallet/explorer/cchain/types.dart';
import 'package:wallet/ezc/wallet/explorer/cchain/utils.dart';
import 'package:wallet/ezc/wallet/network/utils.dart';
import 'package:collection/collection.dart';

Dio _createCChainExplorerApi({bool isMainnet = true}) {
  String baseUrl = "";
  if (isMainnet) {
    baseUrl = cChainExplorerMainnet;
  } else {
    baseUrl = cChainExplorerTestnet;
  }
  return Dio(BaseOptions(baseUrl: baseUrl))..interceptors.add(prettyDioLogger);
}

Future<List<CChainExplorerTx>> getCChainTransactions(
  String address, {
  int page = 0,
  int offset = 0,
}) async {
  final dio = _createCChainExplorerApi(isMainnet: isMainnetNetwork);
  final cChainRestClient = CChainExplorerRestClient(dio);
  final response = await cChainRestClient.getCChainTransactions(
    address,
    page,
    offset,
  );
  return filterDuplicateTransactions(response.result);
}

Future<CChainExplorerTxInfo> getCChainTransaction(String txHash) async {
  final dio = _createCChainExplorerApi(isMainnet: isMainnetNetwork);
  final cChainRestClient = CChainExplorerRestClient(dio);
  final response = await cChainRestClient.getCChainTransaction(txHash);
  return response.result;
}

Future<List<CChainErc20Tx>> getErc20Transactions(
  String address, {
  int page = 0,
  int offset = 0,
  String? contractAddress,
}) async {
  final dio = _createCChainExplorerApi(isMainnet: isMainnetNetwork);
  final cChainRestClient = CChainExplorerRestClient(dio);
  final response = await cChainRestClient.getErc20Transactions(
    address,
    "desc",
    page,
    offset,
    contractAddress,
  );
  return filterDuplicateERC20Txs(response.result);
}

Future<CChainErc20Tx?> getErc20Transaction(
  String txHash,
  String address, {
  String? contractAddress,
}) async {
  final dio = _createCChainExplorerApi(isMainnet: isMainnetNetwork);
  final cChainRestClient = CChainExplorerRestClient(dio);
  final response = await cChainRestClient.getErc20Transaction(
    txHash,
    address,
    contractAddress,
  );
  return response.result.firstOrNull;
}

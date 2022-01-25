import 'package:dio/dio.dart';
import 'package:wallet/roi/sdk/utils/dio_logger.dart';
import 'package:wallet/roi/wallet/explorer/cchain/constants.dart';
import 'package:wallet/roi/wallet/explorer/cchain/rest_client.dart';
import 'package:wallet/roi/wallet/explorer/cchain/types.dart';
import 'package:wallet/roi/wallet/explorer/cchain/utils.dart';
import 'package:wallet/roi/wallet/network/utils.dart';

Dio _createCChainExplorerApi({bool isMainNet = true}) {
  String baseUrl = "";
  if (isMainNet) {
    baseUrl = cChainExplorerMainNet;
  } else {
    baseUrl = cChainExplorerTestNet;
  }
  return Dio(BaseOptions(baseUrl: baseUrl))..interceptors.add(prettyDioLogger);
}

Future<List<CChainExplorerTx>> getCChainTransactions(
  String address, {
  int page = 0,
  int offset = 0,
}) async {
  final dio = _createCChainExplorerApi(isMainNet: isMainNetNetwork);
  final cChainRestClient = CChainExplorerRestClient(dio);
  final response = await cChainRestClient.getCChainTransactions(
    address,
    page,
    offset,
  );
  return filterDuplicateTransactions(response.result);
}

Future<CChainExplorerTxInfo> getCChainTransaction(String txHash) async {
  final dio = _createCChainExplorerApi(isMainNet: isMainNetNetwork);
  final cChainRestClient = CChainExplorerRestClient(dio);
  final response = await cChainRestClient.getCChainTransaction(txHash);
  return response.result;
}

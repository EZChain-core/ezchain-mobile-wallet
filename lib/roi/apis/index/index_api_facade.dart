import 'package:dio/dio.dart';
import 'package:wallet/roi/apis/index/index_api.dart';

class IndexApiFacade {
  final Dio dio;

  late IndexApi xChainTransactions;

  late IndexApi xChainVertices;

  late IndexApi pChainBlocks;

  late IndexApi cChainBlocks;

  IndexApiFacade({required this.dio}) {
    final baseUrl = dio.options.baseUrl;
    xChainTransactions = IndexApi(dio, baseUrl: "$baseUrl/ext/index/X/tx");
    xChainVertices = IndexApi(dio, baseUrl: "$baseUrl/ext/index/X/vtx");
    pChainBlocks = IndexApi(dio, baseUrl: "$baseUrl/ext/index/P/block");
    cChainBlocks = IndexApi(dio, baseUrl: "$baseUrl/ext/index/C/block");
  }
}

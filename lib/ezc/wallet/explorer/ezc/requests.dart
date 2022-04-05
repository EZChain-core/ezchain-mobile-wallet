import 'package:dio/dio.dart';
import 'package:wallet/ezc/sdk/utils/dio_logger.dart';
import 'package:wallet/ezc/wallet/explorer/ezc/rest_client.dart';

final _ezcApi = Dio(BaseOptions(baseUrl: "https://api.ezchain.com/v1/"))
  ..interceptors.add(prettyDioLogger);

final _ezcServiceRestClient = EzcServiceRestClient(_ezcApi);

Future<Map<String, String>> fetchEzcValidators(
  List<String> nodeIds,
) async {
  final response = await _ezcServiceRestClient.getValidators(nodeIds.join(","));
  return {
    for (var validator in response.validators) validator.nodeId: validator.name
  };
}

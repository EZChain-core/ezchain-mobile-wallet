import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wallet/avalanche/apis/auth/auth_api.dart';
import 'package:wallet/avalanche/utils/constants.dart';
import 'package:wallet/avalanche/utils/helper_functions.dart';

abstract class Avalanche {
  AuthApi get authApi;
}

class AvalancheCore implements Avalanche {
  final String host;

  final int port;

  final String protocol;

  final int networkId;

  final String? hrp;

  late AuthApi _authApi;

  @override
  AuthApi get authApi => _authApi;

  AvalancheCore(
      {required this.host,
      required this.port,
      this.protocol = "http",
      this.networkId = defaultNetworkID,
      this.hrp})
      : assert(!protocols.contains(protocol), "Error - Invalid protocol") {
    final host = this.host.replaceAll(RegExp('[^A-Za-z0-9.]'), '');
    final hrp = this.hrp ?? getPreferredHRP(networkId);
    var url = "$protocol://$host";
    if (port > 0) {
      url += ":$port";
    }

    // "Content-Type": "application/json;charset=UTF-8"
    final dio = Dio(
        BaseOptions(baseUrl: url, connectTimeout: 5000, receiveTimeout: 5000))
      ..interceptors.add(PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 200));

    _authApi = AuthApi(dio);
  }
}

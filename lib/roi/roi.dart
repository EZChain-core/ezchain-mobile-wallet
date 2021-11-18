import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wallet/roi/apis/auth/auth_api.dart';
import 'package:wallet/roi/apis/info/info_api.dart';
import 'package:wallet/roi/apis/keystore/keystore_api.dart';
import 'package:wallet/roi/utils/constants.dart';
import 'package:wallet/roi/utils/helper_functions.dart';

abstract class ROI {
  @visibleForTesting
  Dio get dio;

  AuthApi get authApi;

  KeystoreApi get keystoreApi;

  InfoApi get infoApi;
}

class ROICore implements ROI {
  final String host;

  final int port;

  final String protocol;

  final int networkId;

  final String? hrp;

  late Dio _dio;

  late AuthApi _authApi;

  late KeystoreApi _keystoreApi;

  late InfoApi _infoApi;

  @override
  Dio get dio => _dio;

  @override
  AuthApi get authApi => _authApi;

  @override
  KeystoreApi get keystoreApi => _keystoreApi;

  @override
  InfoApi get infoApi => _infoApi;

  int get rpcId => _rpcId;

  var _rpcId = 1;

  ROICore({
    required this.host,
    required this.port,
    this.protocol = "http",
    this.networkId = defaultNetworkID,
    this.hrp,
    int connectTimeout = 5000,
    int receiveTimeout = 5000,
  }) : assert(protocols.contains(protocol), "Error - Invalid protocol") {
    final host = this.host.replaceAll(RegExp('[^A-Za-z0-9.]'), '');
    final hrp = this.hrp ?? getPreferredHRP(networkId);
    var url = "$protocol://$host";
    if (port > 0) {
      url += ":$port";
    }

    _dio = Dio(
      BaseOptions(
          baseUrl: url,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          contentType: "application/json;charset=UTF-8"),
    )
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          final request = options.data;
          if (request is Map<String, dynamic>) {
            request["jsonrpc"] = "2.0";
            request["id"] = rpcId;
          }
          handler.next(options);
        },
        onResponse: (response, handler) async {
          final statusCode = response.statusCode;
          if (statusCode != null && statusCode >= 200 && statusCode < 300) {
            _rpcId += 1;
          }
          handler.next(response);
        },
      ))
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 200,
      ));

    _authApi = AuthApi(dio);
    _keystoreApi = KeystoreApi(dio);
    _infoApi = InfoApi(dio);
  }
}

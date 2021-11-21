import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wallet/roi/apis/auth/auth_api.dart';
import 'package:wallet/roi/apis/auth/auth_api_impl.dart';
import 'package:wallet/roi/apis/index/index_api_facade.dart';
import 'package:wallet/roi/apis/info/info_api.dart';
import 'package:wallet/roi/apis/keystore/keystore_api.dart';
import 'package:wallet/roi/utils/constants.dart';
import 'package:wallet/roi/utils/helper_functions.dart';

abstract class ROI {
  AuthApi get authApi;

  KeystoreApi get keystoreApi;

  InfoApi get infoApi;

  IndexApiFacade get indexApiFacade;
}

abstract class ROINetwork {
  final String host;

  final int port;

  final String protocol;

  final int networkId;

  String? hrp;

  final int connectTimeout;

  final int receiveTimeout;

  Dio get dio => _dio;

  late Dio _dio;

  int get rpcId => _rpcId;

  var _rpcId = 1;

  ROINetwork(this.host, this.port, this.protocol, this.networkId, this.hrp,
      this.connectTimeout, this.receiveTimeout)
      : assert(protocols.contains(protocol), "Error - Invalid protocol") {
    hrp = hrp ?? getPreferredHRP(networkId);
    final host = this.host.replaceAll(RegExp('[^A-Za-z0-9.]'), '');
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
  }
}

class ROICore extends ROINetwork implements ROI {
  late AuthApi _authApi;

  late KeystoreApi _keystoreApi;

  late InfoApi _infoApi;

  late IndexApiFacade _indexApiFacade;

  @override
  AuthApi get authApi => _authApi;

  @override
  KeystoreApi get keystoreApi => _keystoreApi;

  @override
  InfoApi get infoApi => _infoApi;

  @override
  IndexApiFacade get indexApiFacade => _indexApiFacade;

  ROICore(
    String host,
    int port,
    String protocol,
    int networkId,
    String xChainId,
    String cChainId,
    String hrp,
    int connectTimeout,
    int receiveTimeout,
  ) : super(host, port, protocol, networkId, hrp, connectTimeout,
            receiveTimeout) {
    if (xChainId.isEmpty || xChainId.toLowerCase() == "x") {
      if (networks.containsKey(networkId)) {
        xChainId = networks[networkId]!.x.blockchainID;
      } else {
        xChainId = networks[12345]!.x.blockchainID;
      }
    }
    if (cChainId.isEmpty || cChainId.toLowerCase() == "c") {
      if (networks.containsKey(networkId)) {
        cChainId = networks[networkId]!.c.blockchainID;
      } else {
        cChainId = networks[12345]!.c.blockchainID;
      }
    }

    _authApi = AuthApiImpl(roiNetwork: super);
    _keystoreApi = KeystoreApi(dio);
    _infoApi = InfoApi(dio);
    _indexApiFacade = IndexApiFacade(dio: dio);
  }
}

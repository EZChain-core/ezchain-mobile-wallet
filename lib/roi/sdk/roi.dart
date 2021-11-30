import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wallet/roi/sdk/apis/avm/avm_api.dart';
import 'package:wallet/roi/sdk/apis/evm/evm_api.dart';
import 'package:wallet/roi/sdk/apis/index/index_api.dart';
import 'package:wallet/roi/sdk/apis/info/info_api.dart';
import 'package:wallet/roi/sdk/apis/pvm/pvm_api.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';

abstract class ROI {
  InfoApi get infoApi;

  IndexApi get indexApi;

  AvmApi get avmApi;

  EvmApi get evmApi;

  PvmApi get pvmApi;

  String getHRP();

  void setAddress(String host, int port, String protocol);

  void setNetworkId(int networkId);

  void setRequestConfig(String key, dynamic value);

  void removeRequestConfig(String key);

  factory ROI.create({
    required String host,
    required int port,
    required String protocol,
    int networkId = defaultNetworkId,
    String xChainId = "",
    String cChainId = "",
    String hrp = "",
    int connectTimeout = 5000,
    int receiveTimeout = 5000,
  }) {
    return _ROICore(host, port, protocol, networkId, xChainId, cChainId, hrp,
        connectTimeout, receiveTimeout);
  }
}

abstract class ROINetwork {
  final String host;

  final int port;

  final String protocol;

  int networkId;

  String hrp;

  final int connectTimeout;

  final int receiveTimeout;

  Dio get dio => _dio;

  late Dio _dio;

  int get rpcId => _rpcId;

  var _rpcId = 1;

  ROINetwork(this.host, this.port, this.protocol, this.networkId, this.hrp,
      this.connectTimeout, this.receiveTimeout)
      : assert(protocols.contains(protocol), "Error - Invalid protocol") {
    if (hrp.isEmpty) {
      hrp = getPreferredHRP(networkId);
    }
    changeAddress(host, port, protocol);
  }

  void changeAddress(String host, int port, String protocol) {
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

  void changeNetworkId(int networkId) {
    this.networkId = networkId;
    hrp = getPreferredHRP(networkId);
  }

  void addHeader(String key, dynamic value) {
    dio.options.headers[key] = value;
  }

  void removeHeader(String key) {
    dio.options.headers.remove(key);
  }
}

class _ROICore extends ROINetwork implements ROI {

  late InfoApi _infoApi;

  late IndexApi _indexApi;

  late AvmApi _avmApi;

  late EvmApi _evmApi;

  late PvmApi _pvmApi;

  @override
  InfoApi get infoApi => _infoApi;

  @override
  IndexApi get indexApi => _indexApi;

  @override
  AvmApi get avmApi => _avmApi;

  @override
  EvmApi get evmApi => _evmApi;

  @override
  PvmApi get pvmApi => _pvmApi;

  _ROICore(
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
        xChainId = networks[networkId]!.x.blockchainId;
      } else {
        xChainId = networks[12345]!.x.blockchainId;
      }
    }
    if (cChainId.isEmpty || cChainId.toLowerCase() == "c") {
      if (networks.containsKey(networkId)) {
        cChainId = networks[networkId]!.c.blockchainId;
      } else {
        cChainId = networks[12345]!.c.blockchainId;
      }
    }

    _infoApi = InfoApi.create(roiNetwork: this);
    _indexApi = IndexApi.create(roiNetwork: this);
    _avmApi = AvmApi.create(roiNetwork: this, blockChainId: xChainId);
    _evmApi = EvmApi.create(roiNetwork: this, blockChainId: cChainId);
    _pvmApi = PvmApi.create(roiNetwork: this);
  }

  @override
  String getHRP() {
    return hrp;
  }

  @override
  void setAddress(String host, int port, String protocol) {
    changeAddress(host, port, protocol);
  }

  @override
  void setNetworkId(int networkId) {}

  @override
  void removeRequestConfig(String key) {
    removeHeader(key);
  }

  @override
  void setRequestConfig(String key, value) {
    addHeader(key, value);
  }
}

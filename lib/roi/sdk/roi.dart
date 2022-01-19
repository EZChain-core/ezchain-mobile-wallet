import 'package:dio/dio.dart';
import 'package:wallet/roi/sdk/apis/avm/api.dart';
import 'package:wallet/roi/sdk/apis/evm/api.dart';
import 'package:wallet/roi/sdk/apis/pvm/api.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/dio_logger.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';

abstract class ROI {
  AvmApi get avmApi;

  EvmApi get evmApi;

  PvmApi get pvmApi;

  int getNetworkId();

  String getHRP();

  factory ROI.create(
      {required String host,
      required int port,
      required String protocol,
      int networkId = defaultNetworkId,
      String xChainId = "",
      String cChainId = "",
      String hrp = "",
      bool skipInit = false}) {
    return _ROICore(
      host,
      port,
      protocol,
      networkId,
      xChainId,
      cChainId,
      hrp,
      skipInit: skipInit,
    );
  }
}

abstract class ROINetwork {
  final String host;

  final int port;

  final String protocol;

  int networkId;

  String hrp;

  Dio get dio => _dio;

  late Dio _dio;

  int get rpcId => _rpcId;

  var _rpcId = 1;

  ROINetwork(this.host, this.port, this.protocol, this.networkId, this.hrp)
      : assert(protocols.contains(protocol), "Error - Invalid protocol") {
    if (hrp.isEmpty) {
      hrp = getPreferredHRP(networkId);
    }
    changeAddress(host, port, protocol);
  }

  void changeAddress(String host, int port, String protocol) {
    final host = this.host.replaceAll(RegExp('[^A-Za-z0-9.-]'), '');
    var url = "$protocol://$host";
    if (port > 0) {
      url += ":$port";
    }

    _dio = Dio(BaseOptions(baseUrl: url))
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
      ..interceptors.add(prettyDioLogger);
  }
}

class _ROICore extends ROINetwork implements ROI {
  late AvmApi _avmApi;

  late EvmApi _evmApi;

  late PvmApi _pvmApi;

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
    String hrp, {
    bool skipInit = false,
  }) : super(host, port, protocol, networkId, hrp) {
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
    if (!skipInit) {
      _avmApi = AvmApi.create(roiNetwork: this, blockChainId: xChainId);
      _evmApi = EvmApi.create(roiNetwork: this, blockChainId: cChainId);
      _pvmApi = PvmApi.create(roiNetwork: this);
    }
  }

  @override
  int getNetworkId() {
    return networkId;
  }

  @override
  String getHRP() {
    return hrp;
  }
}

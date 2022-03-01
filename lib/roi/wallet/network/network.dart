import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:wallet/roi/sdk/apis/avm/api.dart';
import 'package:wallet/roi/sdk/apis/evm/api.dart';
import 'package:wallet/roi/sdk/apis/pvm/api.dart';
import 'package:wallet/roi/sdk/roi.dart';
import 'package:wallet/roi/sdk/utils/dio_logger.dart';
import 'package:wallet/roi/wallet/network/constants.dart';
import 'package:wallet/roi/wallet/network/helpers/rpc_from_config.dart';
import 'package:wallet/roi/wallet/network/types.dart';
import 'package:web3dart/web3dart.dart';

var _activeNetwork = testnetConfig;

NetworkConfig get activeNetwork => _activeNetwork;

var _roi = _createROIProvider(activeNetwork);

ROI get roi => _roi;

AvmApi get xChain => roi.avmApi;
EvmApi get cChain => roi.evmApi;
PvmApi get pChain => roi.pvmApi;

Dio? _explorerApi;

Dio? get explorerApi => _explorerApi;

var _web3 = Web3Client(getRpcC(activeNetwork), Client());

Web3Client get web3 => _web3;

ROI _createROIProvider(NetworkConfig config) {
  return ROI.create(
    host: config.apiIp,
    port: config.apiPort,
    protocol: config.apiProtocol,
    networkId: config.networkId,
  );
}

int? getEvmChainID() {
  return activeNetwork.evmChainId;
}

/// Changes the connected network of the SDK.
/// This is a synchronous call that does not do any network requests.
void setRpcNetwork(NetworkConfig config) {
  _roi = _createROIProvider(config);

  final explorerUrl = config.explorerURL;

  if (explorerUrl != null && explorerUrl.isNotEmpty) {
    _explorerApi = _createExplorerApi(explorerUrl);
  } else {
    _explorerApi = null;
  }
  _web3 = Web3Client(getRpcC(config), Client());

  _activeNetwork = config;
}

Dio _createExplorerApi(String explorerApi) {
  return Dio(
    BaseOptions(baseUrl: explorerApi),
  )..interceptors.add(prettyDioLogger);
}

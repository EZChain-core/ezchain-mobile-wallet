import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:wallet/ezc/sdk/apis/avm/api.dart';
import 'package:wallet/ezc/sdk/apis/evm/api.dart';
import 'package:wallet/ezc/sdk/apis/pvm/api.dart';
import 'package:wallet/ezc/sdk/ezc.dart';
import 'package:wallet/ezc/sdk/utils/dio_logger.dart';
import 'package:wallet/ezc/wallet/network/constants.dart';
import 'package:wallet/ezc/wallet/network/helpers/rpc_from_config.dart';
import 'package:wallet/ezc/wallet/network/types.dart';
import 'package:web3dart/web3dart.dart';

var _activeNetwork = testnetConfig;

NetworkConfig get activeNetwork => _activeNetwork;

var _ezc = _createEZCProvider(activeNetwork);

EZC get ezc => _ezc;

AvmApi get xChain => ezc.avmApi;
EvmApi get cChain => ezc.evmApi;
PvmApi get pChain => ezc.pvmApi;

Dio? _explorerApi;

Dio? get explorerApi => _explorerApi;

var _web3Client = Web3Client(getRpcC(activeNetwork), Client());

Web3Client get web3Client => _web3Client;

EZC _createEZCProvider(NetworkConfig config) {
  return EZC.create(
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
  _ezc = _createEZCProvider(config);

  final explorerUrl = config.explorerURL;

  if (explorerUrl != null && explorerUrl.isNotEmpty) {
    _explorerApi = _createExplorerApi(explorerUrl);
  } else {
    _explorerApi = null;
  }
  _web3Client = Web3Client(getRpcC(config), Client());

  _activeNetwork = config;
}

Dio _createExplorerApi(String explorerApi) {
  return Dio(
    BaseOptions(baseUrl: explorerApi),
  )..interceptors.add(prettyDioLogger);
}

import 'package:http/http.dart';
import 'package:wallet/roi/sdk/apis/info/model/get_network_id.dart';
import 'package:wallet/roi/sdk/roi.dart';
import 'package:wallet/roi/wallet/network/constants.dart';
import 'package:web3dart/web3dart.dart';

var activeNetwork = defaultConfig;

final roi = _createROIProvider(activeNetwork);

final xChain = roi.avmApi;
final cChain = roi.evmApi;
final pChain = roi.pvmApi;
final infoApi = roi.infoApi;

var web3 = Web3Client(getRpcC(activeNetwork), Client());

ROI _createROIProvider(NetworkConfig config) {
  return ROI.create(
      host: config.apiIp,
      port: config.apiPort,
      protocol: config.apiProtocol,
      networkId: config.networkId);
}

int? getEvmChainID() {
  return activeNetwork.evmChainId;
}

/// Similar to `setRpcNetwork`, but checks if credentials can be used with the api.
/// Checks if the given network accepts credentials.
/// This must be true to use cookies.
Future<bool> setRpcNetworkAsync(NetworkConfig config) async {
  final roi = _createROIProvider(config);
  roi.setRequestConfig("withCredentials", true);
  final infoApi = roi.infoApi;
  var credentials = false;
  final request = const GetNetworkIdRequest().toRpc();
  try {
    await infoApi.getNetworkId(request);
    credentials = true;
  } catch (e) {}
  roi.setRequestConfig("withCredentials", false);
  try {
    await infoApi.getNetworkId(request);
    setRpcNetwork(config, credentials: credentials);
  } catch (e) {
    return false;
  }
  return true;
}

/// Changes the connected network of the SDK.
/// This is a synchronous call that does not do any network requests.
void setRpcNetwork(NetworkConfig config, {bool credentials = true}) {
  activeNetwork = config;
  roi.setAddress(config.apiIp, config.apiPort, config.apiProtocol);
  roi.setNetworkId(config.networkId);

  if (credentials) {
    roi.setRequestConfig('withCredentials', credentials);
  } else {
    roi.removeRequestConfig('withCredentials');
  }

  xChain.refreshBlockchainId(config.xChainId);
  xChain.setBlockchainAlias("X");

  xChain.refreshBlockchainId(config.pChainId);
  pChain.setBlockchainAlias("P");

  xChain.refreshBlockchainId(config.cChainId);
  cChain.setBlockchainAlias("C");

  xChain.setAVAXAssetId(config.avaxId);
  pChain.setAVAXAssetId(config.avaxId);
  cChain.setAVAXAssetId(config.avaxId);

  web3 = Web3Client(getRpcC(config), Client());
}

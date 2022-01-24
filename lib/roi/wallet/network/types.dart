import 'package:wallet/roi/wallet/network/helpers/rpc_from_config.dart';

class NetworkConfigRpc {
  final String c;
  final String x;
  final String p;

  const NetworkConfigRpc({required this.c, required this.x, required this.p});
}

class NetworkConfig {
  final String rawUrl;
  final String apiProtocol;
  final String apiIp;
  final int apiPort;
  final String? explorerURL;
  final String? explorerSiteURL;
  final int networkId;
  final int evmChainId;
  final String xChainId;
  final String pChainId;
  final String cChainId;
  final String avaxId;
  late NetworkConfigRpc rpcUrl;

  NetworkConfig({
    required this.rawUrl,
    required this.apiProtocol,
    required this.apiIp,
    required this.apiPort,
    this.explorerURL,
    this.explorerSiteURL,
    required this.networkId,
    required this.evmChainId,
    required this.xChainId,
    required this.pChainId,
    required this.cChainId,
    required this.avaxId,
  }) {
    rpcUrl = NetworkConfigRpc(
      c: getRpcC(this),
      p: getRpcP(this),
      x: getRpcX(this),
    );
  }
}

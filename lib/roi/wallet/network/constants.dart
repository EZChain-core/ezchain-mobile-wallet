import 'package:wallet/roi/sdk/utils/constants.dart';

final mainNetConfig = NetworkConfig(
  rawUrl: 'https://api.avax.network',
  apiProtocol: 'https',
  apiIp: 'api.avax.network',
  apiPort: 443,
  explorerURL: 'https://explorerapi.avax.network',
  explorerSiteURL: 'https://explorer.avax.network',
  networkId: 1,
  xChainId: networks[1]!.x.blockchainId,
  pChainId: networks[1]!.p.blockchainId,
  cChainId: networks[1]!.c.blockchainId,
  evmChainId: networks[1]!.c.chainId,
  avaxId: networks[1]!.x.avaxAssetId,
);

final testNetConfig = NetworkConfig(
  rawUrl: 'https://testnet-api.ezchain.com',
  apiProtocol: 'https',
  apiIp: 'testnet-api.ezchain.com',
  apiPort: 443,
  explorerURL: 'https://testnet-index-api.ezchain.com',
  explorerSiteURL: 'https://testnet-explorer.ezchain.com',
  networkId: 5,
  xChainId: networks[5]!.x.blockchainId,
  pChainId: networks[5]!.p.blockchainId,
  cChainId: networks[5]!.c.blockchainId,
  evmChainId: networks[5]!.c.chainId,
  avaxId: networks[5]!.x.avaxAssetId,
);

final localNetConfig = NetworkConfig(
  rawUrl: 'http://localhost:9650',
  apiProtocol: 'http',
  apiIp: 'localhost',
  apiPort: 9650,
  networkId: 12345,
  xChainId: networks[12345]!.x.blockchainId,
  pChainId: networks[12345]!.p.blockchainId,
  cChainId: networks[12345]!.c.blockchainId,
  evmChainId: networks[12345]!.c.chainId,
  avaxId: networks[12345]!.x.avaxAssetId,
);

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
  final int? evmChainId;
  final String xChainId;
  final String pChainId;
  final String cChainId;
  final String? avaxId;
  late NetworkConfigRpc rpcUrl;

  NetworkConfig({
    required this.rawUrl,
    required this.apiProtocol,
    required this.apiIp,
    required this.apiPort,
    this.explorerURL,
    this.explorerSiteURL,
    required this.networkId,
    this.evmChainId,
    required this.xChainId,
    required this.pChainId,
    required this.cChainId,
    this.avaxId,
  }) {
    rpcUrl = NetworkConfigRpc(
      c: getRpcC(this),
      p: getRpcP(this),
      x: getRpcX(this),
    );
  }
}

String getRpcC(NetworkConfig conf) {
  return "${conf.apiProtocol}://${conf.apiIp}:${conf.apiPort}/ext/bc/C/rpc";
}

String getRpcX(NetworkConfig conf) {
  return "${conf.apiProtocol}://${conf.apiIp}:${conf.apiPort}/ext/bc/X";
}

String getRpcP(NetworkConfig conf) {
  return "${conf.apiProtocol}://${conf.apiIp}:${conf.apiPort}/ext/bc/P";
}

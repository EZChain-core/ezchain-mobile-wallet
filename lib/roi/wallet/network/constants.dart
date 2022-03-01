import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/wallet/network/types.dart';

final mainnetConfig = NetworkConfig(
  rawUrl: 'https://api.ezchain.com',
  apiProtocol: 'https',
  apiIp: 'api.ezchain.com',
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

final testnetConfig = NetworkConfig(
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

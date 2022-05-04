import 'package:wallet/ezc/wallet/network/constants.dart';
import 'package:wallet/ezc/wallet/network/network.dart';

bool get isMainnetNetwork => activeNetwork.networkId == mainnetConfig.networkId;

bool get isTestnetNetwork => activeNetwork.networkId == testnetConfig.networkId;

String getAvaxAssetId() {
  return activeNetwork.avaxId;
}

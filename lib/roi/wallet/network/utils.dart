import 'package:wallet/roi/wallet/network/constants.dart';
import 'package:wallet/roi/wallet/network/network.dart';

bool get isMainNetNetwork => activeNetwork.networkId == mainNetConfig.networkId;

bool get isFujiNetNetwork => activeNetwork.networkId == testNetConfig.networkId;

String getAvaxAssetId() {
  return activeNetwork.avaxId;
}

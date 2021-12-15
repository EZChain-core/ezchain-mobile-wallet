import 'package:wallet/roi/wallet/network/network.dart';

Future<dynamic> getAssetDescription(String assetId) async {
  await xChain.getAssetDescription(assetId);
}

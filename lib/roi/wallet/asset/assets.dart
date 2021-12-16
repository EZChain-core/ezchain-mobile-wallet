import 'package:wallet/common/logger.dart';
import 'package:wallet/roi/wallet/asset/types.dart';
import 'package:wallet/roi/wallet/network/network.dart';

AssetCache assetCache = {};

AssetDescriptionClean getAssetDescriptionSync(String assetId) {
  final cache = assetCache[assetId];
  if (cache == null) throw Exception("Asset $assetId} does not exist.");
  return cache;
}

Future<AssetDescriptionClean> getAssetDescription(String assetId) async {
  final cache = assetCache[assetId];
  if (cache != null) return cache;
  try {
    final response = await xChain.getAssetDescription(assetId);
    if (response == null) throw Exception();

    final clean = AssetDescriptionClean(
        name: response.name,
        symbol: response.symbol,
        assetId: response.assetId,
        denomination: response.denomination);
    assetCache[assetId] = clean;
    return clean;
  } catch (e) {
    throw Exception("Asset $assetId} does not exist.");
  }
}

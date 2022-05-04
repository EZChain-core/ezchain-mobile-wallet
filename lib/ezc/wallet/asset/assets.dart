import 'package:wallet/ezc/sdk/apis/avm/model/get_asset_description.dart';
import 'package:wallet/ezc/wallet/asset/types.dart';
import 'package:wallet/ezc/wallet/network/network.dart';

AssetCache assetCache = {};

AssetDescriptionClean getAssetDescriptionSync(String assetId) {
  final cache = assetCache[assetId];
  if (cache == null) throw Exception("Asset $assetId does not exist.");
  return cache;
}

Future<AssetDescriptionClean> getAssetDescription(String assetId) async {
  final cache = assetCache[assetId];
  if (cache != null) return cache;
  try {
    final GetAssetDescriptionResponse response;
    try {
      response = await xChain.getAssetDescription(assetId);
    } catch (e) {
      throw Exception("Can not getAssetDescription by $assetId");
    }
    final clean = AssetDescriptionClean(
      response.name,
      response.symbol,
      response.assetId,
      response.denomination,
    );
    assetCache[assetId] = clean;
    return clean;
  } catch (e) {
    throw Exception("Asset $assetId does not exist.");
  }
}

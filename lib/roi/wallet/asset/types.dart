typedef AssetCache = Map<String, AssetDescriptionClean>;

class AssetDescriptionClean {
  final String name;
  final String symbol;
  final String assetId;
  final String denomination;

  AssetDescriptionClean(
      {required this.name,
      required this.symbol,
      required this.assetId,
      required this.denomination});
}

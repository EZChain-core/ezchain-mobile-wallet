typedef AssetCache = Map<String, AssetDescriptionClean>;

class AssetDescriptionClean {
  final String name;
  final String symbol;
  final String assetId;
  final String denomination;

  AssetDescriptionClean(
    this.name,
    this.symbol,
    this.assetId,
    this.denomination,
  );
}

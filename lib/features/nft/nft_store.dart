import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/utils/payload.dart';
import 'package:wallet/ezc/wallet/asset/types.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/nft/collectible/nft_collectible_item.dart';
import 'package:wallet/features/nft/family/nft_family_item.dart';

part 'nft_store.g.dart';

class NftStore = _NftStore with _$NftStore;

abstract class _NftStore with Store {
  final _tokenStore = getIt<TokenStore>();

  @observable
  String keySearch = '';

  @computed
  ObservableList<NftFamilyItem> get nftAssetsResult => keySearch.isEmpty
      ? nftAssetsTotal
      : ObservableList.of(nftAssetsTotal
          .where((element) =>
              element.name.toLowerCase().contains(keySearch.toLowerCase()) ||
              element.symbol.toLowerCase().contains(keySearch.toLowerCase()) ||
              element.id.contains(keySearch))
          .toList());

  @computed
  ObservableList<NftFamilyItem> get nftAssetsTotal =>
      ObservableList.of(erc721NftAssets)..addAll(nftAssets);

  @computed
  ObservableList<NftFamilyItem> get nftAssets => ObservableList.of(
        _tokenStore.nftCollectibles.map(
          (nftCollectible) {
            List<NftCollectibleItem> collectibles = [];
            nftCollectible.groupIdPayloadDict.forEach((groupId, payload) {
              GenericNft? genericNft;
              if (payload is JSONPayload) {
                try {
                  final json = payload.getContentType();
                  genericNft = GenericFormType.fromJson(json).avalanche;
                } catch (e) {
                  logger.e(e);
                }
              }

              final title = genericNft?.title;
              //ignore: unused_local_variable
              final desc = genericNft?.desc;
              final payloadTypeName = payload.getTypeName() ?? "Unknown Type";
              final payloadContent = payload.getContentType().toString();
              String? url;
              if (payload is URLPayload) {
                url = payloadContent;
              } else if (payload is JSONPayload) {
                url = genericNft?.img;
              }
              collectibles.add(
                NftCollectibleItem(
                    groupId,
                    nftCollectible.groupIdNFTUTXOsDict,
                    nftCollectible.groupIdNFTUTXOsDict[groupId]?.length ?? 0,
                    getNftPayloadType(payloadTypeName),
                    title,
                    url,
                    payloadContent),
              );
            });
            return NftFamilyItem(
              id: nftCollectible.asset.assetId,
              name: nftCollectible.asset.name,
              symbol: nftCollectible.asset.symbol,
              isMintable: nftCollectible.canMint,
              nftMintUTXO: nftCollectible.nftMintUTXO,
              nftCollectibles: collectibles,
            );
          },
        ),
      );

  @computed
  ObservableList<NftFamilyItem> get erc721NftAssets => ObservableList.of(
        _tokenStore.erc721Tokens.map(
          (nftCollectible) {
            List<NftCollectibleItem> collectibles = [];
            nftCollectible.cachedMetadata.forEach((key, value) {
              collectibles.add(
                NftCollectibleItem(0, {}, 1, NftPayloadType.json, value.name,
                    value.uri, value.description),
              );
            });

            return NftFamilyItem(
              id: nftCollectible.contractAddress,
              name: nftCollectible.name,
              symbol: nftCollectible.symbol,
              isMintable: false,
              nftMintUTXO: null,
              nftCollectibles: collectibles,
            );
          },
        ),
      );
}

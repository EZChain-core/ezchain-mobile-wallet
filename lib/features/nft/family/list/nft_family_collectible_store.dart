import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/store/token_store.dart';

import '../../family/list/nft_family_collectible_item.dart';

part 'nft_family_collectible_store.g.dart';

class NftFamilyCollectibleStore = _NftFamilyCollectibleStore
    with _$NftFamilyCollectibleStore;

abstract class _NftFamilyCollectibleStore with Store {
  final _tokenStore = getIt<TokenStore>();

  @computed
  ObservableList<NftFamilyCollectibleItem> get nftAssets => ObservableList.of(
      _tokenStore.nftFamilies.map((nftFamily) => NftFamilyCollectibleItem(
            id: nftFamily.asset.assetId,
            name: nftFamily.asset.name,
            symbol: nftFamily.asset.symbol,
            quantity: nftFamily.quantity,
            imageUrl: nftFamily.genericNft?.img,
            nftMintUTXO: nftFamily.nftMintUTXO,
          )));
}

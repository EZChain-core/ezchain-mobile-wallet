import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/nft/family/list/nft_family_item.dart';

part 'nft_store.g.dart';

class NftStore = _NftStore with _$NftStore;

abstract class _NftStore with Store {
  final _tokenStore = getIt<TokenStore>();

  @computed
  ObservableList<NftFamilyItem> get nftAssets => ObservableList.of(
      _tokenStore.nftFamilies.map((nftFamily) => NftFamilyItem(
            id: nftFamily.asset.assetId,
            name: nftFamily.asset.name,
            symbol: nftFamily.asset.symbol,
            groupId: nftFamily.groupId,
            imageUrl: nftFamily.firstGenericNft?.img,
            nftMintUTXO: nftFamily.nftMintUTXO,
          )));
}

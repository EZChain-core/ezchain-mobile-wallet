import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/features/common/wallet_factory.dart';

import '../../family/list/nft_family_collectible_item.dart';

part 'nft_family_collectible_store.g.dart';

class NftFamilyCollectibleStore = _NftFamilyCollectibleStore
    with _$NftFamilyCollectibleStore;

abstract class _NftFamilyCollectibleStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  _NftFamilyCollectibleStore() {
    _fetchNftAssets();
  }

  @readonly
  ObservableList<NftFamilyCollectibleItem> _nftAssets = ObservableList.of([]);

  @action
  _fetchNftAssets() {
    final assetUtxoMap = <String, AvmUTXO>{};
    for (final utxo in _wallet.utxosX.utxos.values) {
      assetUtxoMap[cb58Encode(utxo.assetId)] = utxo;
    }

    final assets = _wallet.getUnknownAssets().where((element) {
      final utxo = assetUtxoMap[element.assetId];
      final outputId = utxo?.output.getOutputId();
      return outputId == NFTMINTOUTPUTID;
    }).toList();

    final items = assets
        .map((e) => NftFamilyCollectibleItem(e.assetId, e.name, e.symbol, 2,
            'https://image-us.24h.com.vn/upload/1-2022/images/2022-01-14/2-1642144948-385-width650height812.jpg'))
        .toList();
    _nftAssets = ObservableList.of(items);
  }
}

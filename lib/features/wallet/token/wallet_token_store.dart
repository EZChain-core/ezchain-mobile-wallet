import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/wallet/asset/types.dart';
import 'package:wallet/ezc/wallet/network/utils.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';

part 'wallet_token_store.g.dart';

class WalletTokenStore = _WalletTokenStore with _$WalletTokenStore;

abstract class _WalletTokenStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();

  BigInt get _stakedBN => numberToBNAvaxP(_balanceStore.staking.toDouble());

  BigInt get _lockedP =>
      numberToBNAvaxP(_balanceStore.balanceLockedP.toDouble());

  BigInt get _unlockedP => numberToBNAvaxP(_balanceStore.balanceP.toDouble());

  BigInt get _lockedStakeableP =>
      numberToBNAvaxP(_balanceStore.balanceLockedStakeableP.toDouble());

  @computed
  String get tokenBalance {
    Decimal total = Decimal.zero;
    for (var element in tokens) {
      total += (element.amount * element.price);
    }
    return total.text(decimals: 1);
  }

  @computed
  Decimal get ezcPrice => _priceStore.avaxPrice;

  @computed
  List<WalletTokenItem> get tokens {
    logger.e('vit isTotalLoaded ${_balanceStore.isTotalLoaded}');
    if (_balanceStore.isTotalLoaded) {
      return fetchAssets();
    } else {
      return [];
    }
  }

  @action
  refresh() async {
    _priceStore.updateAvaxPrice();
    _balanceStore.updateTotalBalance();
  }

  List<WalletTokenItem> fetchAssets() {
    List<WalletTokenItem> list = [];
    final avaAssetId = getAvaxAssetId();

    // cần xử lý lại để shared với hàm mintNFT và mỗi khi update lại utxosX
    final assetUtxoMap = <String, AvmUTXO>{};
    for (final utxo in _wallet.utxosX.utxos.values) {
      assetUtxoMap[cb58Encode(utxo.assetId)] = utxo;
    }
    // cần xử lý lại để shared với hàm mintNFT và mỗi khi update lại utxosX
    final assets = _wallet.getUnknownAssets().where((element) {
      final output = assetUtxoMap[element.assetId]?.getOutput();
      return output?.getOutputId() == SECPXFEROUTPUTID;
    }).map((asset) {
      final avaAsset = AvaAsset(
        id: asset.assetId,
        name: asset.name,
        symbol: asset.symbol,
        denomination: int.tryParse(asset.denomination) ?? 0,
      );

      final balanceDict = _wallet.getBalanceX();
      final balanceAmt = balanceDict[avaAsset.id];
      if (balanceAmt == null) {
        avaAsset.resetBalance();
      } else {
        avaAsset.resetBalance();
        avaAsset.addBalance(balanceAmt.unlocked);
        avaAsset.addBalanceLocked(balanceAmt.locked);
      }

      // Add extras for AVAX token
      if (avaAsset.id == avaAssetId) {
        avaAsset.addExtra(_stakedBN);
        avaAsset.addExtra(_unlockedP);
        avaAsset.addExtra(_lockedP);
        avaAsset.addExtra(_lockedStakeableP);
      }
      return avaAsset;
    }).toList();

    assets.customSort(avaAssetId);

    for (var element in assets) {
      final isEzc = element.id == avaAssetId;
      if (isEzc) continue;
      const type = 'X-Chain';
      final amountText = element.toString();
      final amount = element.getAmount();
      list.add(WalletTokenItem(element.id, '', element.name, element.symbol,
          amount, ezcPrice, amountText, type));
    }
    return list;
  }
}

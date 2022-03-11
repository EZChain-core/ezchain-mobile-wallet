import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';
import 'package:wallet/ezc/wallet/asset/types.dart';
import 'package:wallet/ezc/wallet/network/utils.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

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

    final assets = _wallet.getUnknownAssets().map((asset) {
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
      final type = isEzc ? 'XChain' : null;
      final amountText = isEzc ? _balanceStore.totalEzc.text(decimals: 9) : element.toString();
      final amount = isEzc ? _balanceStore.totalEzc : element.getAmount();
      list.add(WalletTokenItem('', element.name, element.symbol,
          amount, ezcPrice, amountText, type));
    }
    logger.e('vit tokens length ${list.length}');
    return list;
  }
}

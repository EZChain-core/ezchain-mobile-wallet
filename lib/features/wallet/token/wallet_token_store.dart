import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/wallet/token/wallet_token.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';
import 'package:wallet/roi/wallet/asset/types.dart';
import 'package:wallet/roi/wallet/network/utils.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

part 'wallet_token_store.g.dart';

class WalletTokenStore = _WalletTokenStore with _$WalletTokenStore;

abstract class _WalletTokenStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();

  BigInt get _stakedBN => numberToBNAvaxP(_balanceStore.staking.toDouble());

  BigInt get _lockedX =>
      numberToBNAvaxX(_balanceStore.balanceLockedX.toDouble());

  BigInt get _unlockedX => numberToBNAvaxX(_balanceStore.balanceX.toDouble());

  BigInt get _lockedP =>
      numberToBNAvaxP(_balanceStore.balanceLockedP.toDouble());

  BigInt get _unlockedP => numberToBNAvaxP(_balanceStore.balanceP.toDouble());

  BigInt get _lockedStakeableP =>
      numberToBNAvaxP(_balanceStore.balanceLockedStakeableP.toDouble());

  @computed
  Decimal get ezcPrice => _priceStore.avaxPrice;

  @computed
  List<WalletTokenItem> get tokens {
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
    test();
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

      avaAsset.resetBalance();
      avaAsset.addBalance(_unlockedX);
      avaAsset.addBalanceLocked(_lockedX);

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
    var stringAssets = "\n";

    for (var element in assets) {
      stringAssets +=
          "isEZC = ${element.id == avaAssetId}, name = ${element.name}, symbol = ${element.symbol}, amount = ${element.toString()}\n";

      list.add(WalletTokenItem('', element.name, element.symbol,
          element.getAmount(), ezcPrice, element.toString()));
    }
    logger.i(stringAssets);

    return list;
  }

  test() async {
    final avaAssetId = getAvaxAssetId();
    final stake = await _wallet
        .getStake(); // <-- cho mục đích ví dụ, impl có thể phải cần thiết kế để shared
    // cần thiết kế để lắng nghe khi update đc utxosX thì mới map data
    final balanceDict = _wallet.getBalanceX();
    final assets = _wallet.getUnknownAssets().map((asset) {
      final avaAsset = AvaAsset(
        id: asset.assetId,
        name: asset.name,
        symbol: asset.symbol,
        denomination: int.tryParse(asset.denomination) ?? 0,
      );

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
        final balanceP = _wallet.getBalanceP();
        avaAsset.addExtra(stake.stakedBN);
        avaAsset.addExtra(balanceP.unlocked);
        avaAsset.addExtra(balanceP.locked);
        avaAsset.addExtra(balanceP.lockedStakeable);
      }
      return avaAsset;
    }).toList();

    assets.customSort(avaAssetId);

    var stringAssets = "\n";
    for (var element in assets) {
      stringAssets +=
          "isEZC = ${element.id == avaAssetId}, name = ${element.name}, symbol = ${element.symbol}, amount = ${element.toString()}\n";
    }

    logger.i(stringAssets);
  }
}

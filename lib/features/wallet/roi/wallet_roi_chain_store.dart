import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

part 'wallet_roi_chain_store.g.dart';

class WalletRoiChainStore = _WalletRoiChainStore with _$WalletRoiChainStore;

abstract class _WalletRoiChainStore with Store {
  final wallet = getIt<WalletFactory>().activeWallet;

  BalanceStore get balanceStore => getIt<BalanceStore>();

  PriceStore get priceStore => getIt<PriceStore>();

  @computed
  WalletRoiChainBalanceViewData get balanceX => WalletRoiChainBalanceViewData(
      balanceStore.balanceX, balanceStore.balanceLockedX, null);

  @computed
  WalletRoiChainBalanceViewData get balanceP => WalletRoiChainBalanceViewData(
      balanceStore.balanceP,
      balanceStore.balanceLockedP,
      balanceStore.balanceLockedStakeableP);

  @computed
  WalletRoiChainBalanceViewData get balanceC =>
      WalletRoiChainBalanceViewData(balanceStore.balanceC, null, null);

  @computed
  String get totalRoi =>
      decimalToLocaleString(balanceStore.totalRoi, decimals: 2);

  @computed
  String get totalUsd {
    final totalUsdNumber = balanceStore.totalRoi * priceStore.avaxPrice;
    return decimalToLocaleString(totalUsdNumber, decimals: 2);
  }

  String get addressX => wallet.getAddressX();

  String get addressP => wallet.getAddressP();

  String get addressC => wallet.getAddressC();

  @action
  fetchData() async {
    priceStore.updateAvaxPrice();
    balanceStore.updateTotalBalance();
  }

  @action
  refresh() async {
    balanceStore.updateTotalBalance();
  }
}

class WalletRoiChainBalanceViewData {
  final Decimal available;
  final Decimal? lock;
  final Decimal? lockStakeable;

  get availableString =>
      decimalToLocaleString(available, decimals: decimalNumber);

  get lockString =>
      decimalToLocaleString(lock ?? Decimal.zero, decimals: decimalNumber);

  get lockStakeableString =>
      decimalToLocaleString(lockStakeable ?? Decimal.zero,
          decimals: decimalNumber);

  WalletRoiChainBalanceViewData(this.available, this.lock, this.lockStakeable);
}

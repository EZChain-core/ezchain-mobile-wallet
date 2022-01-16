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
  final _wallet = getIt<WalletFactory>().activeWallet;

  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();

  @computed
  WalletRoiChainBalanceViewData get balanceX => WalletRoiChainBalanceViewData(
      _balanceStore.balanceX, _balanceStore.balanceLockedX, null);

  @computed
  WalletRoiChainBalanceViewData get balanceP => WalletRoiChainBalanceViewData(
      _balanceStore.balanceP,
      _balanceStore.balanceLockedP,
      _balanceStore.balanceLockedStakeableP);

  @computed
  WalletRoiChainBalanceViewData get balanceC =>
      WalletRoiChainBalanceViewData(_balanceStore.balanceC, null, null);

  @computed
  String get totalRoi =>
      decimalToLocaleString(_balanceStore.totalRoi, decimals: decimalNumber);

  @computed
  String get totalUsd {
    final totalUsdNumber = _balanceStore.totalRoi * _priceStore.avaxPrice;
    return decimalToLocaleString(totalUsdNumber, decimals: decimalNumber);
  }

  String get addressX => _wallet.getAddressX();

  String get addressP => _wallet.getAddressP();

  String get addressC => _wallet.getAddressC();

  @action
  fetchData() async {
    _priceStore.updateAvaxPrice();
    _balanceStore.updateTotalBalance();
  }

  @action
  refresh() async {
    _balanceStore.updateTotalBalance();
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

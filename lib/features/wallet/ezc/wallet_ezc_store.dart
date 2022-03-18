import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/store/price_store.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/common/store/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

part 'wallet_ezc_store.g.dart';

class WalletEZCStore = _WalletEZCStore with _$WalletEZCStore;

abstract class _WalletEZCStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();
  final _tokenStore = getIt<TokenStore>();
  final _validatorsStore = getIt<ValidatorsStore>();

  @computed
  WalletEZCBalanceViewData get balanceX => WalletEZCBalanceViewData(
      _balanceStore.balanceX, _balanceStore.balanceLockedX);

  @computed
  WalletEZCBalanceViewData get balanceP => WalletEZCBalanceViewData(
      _balanceStore.balanceP,
      _balanceStore.balanceLockedP,
      _balanceStore.balanceLockedStakeableP);

  @computed
  WalletEZCBalanceViewData get balanceC =>
      WalletEZCBalanceViewData(_balanceStore.balanceC);

  @computed
  String get totalEzc =>
      decimalToLocaleString(_balanceStore.totalEzc, decimals: decimalNumber);

  @computed
  String get staking =>
      decimalToLocaleString(_balanceStore.staking, decimals: decimalNumber);

  @computed
  String get totalUsd {
    final totalUsdNumber = _balanceStore.totalEzc * _priceStore.avaxPrice;
    return decimalToLocaleString(totalUsdNumber, decimals: decimalNumber);
  }

  String get addressX => _wallet.getAddressX();

  String get addressP => _wallet.getAddressP();

  String get addressC => _wallet.getAddressC();

  @action
  fetchData() async {
    _balanceStore.init();
    _priceStore.updateAvaxPrice();
    _tokenStore.getErc20Tokens();
    _validatorsStore.updateValidators();
  }

  @action
  refresh() async {
    _balanceStore.updateTotalBalance();
  }
}

class WalletEZCBalanceViewData {
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

  WalletEZCBalanceViewData(this.available, [this.lock, this.lockStakeable]);
}

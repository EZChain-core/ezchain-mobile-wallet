import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/store/price_store.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/common/store/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

part 'wallet_ezc_store.g.dart';

class WalletEZCStore = _WalletEZCStore with _$WalletEZCStore;

abstract class _WalletEZCStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

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
  String get totalEzc => _balanceStore.totalEzc.toLocaleString(decimals: 3);

  @computed
  String get staking => _balanceStore.staking.toLocaleString(decimals: 3);

  @computed
  String get totalUsd {
    final totalUsdNumber = _balanceStore.totalEzc * _priceStore.ezcPrice;
    return totalUsdNumber.toLocaleString(decimals: 3);
  }

  String get addressX => _wallet.getAddressX();

  String get addressP => _wallet.getAddressP();

  String get addressC => _wallet.getAddressC();

  @action
  fetchData() async {
    _balanceStore.init();
    _priceStore.updatePrice();
    _tokenStore.getErc20Tokens();
    _tokenStore.getErc721Tokens();
    _validatorsStore.fetch();
  }

  @action
  refresh() async {
    _balanceStore.updateBalance();
  }
}

class WalletEZCBalanceViewData {
  final Decimal available;
  final Decimal? lock;
  final Decimal? lockStakeable;

  get availableString => available.toLocaleString(decimals: 3);

  get lockString => (lock ?? Decimal.zero).toLocaleString(decimals: 3);

  get lockStakeableString =>
      (lockStakeable ?? Decimal.zero).toLocaleString(decimals: 3);

  WalletEZCBalanceViewData(this.available, [this.lock, this.lockStakeable]);
}

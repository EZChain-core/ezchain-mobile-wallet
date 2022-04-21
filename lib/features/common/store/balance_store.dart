import 'package:decimal/decimal.dart';
import 'package:eventify/eventify.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/type/ezc_type.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/ezc/wallet/network/utils.dart';
import 'package:wallet/ezc/wallet/types.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

part 'balance_store.g.dart';

const decimalNumber = 3;

@LazySingleton()
class BalanceStore = _BalanceStore with _$BalanceStore;

abstract class _BalanceStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  final _tokenStore = getIt<TokenStore>();

  @readonly
  Decimal _totalEzc = Decimal.zero;

  @readonly
  Decimal _staking = Decimal.zero;

  @readonly
  Decimal _balanceX = Decimal.zero;

  @readonly
  Decimal _balanceP = Decimal.zero;

  @readonly
  Decimal _balanceC = Decimal.zero;

  @readonly
  Decimal _balanceLockedX = Decimal.zero;

  @readonly
  Decimal _balanceLockedP = Decimal.zero;

  @readonly
  Decimal _balanceLockedStakeableP = Decimal.zero;

  @readonly
  bool _isTotalLoaded = false;

  bool _isXLoaded = false;
  bool _isPLoaded = false;
  bool _isCLoaded = false;
  bool _needFetchTotal = false;

  String get balanceXString => decimalBalance(_balanceX);

  String get balanceCString => decimalBalance(_balanceC);

  String get balancePString => decimalBalance(_balanceP);

  init() {
    _wallet.on(WalletEventType.balanceChangedX, _handleCallback);
    _wallet.on(WalletEventType.balanceChangedP, _handleCallback);
    _wallet.on(WalletEventType.balanceChangedC, _handleCallback);
    updateTotalBalance();
  }

  @action
  dispose() {
    _wallet.off(WalletEventType.balanceChangedX, _handleCallback);
    _wallet.off(WalletEventType.balanceChangedP, _handleCallback);
    _wallet.off(WalletEventType.balanceChangedC, _handleCallback);
    _totalEzc = Decimal.zero;
    _staking = Decimal.zero;
    _balanceX = Decimal.zero;
    _balanceP = Decimal.zero;
    _balanceC = Decimal.zero;
    _balanceLockedX = Decimal.zero;
    _balanceLockedP = Decimal.zero;
    _balanceLockedStakeableP = Decimal.zero;
    _isTotalLoaded = false;
    _isXLoaded = false;
    _isPLoaded = false;
    _isCLoaded = false;
    _needFetchTotal = false;
  }

  @action
  updateBalance() {
    updateBalanceX();
    updateBalanceP();
    updateBalanceC();
  }

  @action
  updateTotalBalance() {
    _needFetchTotal = true;
    updateBalance();
  }

  @action
  _handleCallback(Event event, Object? context) {
    final eventName = event.eventName;
    final eventData = event.eventData;
    if (eventName == WalletEventType.balanceChangedX.type &&
        eventData is WalletBalanceX) {
      final x = eventData[getAvaxAssetId()];
      if (x != null) {
        _tokenStore.getAvaAssets();
        _balanceX = bnToDecimalAvaxX(x.unlocked);
        _balanceLockedX = bnToDecimalAvaxX(x.locked);
        if (_needFetchTotal) {
          _isXLoaded = true;
        }
      }
    }
    if (eventName == WalletEventType.balanceChangedP.type &&
        eventData is AssetBalanceP) {
      _balanceP = bnToDecimalAvaxP(eventData.unlocked);
      _balanceLockedP = bnToDecimalAvaxP(eventData.locked);
      _balanceLockedStakeableP = bnToDecimalAvaxP(eventData.lockedStakeable);
      if (_needFetchTotal) {
        _isPLoaded = true;
      }
    }
    if (eventName == WalletEventType.balanceChangedC.type &&
        eventData is WalletBalanceC) {
      _balanceC = bnToDecimalAvaxC(eventData.balance);
      if (_needFetchTotal) {
        _isCLoaded = true;
      }
    }
    if (_needFetchTotal && _isXLoaded && _isPLoaded && _isCLoaded) {
      _isXLoaded = false;
      _isPLoaded = false;
      _isCLoaded = false;
      _needFetchTotal = false;
      _fetchTotal();
    }
  }

  updateBalanceX() async {
    try {
      await _wallet.updateUtxosX();
    } catch (e) {
      logger.e(e);
    }
  }

  updateBalanceP() async {
    try {
      await _wallet.updateUtxosP();
    } catch (e) {
      logger.e(e);
    }
  }

  updateBalanceC() async {
    try {
      await _wallet.updateAvaxBalanceC();
    } catch (e) {
      logger.e(e);
      return;
    }
  }

  @action
  updateStake() async {
    final staked = await _wallet.getStake();
    _staking = bnToDecimalAvaxP(staked.stakedBN);
  }

  Decimal getBalance(EZCType chain) {
    switch (chain) {
      case EZCType.xChain:
        return _balanceX;
      case EZCType.pChain:
        return _balanceP;
      case EZCType.cChain:
        return _balanceC;
    }
  }

  String getBalanceText(EZCType chain) {
    switch (chain) {
      case EZCType.xChain:
        return balanceXString;
      case EZCType.pChain:
        return balancePString;
      case EZCType.cChain:
        return balanceCString;
    }
  }

  @action
  _fetchTotal() async {
    final avaxBalance = _wallet.getAvaxBalance();
    final totalAvaxBalanceDecimal = avaxBalance.totalDecimal;

    await updateStake();

    _totalEzc = totalAvaxBalanceDecimal + _staking;
    _isTotalLoaded = true;
  }

  String decimalBalance(Decimal balance) {
    return decimalToLocaleString(balance, decimals: decimalNumber);
  }
}

extension DecimalExtension on Decimal {
  String text({int decimals = decimalNumber}) {
    return decimalToLocaleString(this, decimals: decimals);
  }
}

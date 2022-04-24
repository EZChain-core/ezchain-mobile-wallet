import 'dart:async';

import 'package:async/async.dart';
import 'package:decimal/decimal.dart';
import 'package:eventify/eventify.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_stake.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/type/ezc_type.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/ezc/wallet/network/utils.dart';
import 'package:wallet/ezc/wallet/types.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

part 'balance_store.g.dart';

@LazySingleton()
class BalanceStore = _BalanceStore with _$BalanceStore;

abstract class _BalanceStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  final _tokenStore = getIt<TokenStore>();

  @readonly
  Decimal _totalEzcWithoutStaking = Decimal.zero;

  @readonly
  Decimal _staking = Decimal.zero;

  @computed
  Decimal get totalEzc => _totalEzcWithoutStaking + _staking;

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

  String get balanceXString => _decimalBalance(_balanceX);

  String get balanceCString => _decimalBalance(_balanceC);

  String get balancePString => _decimalBalance(_balanceP);

  CancelableCompleter? _updateBalanceXCompleter;
  CancelableCompleter? _updateBalancePCompleter;
  CancelableCompleter? _updateBalanceCCompleter;
  CancelableCompleter<GetStakeResponse>? _updateStakeCompleter;

  Timer? _timer;

  init() {
    _wallet.on(WalletEventType.balanceChangedX, _handleCallback);
    _wallet.on(WalletEventType.balanceChangedP, _handleCallback);
    _wallet.on(WalletEventType.balanceChangedC, _handleCallback);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (timer.isActive) {
        updateBalance();
      }
    });
    updateBalance();
  }

  @action
  dispose() {
    _timer?.cancel();
    _updateBalanceXCompleter?.operation.cancel();
    _updateBalancePCompleter?.operation.cancel();
    _updateBalanceCCompleter?.operation.cancel();
    _updateStakeCompleter?.operation.cancel();
    _wallet.off(WalletEventType.balanceChangedX, _handleCallback);
    _wallet.off(WalletEventType.balanceChangedP, _handleCallback);
    _wallet.off(WalletEventType.balanceChangedC, _handleCallback);
    _totalEzcWithoutStaking = Decimal.zero;
    _staking = Decimal.zero;
    _balanceX = Decimal.zero;
    _balanceP = Decimal.zero;
    _balanceC = Decimal.zero;
    _balanceLockedX = Decimal.zero;
    _balanceLockedP = Decimal.zero;
    _balanceLockedStakeableP = Decimal.zero;
  }

  updateBalance() {
    updateBalanceX();
    updateBalanceP();
    updateBalanceC();
    updateStake();
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
        _balanceX = x.unlocked.toDecimalAvaxX();
        _balanceLockedX = x.locked.toDecimalAvaxX();
      }
    }
    if (eventName == WalletEventType.balanceChangedP.type &&
        eventData is AssetBalanceP) {
      _balanceP = eventData.unlocked.toDecimalAvaxP();
      _balanceLockedP = eventData.locked.toDecimalAvaxP();
      _balanceLockedStakeableP = eventData.lockedStakeable.toDecimalAvaxP();
    }
    if (eventName == WalletEventType.balanceChangedC.type &&
        eventData is WalletBalanceC) {
      _balanceC = eventData.balance.toDecimalAvaxC();
    }
    final avaxBalance = _wallet.getAvaxBalance();
    _totalEzcWithoutStaking = avaxBalance.totalDecimal;
  }

  updateBalanceX() {
    if (_updateBalanceXCompleter == null ||
        _updateBalanceXCompleter?.isCompleted == true) {
      _updateBalanceXCompleter = CancelableCompleter();
      _updateBalanceXCompleter?.operation.value.then((value) {}, onError: (e) {
        logger.e(e);
      });
      _updateBalanceXCompleter?.complete(_wallet.updateUtxosX());
    }
  }

  updateBalanceP() {
    if (_updateBalancePCompleter == null ||
        _updateBalancePCompleter?.isCompleted == true) {
      _updateBalancePCompleter = CancelableCompleter();
      _updateBalancePCompleter?.operation.value.then((value) {}, onError: (e) {
        logger.e(e);
      });
      _updateBalancePCompleter?.complete(_wallet.updateUtxosP());
    }
  }

  updateBalanceC() {
    if (_updateBalanceCCompleter == null ||
        _updateBalanceCCompleter?.isCompleted == true) {
      _updateBalanceCCompleter = CancelableCompleter();
      _updateBalanceCCompleter?.operation.value.then((value) {}, onError: (e) {
        logger.e(e);
      });
      _updateBalanceCCompleter?.complete(_wallet.updateAvaxBalanceC());
    }
  }

  @action
  updateStake() {
    if (_updateStakeCompleter == null ||
        _updateStakeCompleter?.isCompleted == true) {
      _updateStakeCompleter = CancelableCompleter();
      _updateStakeCompleter?.operation.value.then((value) {
        _staking = value.stakedBN.toDecimalAvaxP();
      }, onError: (e) {
        logger.e(e);
      });
      _updateStakeCompleter?.complete(_wallet.getStake());
    }
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

  String _decimalBalance(Decimal balance) {
    return balance.toLocaleString(decimals: 3);
  }
}

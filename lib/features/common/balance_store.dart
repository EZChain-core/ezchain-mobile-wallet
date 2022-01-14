import 'package:decimal/decimal.dart';
import 'package:eventify/eventify.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/types.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

part 'balance_store.g.dart';

const decimalNumber = 3;

@LazySingleton()
class BalanceStore = _BalanceStore with _$BalanceStore;

abstract class _BalanceStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  @observable
  Decimal totalRoi = Decimal.zero;

  @observable
  Decimal balanceX = Decimal.zero;

  @observable
  Decimal balanceP = Decimal.zero;

  @observable
  Decimal balanceC = Decimal.zero;

  @observable
  Decimal balanceLockedX = Decimal.zero;

  @observable
  Decimal balanceLockedP = Decimal.zero;

  @observable
  Decimal balanceLockedStakeableP = Decimal.zero;

  bool _isXLoaded = false;
  bool _isPLoaded = false;
  bool _isCLoaded = false;
  bool _needFetchTotal = false;

  String get balanceXString => _decimalBalance(balanceX);

  String get balanceCString => _decimalBalance(balanceC);

  String get balancePString => _decimalBalance(balanceP);

  _BalanceStore() {
    init();
  }

  init() {
    _wallet.on(WalletEventType.balanceChangedX, _handleCallback);
    _wallet.on(WalletEventType.balanceChangedP, _handleCallback);
    _wallet.on(WalletEventType.balanceChangedC, _handleCallback);
    updateBalance();
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

  _handleCallback(Event event, Object? context) async {
    final eventName = event.eventName;
    final eventData = event.eventData;
    if (eventName == WalletEventType.balanceChangedX.type &&
        eventData is WalletBalanceX) {
      final x = eventData[activeNetwork.avaxId];
      if (x != null) {
        balanceX = bnToDecimalAvaxX(x.unlocked);
        balanceLockedX = bnToDecimalAvaxX(x.locked);
        if (_needFetchTotal) {
          _isXLoaded = true;
        }
      }
    }
    if (eventName == WalletEventType.balanceChangedP.type &&
        eventData is AssetBalanceP) {
      balanceP = bnToDecimalAvaxP(eventData.unlocked);
      balanceLockedP = bnToDecimalAvaxP(eventData.locked);
      balanceLockedStakeableP = bnToDecimalAvaxP(eventData.lockedStakeable);
      if (_needFetchTotal) {
        _isPLoaded = true;
      }
    }
    if (eventName == WalletEventType.balanceChangedC.type &&
        eventData is WalletBalanceC) {
      balanceC = bnToDecimalAvaxC(eventData.balance);
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
      print(e);
    }
  }

  updateBalanceP() async {
    try {
      await _wallet.updateUtxosP();
    } catch (e) {
      print(e);
    }
  }

  updateBalanceC() async {
    try {
      await _wallet.updateAvaxBalanceC();
    } catch (e) {
      print(e);
      return;
    }
  }

  _fetchTotal() async {
    final avaxBalance = _wallet.getAvaxBalance();
    final totalAvaxBalanceDecimal = avaxBalance.totalDecimal;

    final staked = await _wallet.getStake();
    final stakedDecimal = bnToDecimalAvaxP(staked.stakedBI);

    totalRoi = totalAvaxBalanceDecimal + stakedDecimal;
  }

  String _decimalBalance(Decimal balance) {
    return decimalToLocaleString(balance, decimals: decimalNumber);
  }
}

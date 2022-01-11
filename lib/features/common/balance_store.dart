import 'package:decimal/decimal.dart';
import 'package:eventify/eventify.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/types.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

part 'balance_store.g.dart';

@LazySingleton()
class BalanceStore = _BalanceStore with _$BalanceStore;

abstract class _BalanceStore with Store {
  final wallet = SingletonWallet(
      privateKey:
          "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  final decimalNumber = 3;

  @observable
  Decimal totalRoi = Decimal.zero;

  @observable
  String balanceX = '0';

  @observable
  String balanceP = '0';

  @observable
  String balanceC = '0';

  @observable
  String balanceLockedX = '0';

  @observable
  String balanceLockedP = '0';

  @observable
  String balanceLockedStakeableP = '0';

  bool _isXLoaded = false;
  bool _isPLoaded = false;
  bool _isCLoaded = false;
  bool _needFetchTotal = false;

  double get balanceXDouble => _parseDouble(balanceX);

  double get balanceCDouble => _parseDouble(balanceC);

  _BalanceStore() {
    init();
  }

  init() {
    wallet.on(WalletEventType.balanceChangedX, _handleCallback);
    wallet.on(WalletEventType.balanceChangedP, _handleCallback);
    wallet.on(WalletEventType.balanceChangedC, _handleCallback);
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
        balanceX =
            decimalToLocaleString(bnToDecimalAvaxX(x.unlocked), decimals: 3);
        balanceLockedX =
            decimalToLocaleString(bnToDecimalAvaxX(x.locked), decimals: 3);
        if (_needFetchTotal) {
          _isXLoaded = true;
        }
      }
    }
    if (eventName == WalletEventType.balanceChangedP.type &&
        eventData is AssetBalanceP) {
      balanceP = decimalToLocaleString(bnToDecimalAvaxP(eventData.unlocked),
          decimals: decimalNumber);
      balanceLockedP = decimalToLocaleString(bnToDecimalAvaxP(eventData.locked),
          decimals: decimalNumber);
      balanceLockedStakeableP = decimalToLocaleString(
          bnToDecimalAvaxP(eventData.lockedStakeable),
          decimals: decimalNumber);
      if (_needFetchTotal) {
        _isPLoaded = true;
      }
    }
    if (eventName == WalletEventType.balanceChangedC.type &&
        eventData is WalletBalanceC) {
      balanceC = decimalToLocaleString(bnToDecimalAvaxC(eventData.balance),
          decimals: 3);
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
      await wallet.updateUtxosX();
    } catch (e) {
      print(e);
    }
  }

  updateBalanceP() async {
    try {
      await wallet.updateUtxosP();
    } catch (e) {
      print(e);
    }
  }

  updateBalanceC() async {
    try {
      await wallet.updateAvaxBalanceC();
    } catch (e) {
      print(e);
      return;
    }
  }

  _fetchTotal() async {
    final avaxBalance = wallet.getAvaxBalance();
    final totalAvaxBalanceDecimal = avaxBalance.totalDecimal;

    final staked = await wallet.getStake();
    final stakedDecimal = bnToDecimalAvaxP(staked.stakedBI);

    totalRoi = totalAvaxBalanceDecimal + stakedDecimal;
  }

  double _parseDouble(String balance) {
    return double.tryParse(balance) ?? 0;
  }
}

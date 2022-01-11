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

  @observable
  String balanceX = '0';

  @observable
  String balanceP = '0';

  @observable
  String balanceC = '0';

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

  _handleCallback(Event event, Object? context) async {
    final eventName = event.eventName;
    final eventData = event.eventData;
    if (eventName == WalletEventType.balanceChangedX.type &&
        eventData is WalletBalanceX) {
      final x = eventData[activeNetwork.avaxId];
      if (x != null) {
        balanceX =
            decimalToLocaleString(bnToDecimalAvaxX(x.unlocked), decimals: 3);
      }
    }
    if (eventName == WalletEventType.balanceChangedP.type &&
        eventData is AssetBalanceP) {
      balanceP = decimalToLocaleString(bnToDecimalAvaxP(eventData.unlocked),
          decimals: 3);
    }
    if (eventName == WalletEventType.balanceChangedC.type &&
        eventData is WalletBalanceC) {
      balanceC = decimalToLocaleString(bnToDecimalAvaxC(eventData.balance),
          decimals: 3);
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

  double _parseDouble(String balance) {
    return double.tryParse(balance) ?? 0;
  }
}

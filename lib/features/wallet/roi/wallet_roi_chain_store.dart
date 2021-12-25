import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/types.dart';

part 'wallet_roi_chain_store.g.dart';

class WalletRoiChainStore = _WalletRoiChainStore with _$WalletRoiChainStore;

abstract class _WalletRoiChainStore with Store {
  final wallet = SingletonWallet(
      privateKey:
          "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  @observable
  WalletRoiChainBalanceViewData balanceX =
      WalletRoiChainBalanceViewData('0', '0');

  @observable
  WalletRoiChainBalanceViewData balanceP =
      WalletRoiChainBalanceViewData('0', '0');

  @observable
  WalletRoiChainBalanceViewData balanceC =
      WalletRoiChainBalanceViewData('0', '0');

  @action
  getBalanceX() async {
    wallet.on(WalletEventType.balanceChangedX, (event, context) {
      final eventName = event.eventName;
      final eventData = event.eventData;
      if (eventName == WalletEventType.balanceChangedX.type &&
          eventData is WalletBalanceX) {
        eventData.forEach((k, balance) => balanceX =
            WalletRoiChainBalanceViewData(
                balance.unlockedDecimal, balance.lockedDecimal));
      }
    });
    await wallet.updateUtxosX();

    wallet.on(WalletEventType.balanceChangedP, (event, context) {
      final eventName = event.eventName;
      final eventData = event.eventData;
      if (eventName == WalletEventType.balanceChangedP.type &&
          eventData is AssetBalanceP) {
        balanceP = WalletRoiChainBalanceViewData(
            eventData.unlockedDecimal, eventData.lockedDecimal);
      }
    });
    try {
      await wallet.updateUtxosP();
    } catch (e) {
      print(e);
    }

    wallet.on(WalletEventType.balanceChangedC, (event, context) {
      final eventName = event.eventName;
      final eventData = event.eventData;
      if (eventName == WalletEventType.balanceChangedC.type &&
          eventData is WalletBalanceC) {
        balanceC = WalletRoiChainBalanceViewData(eventData.balanceDecimal, '0');
      }
    });
    await wallet.updateAvaxBalanceC();
  }

  @action
  refresh() async {
    await wallet.updateUtxosX();
    try {
      await wallet.updateUtxosP();
    } catch (e) {
      print(e);
    }
    await wallet.updateAvaxBalanceC();
  }
}

class WalletRoiChainBalanceViewData {
  final String available;
  final String lock;

  WalletRoiChainBalanceViewData(this.available, this.lock);
}

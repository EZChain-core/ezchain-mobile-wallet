import 'package:eventify/eventify.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/types.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';
import 'package:wallet/roi/wallet/utils/price_utils.dart';

part 'wallet_roi_chain_store.g.dart';

class WalletRoiChainStore = _WalletRoiChainStore with _$WalletRoiChainStore;

abstract class _WalletRoiChainStore with Store {
  final wallet = SingletonWallet(
      privateKey:
          "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  @observable
  WalletRoiChainBalanceViewData balanceX =
      WalletRoiChainBalanceViewData('0', '0', null, false);

  @observable
  WalletRoiChainBalanceViewData balanceP =
      WalletRoiChainBalanceViewData('0', '0', '0', false);

  @observable
  WalletRoiChainBalanceViewData balanceC =
      WalletRoiChainBalanceViewData('0', null, null, false);

  @observable
  String totalRoi = "";

  @observable
  String totalUsd = "";

  String get addressX => wallet.getAddressX();

  String get addressP => wallet.getAddressP();

  String get addressC => wallet.getAddressC();

  @action
  fetchData() async {
    wallet.on(WalletEventType.balanceChangedX, _handleCallback);
    wallet.on(WalletEventType.balanceChangedP, _handleCallback);
    wallet.on(WalletEventType.balanceChangedC, _handleCallback);
    _updateX();
    _updateP();
    _updateC();
  }

  @action
  refresh() async {
    _updateX();
    _updateP();
    _updateC();
  }

  _fetchTotal() async {
    if(!balanceX.loaded || !balanceP.loaded || !balanceC.loaded) return;
    final avaxBalance = wallet.getAvaxBalance();
    final totalAvaxBalanceDecimal = avaxBalance.totalDecimal;

    final staked = await wallet.getStake();
    final stakedDecimal = bnToDecimalAvaxP(staked.stakedBI);

    final totalDecimal = totalAvaxBalanceDecimal + stakedDecimal;
    totalRoi = decimalToLocaleString(totalDecimal);

    final avaxPrice = await getAvaxPriceDecimal();

    final totalUsdNumber = totalDecimal * avaxPrice;
    totalUsd = decimalToLocaleString(totalUsdNumber, decimals: 2);
  }

  _handleCallback(Event event, Object? context) async {
    final eventName = event.eventName;
    final eventData = event.eventData;
    if (eventName == WalletEventType.balanceChangedX.type &&
        eventData is WalletBalanceX) {
      final x = eventData[activeNetwork.avaxId];
      if (x != null) {
        balanceX = WalletRoiChainBalanceViewData(
                x.unlockedDecimal, x.lockedDecimal, null, true);
      }
    }
    if (eventName == WalletEventType.balanceChangedP.type &&
        eventData is AssetBalanceP) {
      balanceP = WalletRoiChainBalanceViewData(
          eventData.unlockedDecimal, eventData.lockedDecimal, eventData.lockedStakeableDecimal, true);
    }
    if (eventName == WalletEventType.balanceChangedC.type &&
        eventData is WalletBalanceC) {
      balanceC = WalletRoiChainBalanceViewData(eventData.balanceDecimal, null, null, true);
    }

    _fetchTotal();
  }

  _updateX() async {
    try {
      await wallet.updateUtxosX();
    } catch (e) {
      print(e);
    }
  }

  _updateP() async {
    try {
      await wallet.updateUtxosP();
    } catch (e) {
      print(e);
    }
  }

  _updateC() async {
    try {
      await wallet.updateAvaxBalanceC();
    } catch (e) {
      print(e);
      return;
    }
  }
}

class WalletRoiChainBalanceViewData {
  final String available;
  final String? lock;
  final String? lockStakeable;
  final bool loaded;


  WalletRoiChainBalanceViewData(this.available, this.lock, this.lockStakeable, this.loaded);

}

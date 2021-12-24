import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

part 'wallet_roi_chain_store.g.dart';

class WalletRoiChainStore = _WalletRoiChainStore with _$WalletRoiChainStore;

abstract class _WalletRoiChainStore with Store {
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
    final wallet = SingletonWallet(
        privateKey:
            "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");
    final utxos = await wallet.updateUtxosX();
    wallet.getBalanceX().forEach((_, balance) => balanceX =
        WalletRoiChainBalanceViewData(balance.unlockedDecimal, balance.lockedDecimal));

    await wallet.updateAvaxBalanceC();
    balanceC =
        WalletRoiChainBalanceViewData(wallet.getBalanceC().balanceDecimal, '0');

  }
}

class WalletRoiChainBalanceViewData {
  final String available;
  final String lock;

  WalletRoiChainBalanceViewData(this.available, this.lock);
}

import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

part 'wallet_roi_chain_store.g.dart';

class WalletRoiChainStore = _WalletRoiChainStore with _$WalletRoiChainStore;

abstract class _WalletRoiChainStore with Store {
  @observable
  WalletRoiChainBalanceViewData balanceX =
      WalletRoiChainBalanceViewData(BigInt.zero, BigInt.zero);

  @action
  getBalanceX() async {
    final wallet = SingletonWallet(
        privateKey:
            "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");
    final utxos = await wallet.updateUtxosX();
    final balanceX = wallet.getBalanceX();
    balanceX.forEach((k, v) =>
        print("asset_id = $k, locked = ${v.locked}, unlocked = ${v.unlocked}"));
  }
}

class WalletRoiChainBalanceViewData {
  final BigInt available;
  final BigInt lock;

  WalletRoiChainBalanceViewData(this.available, this.lock);
}

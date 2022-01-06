import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

part 'wallet_receive_store.g.dart';

class WalletReceiveStore = _WalletReceiveStore with _$WalletReceiveStore;

abstract class _WalletReceiveStore with Store {
  final wallet = SingletonWallet(
      privateKey:
          "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");
}

import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

part 'cross_transfer_store.g.dart';

class CrossTransferStore = _CrossTransferStore with _$CrossTransferStore;

abstract class _CrossTransferStore with Store {
  final wallet = SingletonWallet(
      privateKey:
      "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  @observable
  bool isTransferred = true;

  @observable
  bool isSourceAccepted = false;

  @observable
  bool isDestinationAccepted = false;
}
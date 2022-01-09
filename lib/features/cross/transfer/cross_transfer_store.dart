import 'package:mobx/mobx.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

import '../cross_store.dart';

part 'cross_transfer_store.g.dart';

class CrossTransferStore = _CrossTransferStore with _$CrossTransferStore;

abstract class _CrossTransferStore with Store {
  final wallet = SingletonWallet(
      privateKey:
      "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  @observable
  bool isTransferred = false;

  @observable
  bool isSourceAccepted = false;

  @observable
  bool isDestinationAccepted = false;
}

class CrossTransferInfo {
  final CrossChainType source;
  final CrossChainType destination;
  final double amount;

  CrossTransferInfo(this.source, this.destination, this.amount);
}
import 'package:mobx/mobx.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/utils/price_utils.dart';

part 'cross_store.g.dart';

class CrossStore = _CrossStore with _$CrossStore;

abstract class _CrossStore with Store {
  final wallet = SingletonWallet(
      privateKey:
          "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  @observable
  String balance = '0';

  @observable
  double avaxPrice = 0;

  @observable
  String? amountError;

  @observable
  CrossChainType sourceChain = CrossChainType.xChain;

  @observable
  CrossChainType destinationChain = CrossChainType.pChain;

  double get balanceDouble => double.tryParse(balance.replaceAll(',', '')) ?? 0;

  List<CrossChainType> get destinationList =>
      CrossChainType.values.toList()..remove(sourceChain);

  @action
  getBalance(CrossChainType type) async {
    switch (type) {
      case CrossChainType.xChain:
        await wallet.updateUtxosX();
        wallet
            .getBalanceX()
            .forEach((_, balanceX) => {balance = balanceX.unlockedDecimal});
        break;
      case CrossChainType.pChain:
        await wallet.updateUtxosP();
        balance = wallet.getBalanceP().unlockedDecimal;
        break;
      case CrossChainType.cChain:
        await wallet.updateAvaxBalanceC();
        balance = wallet.getBalanceC().balanceDecimal;
        break;
    }

    avaxPrice = (await getAvaxPrice()).toDouble();
  }

  @action
  setSourceChain(CrossChainType type) {
    sourceChain = type;
    getBalance(type);
    destinationChain = destinationList.first;
  }

  @action
  bool validate(double amount) {
    final isAmountValid = balanceDouble > amount && amount > 0;

    if (!isAmountValid) {
      amountError = Strings.current.sharedInvalidAmount;
    }
    return isAmountValid;
  }

  @action
  removeAmountError() {
    if (amountError != null) {
      amountError = null;
    }
  }
}

enum CrossChainType { xChain, pChain, cChain }

extension CrossChainTypeExtension on CrossChainType {
  String get name {
    return [
      "X Chain (Exchange)",
      "P Chain (Platform)",
      "C chain (Contract)"
    ][index];
  }
}

extension CrossChainTypeStringExtension on String {
  CrossChainType get getCrossChainType =>
      CrossChainType.values.firstWhere((element) => element.name == this);
}

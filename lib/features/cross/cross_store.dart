import 'package:mobx/mobx.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/types.dart';
import 'package:wallet/roi/wallet/utils/fee_utils.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';
import 'package:wallet/roi/wallet/utils/price_utils.dart';

part 'cross_store.g.dart';

class CrossStore = _CrossStore with _$CrossStore;

abstract class _CrossStore with Store {
  final wallet = SingletonWallet(
      privateKey:
          "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  @observable
  String sourceBalance = '0';

  @observable
  String destinationBalance = '0';

  @observable
  double avaxPrice = 0;

  @observable
  double amount = 0;

  @observable
  double fee = 0;

  @observable
  String? amountError;

  @observable
  String exportTxId = '';

  @observable
  String importTxId = '';

  @observable
  bool isConfirm = false;

  @observable
  CrossChainType sourceChain = CrossChainType.xChain;

  @observable
  CrossChainType destinationChain = CrossChainType.pChain;

  double get balanceDouble =>
      double.tryParse(sourceBalance.replaceAll(',', '')) ?? 0;

  List<CrossChainType> get destinationList =>
      CrossChainType.values.toList()..remove(sourceChain);

  @action
  getSourceBalance(CrossChainType type) async {
    switch (type) {
      case CrossChainType.xChain:
        await wallet.updateUtxosX();
        wallet.getBalanceX().forEach(
            (_, balanceX) => {sourceBalance = balanceX.unlockedDecimal});
        break;
      case CrossChainType.pChain:
        await wallet.updateUtxosP();
        sourceBalance = wallet.getBalanceP().unlockedDecimal;
        break;
      case CrossChainType.cChain:
        await wallet.updateAvaxBalanceC();
        sourceBalance = wallet.getBalanceC().balanceDecimal;
        break;
    }

    avaxPrice = (await getAvaxPrice()).toDouble();
  }

  @action
  getDestinationBalance(CrossChainType type) async {
    switch (type) {
      case CrossChainType.xChain:
        await wallet.updateUtxosX();
        wallet.getBalanceX().forEach(
            (_, balanceX) => {destinationBalance = balanceX.unlockedDecimal});
        break;
      case CrossChainType.pChain:
        await wallet.updateUtxosP();
        destinationBalance = wallet.getBalanceP().unlockedDecimal;
        break;
      case CrossChainType.cChain:
        await wallet.updateAvaxBalanceC();
        destinationBalance = wallet.getBalanceC().balanceDecimal;
        break;
    }
  }

  @action
  setSourceChain(CrossChainType type) {
    sourceChain = type;
    getSourceBalance(type);
    destinationChain = destinationList.first;
    getDestinationBalance(destinationChain);
    fee = getFee(sourceChain) + getFee(destinationChain);
  }

  @action
  setDestinationChain(CrossChainType type) {
    destinationChain = type;
    getDestinationBalance(type);
    fee = getFee(sourceChain) + getFee(destinationChain);
  }

  @action
  bool validate() {
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

  @action
  transferring() async {
    try {
      final feeP = getTxFeeP();
      final feeX = getTxFeeX();

      if (sourceChain == CrossChainType.xChain &&
          destinationChain == CrossChainType.pChain) {
        final amountAvax = numberToBNAvaxX(amount) + feeX;
        exportTxId = await wallet.exportXChain(amountAvax, ExportChainsX.P);
        importTxId = await wallet.importPChain(ExportChainsP.X);
      } else if (sourceChain == CrossChainType.pChain &&
          destinationChain == CrossChainType.xChain) {
        final amountAvax = numberToBNAvaxP(amount) + feeP;
        exportTxId = await wallet.exportPChain(amountAvax, ExportChainsP.X);
        importTxId = await wallet.importXChain(ExportChainsX.P);
      } else if (sourceChain == CrossChainType.cChain &&
          destinationChain == CrossChainType.xChain) {
        final amountAvax = numberToBNAvaxC(amount);
        exportTxId = await wallet.exportCChain(amountAvax, ExportChainsC.X);
        importTxId = await wallet.importXChain(ExportChainsX.C);
      } else if (sourceChain == CrossChainType.xChain &&
          destinationChain == CrossChainType.cChain) {
        final amountAvax = numberToBNAvaxX(amount) + feeX;
        exportTxId = await wallet.exportXChain(amountAvax, ExportChainsX.C);
        importTxId = await wallet.importCChain(ExportChainsC.X);
      }
    } catch (e) {
      print(e);
    }
  }

  getFee(CrossChainType type) {
    switch (type) {
      case CrossChainType.xChain:
        return getTxFeeX();
      case CrossChainType.pChain:
        return getTxFeeP();
      default:
        return getTxFeeX();
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

  String get nameTwo {
    return ["X Chain", "P Chain", "C chain"][index];
  }
}

extension CrossChainTypeStringExtension on String {
  CrossChainType get getCrossChainType =>
      CrossChainType.values.firstWhere((element) => element.name == this);
}

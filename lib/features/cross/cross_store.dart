import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/wallet/types.dart';
import 'package:wallet/roi/wallet/utils/fee_utils.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

part 'cross_store.freezed.dart';

part 'cross_store.g.dart';

class CrossStore = _CrossStore with _$CrossStore;

abstract class _CrossStore with Store {
  final wallet = getIt<WalletFactory>().activeWallet;

  final balanceStore = getIt<BalanceStore>();
  final priceStore = getIt<PriceStore>();

  @computed
  double get avaxPrice => priceStore.avaxPrice.toDouble();

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

  @observable
  CrossTransferringState exportState = const CrossTransferringState.loading();

  @observable
  CrossTransferringState importState = const CrossTransferringState.loading();

  @observable
  CrossTransferringState transferringState =
      const CrossTransferringState.loading();

  @computed
  String get sourceBalance {
    return _getBalance(sourceChain);
  }

  @computed
  String get destinationBalance {
    return _getBalance(destinationChain);
  }

  double get balanceDouble =>
      double.tryParse(sourceBalance.replaceAll(',', '')) ?? 0;

  List<CrossChainType> get destinationList =>
      CrossChainType.values.toList()..remove(sourceChain);

  @action
  init() async {
    priceStore.updateAvaxPrice();
    setSourceChain(sourceChain);
  }

  @action
  setSourceChain(CrossChainType type) {
    sourceChain = type;
    destinationChain = destinationList.first;
    fee = getFee(sourceChain) + getFee(destinationChain);
  }

  @action
  setDestinationChain(CrossChainType type) {
    destinationChain = type;
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
    await _export();
    await _import();
    balanceStore.updateBalance();
  }

  _export() async {
    try {
      final feeP = getTxFeeP();
      final feeX = getTxFeeX();

      if (sourceChain == CrossChainType.xChain &&
          destinationChain == CrossChainType.pChain) {
        // x -> p
        final amountAvax = numberToBNAvaxX(amount) + feeP;
        exportTxId = await wallet.exportXChain(amountAvax, ExportChainsX.P);
      } else if (sourceChain == CrossChainType.pChain &&
          destinationChain == CrossChainType.xChain) {
        // p -> x
        final amountAvax = numberToBNAvaxP(amount) + feeX;
        exportTxId = await wallet.exportPChain(amountAvax, ExportChainsP.X);
      } else if (sourceChain == CrossChainType.cChain &&
          destinationChain == CrossChainType.xChain) {
        // c -> x
        final hexAddress = wallet.getAddressC();
        const destinationChain = ExportChainsC.X;
        final destinationAddress = wallet.getAddressX();
        final exportFee = await estimateExportGasFee(
          destinationChain,
          numberToBNAvaxX(amount),
          hexAddress,
          destinationAddress,
        );
        final amountAvax = numberToBNAvaxX(amount) + feeX;
        exportTxId = await wallet.exportCChain(
          amountAvax,
          destinationChain,
          exportFee: exportFee,
        );
      } else if (sourceChain == CrossChainType.xChain &&
          destinationChain == CrossChainType.cChain) {
        // x -> c
        final amountAvax = numberToBNAvaxX(amount) + feeX;
        exportTxId = await wallet.exportXChain(amountAvax, ExportChainsX.C);
      } else if (sourceChain == CrossChainType.pChain &&
          destinationChain == CrossChainType.cChain) {
        // p -> c
        final importFee = await estimateImportGasFee();
        final amountAvax = numberToBNAvaxX(amount) + importFee;
        exportTxId = await wallet.exportXChain(amountAvax, ExportChainsX.C);
      } else if (sourceChain == CrossChainType.cChain &&
          destinationChain == CrossChainType.pChain) {
        // c -> p
        importTxId = await wallet.importPChain(ExportChainsP.C);
      }
      exportState = const CrossTransferringState.success();
    } catch (e) {
      exportState = const CrossTransferringState.error();
      importState = const CrossTransferringState.error();
      transferringState = const CrossTransferringState.error();
      print(e);
    }
  }

  _import() async {
    try {
      if (sourceChain == CrossChainType.xChain &&
          destinationChain == CrossChainType.pChain) {
        importTxId = await wallet.importPChain(ExportChainsP.X);
      } else if (sourceChain == CrossChainType.pChain &&
          destinationChain == CrossChainType.xChain) {
        importTxId = await wallet.importXChain(ExportChainsX.P);
      } else if (sourceChain == CrossChainType.cChain &&
          destinationChain == CrossChainType.xChain) {
        importTxId = await wallet.importXChain(ExportChainsX.C);
      } else if (sourceChain == CrossChainType.xChain &&
          destinationChain == CrossChainType.cChain) {
        importTxId = await wallet.importCChain(ExportChainsC.X);
      } else if (sourceChain == CrossChainType.pChain &&
          destinationChain == CrossChainType.cChain) {
        importTxId = await wallet.importCChain(ExportChainsC.P);
      } else if (sourceChain == CrossChainType.cChain &&
          destinationChain == CrossChainType.pChain) {
        importTxId = await wallet.importPChain(ExportChainsP.C);
      }
      importState = const CrossTransferringState.success();
      transferringState = const CrossTransferringState.success();
    } catch (e) {
      importState = const CrossTransferringState.error();
      transferringState = const CrossTransferringState.error();
      print('vit $e');
    }
  }

  double getFee(CrossChainType type) {
    switch (type) {
      case CrossChainType.xChain:
        return bnToDecimalAvaxX(getTxFeeX()).toDouble();
      case CrossChainType.pChain:
        return bnToDecimalAvaxP(getTxFeeP()).toDouble();
      default:
        return 0;
    }
  }

  String _getBalance(CrossChainType chain) {
    switch (chain) {
      case CrossChainType.xChain:
        return balanceStore.balanceX;
      case CrossChainType.pChain:
        return balanceStore.balanceP;
      case CrossChainType.cChain:
        return balanceStore.balanceC;
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

@freezed
class CrossTransferringState with _$CrossTransferringState {
  const CrossTransferringState._();

  const factory CrossTransferringState.loading() = Loading;

  const factory CrossTransferringState.success() = Success;

  const factory CrossTransferringState.error([String? message]) = Error;

  String status() => this.when(
        loading: () => Strings.current.sharedProcessing,
        success: () => Strings.current.sharedAccepted,
        error: (error) => error ?? Strings.current.sharedError,
      );
}

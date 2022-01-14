import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
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
  final _wallet = getIt<WalletFactory>().activeWallet;

  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();

  @computed
  Decimal get avaxPrice => _priceStore.avaxPrice;

  @observable
  Decimal amount = Decimal.zero;

  get _amountDouble => amount.toDouble();

  @observable
  Decimal fee = Decimal.zero;

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
  Decimal get sourceBalance {
    return _getBalance(sourceChain);
  }

  @computed
  Decimal get destinationBalance {
    return _getBalance(destinationChain);
  }

  List<CrossChainType> get destinationList =>
      CrossChainType.values.toList()..remove(sourceChain);

  @action
  init() async {
    _priceStore.updateAvaxPrice();
    setSourceChain(sourceChain);
  }

  @action
  setSourceChain(CrossChainType type) async {
    sourceChain = type;
    destinationChain = destinationList.first;
    updateFee();
  }

  @action
  setDestinationChain(CrossChainType type) async {
    destinationChain = type;
    updateFee();
  }

  @action
  bool validate() {
    final isAmountValid = sourceBalance > amount && amount > Decimal.zero;

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
    _balanceStore.updateBalance();
  }

  @action
  updateFee() async {
    fee = await _getFeeExport() + await _getFeeImport();
  }

  _export() async {
    try {
      final feeP = getTxFeeP();
      final feeX = getTxFeeX();

      if (sourceChain == CrossChainType.xChain &&
          destinationChain == CrossChainType.pChain) {
        // x -> p
        final amountAvax = numberToBNAvaxX(_amountDouble) + feeP;
        exportTxId = await _wallet.exportXChain(amountAvax, ExportChainsX.P);
      } else if (sourceChain == CrossChainType.pChain &&
          destinationChain == CrossChainType.xChain) {
        // p -> x
        final amountAvax = numberToBNAvaxP(_amountDouble) + feeX;
        exportTxId = await _wallet.exportPChain(amountAvax, ExportChainsP.X);
      } else if (sourceChain == CrossChainType.cChain &&
          destinationChain == CrossChainType.xChain) {
        // c -> x
        final hexAddress = _wallet.getAddressC();
        const destinationChain = ExportChainsC.X;
        final destinationAddress = _wallet.getAddressX();
        final exportFee = await estimateExportGasFee(
          destinationChain,
          numberToBNAvaxX(amount),
          hexAddress,
          destinationAddress,
        );
        final amountAvax = numberToBNAvaxX(_amountDouble) + feeX;
        exportTxId = await _wallet.exportCChain(
          amountAvax,
          destinationChain,
          exportFee: exportFee,
        );
      } else if (sourceChain == CrossChainType.xChain &&
          destinationChain == CrossChainType.cChain) {
        // x -> c
        final amountAvax = numberToBNAvaxX(_amountDouble) + feeX;
        exportTxId = await _wallet.exportXChain(amountAvax, ExportChainsX.C);
      } else if (sourceChain == CrossChainType.pChain &&
          destinationChain == CrossChainType.cChain) {
        // p -> c
        final importFee = await estimateImportGasFee();
        final amountAvax = numberToBNAvaxX(_amountDouble) + importFee;
        exportTxId = await _wallet.exportXChain(amountAvax, ExportChainsX.C);
      } else if (sourceChain == CrossChainType.cChain &&
          destinationChain == CrossChainType.pChain) {
        // c -> p
        final hexAddress = _wallet.getAddressC();
        const destinationChain = ExportChainsC.P;
        final destinationAddress = _wallet.getAddressP();
        final exportFee = await estimateExportGasFee(
          destinationChain,
          numberToBNAvaxP(amount),
          hexAddress,
          destinationAddress,
        );
        final amountAvax = numberToBNAvaxP(_amountDouble) + feeP;
        exportTxId = await _wallet.exportCChain(
          amountAvax,
          destinationChain,
          exportFee: exportFee,
        );
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
        importTxId = await _wallet.importPChain(ExportChainsP.X);
      } else if (sourceChain == CrossChainType.pChain &&
          destinationChain == CrossChainType.xChain) {
        importTxId = await _wallet.importXChain(ExportChainsX.P);
      } else if (sourceChain == CrossChainType.cChain &&
          destinationChain == CrossChainType.xChain) {
        importTxId = await _wallet.importXChain(ExportChainsX.C);
      } else if (sourceChain == CrossChainType.xChain &&
          destinationChain == CrossChainType.cChain) {
        importTxId = await _wallet.importCChain(ExportChainsC.X);
      } else if (sourceChain == CrossChainType.pChain &&
          destinationChain == CrossChainType.cChain) {
        importTxId = await _wallet.importCChain(ExportChainsC.P);
      } else if (sourceChain == CrossChainType.cChain &&
          destinationChain == CrossChainType.pChain) {
        importTxId = await _wallet.importPChain(ExportChainsP.C);
      }
      importState = const CrossTransferringState.success();
      transferringState = const CrossTransferringState.success();
    } catch (e) {
      importState = const CrossTransferringState.error();
      transferringState = const CrossTransferringState.error();
    }
  }

  Future<Decimal> _getFeeExport() async {
    switch (sourceChain) {
      case CrossChainType.xChain:
        return bnToDecimalAvaxX(getTxFeeX());
      case CrossChainType.pChain:
        return bnToDecimalAvaxP(getTxFeeP());
      case CrossChainType.cChain:
        final hexAddress = _wallet.getAddressC();
        final destination = destinationChain == CrossChainType.xChain
            ? ExportChainsC.X
            : ExportChainsC.P;
        final destinationAddress = destinationChain == CrossChainType.xChain
            ? _wallet.getAddressX()
            : _wallet.getAddressP();
        final amountEzc = destinationChain == CrossChainType.xChain
            ? numberToBNAvaxX(amount)
            : numberToBNAvaxP(amount);
        final exportFee = await estimateExportGasFee(
          destination,
          amountEzc,
          hexAddress,
          destinationAddress,
        );
        return bnToDecimalAvaxX(exportFee);
    }
  }

  Future<Decimal> _getFeeImport() async {
    switch (destinationChain) {
      case CrossChainType.xChain:
        return bnToDecimalAvaxX(getTxFeeX());
      case CrossChainType.pChain:
        return bnToDecimalAvaxP(getTxFeeP());
      case CrossChainType.cChain:
        return bnToDecimalAvaxC(await estimateImportGasFee());
    }
  }

  Decimal _getBalance(CrossChainType chain) {
    switch (chain) {
      case CrossChainType.xChain:
        return _balanceStore.balanceX;
      case CrossChainType.pChain:
        return _balanceStore.balanceP;
      case CrossChainType.cChain:
        return _balanceStore.balanceC;
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

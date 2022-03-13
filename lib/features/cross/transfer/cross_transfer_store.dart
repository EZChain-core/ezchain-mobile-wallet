import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/cross/transfer/cross_transfer.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/ezc/wallet/types.dart';
import 'package:wallet/ezc/wallet/utils/fee_utils.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

import '../cross_store.dart';

part 'cross_transfer_store.freezed.dart';

part 'cross_transfer_store.g.dart';

class CrossTransferStore = _CrossTransferStore with _$CrossTransferStore;

abstract class _CrossTransferStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();

  @observable
  Decimal amount = Decimal.zero;

  get _amountDouble => amount.toDouble();

  @observable
  String exportTxId = '';

  @observable
  String importTxId = '';

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

  @action
  transferring() async {
    await _export();
    await _import();
  }

  setCrossTransferInfo(CrossTransferInfo info) {
    sourceChain = info.sourceChain;
    destinationChain = info.destinationChain;
    amount = info.amount;
    transferring();
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
        exportTxId = await _wallet.exportPChain(amountAvax, ExportChainsP.C);
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
      logger.e(e);
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
      logger.e(e);
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

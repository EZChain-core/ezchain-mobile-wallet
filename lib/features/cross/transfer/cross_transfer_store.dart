import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/types.dart';
import 'package:wallet/ezc/wallet/utils/fee_utils.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/cross/cross_store.dart';
import 'package:wallet/features/cross/transfer/cross_transfer.dart';
import 'package:wallet/generated/l10n.dart';

part 'cross_transfer_store.freezed.dart';

part 'cross_transfer_store.g.dart';

class CrossTransferStore = _CrossTransferStore with _$CrossTransferStore;

abstract class _CrossTransferStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  final _balanceStore = getIt<BalanceStore>();

  double _amountDouble = 0;

  @readonly
  String _exportTxId = '';

  @readonly
  String _importTxId = '';

  @readonly
  CrossChainType _sourceChain = CrossChainType.xChain;

  @readonly
  CrossChainType _destinationChain = CrossChainType.pChain;

  @readonly
  CrossTransferringState _exportState = const CrossTransferringState.loading();

  @readonly
  CrossTransferringState _importState = const CrossTransferringState.loading();

  @readonly
  CrossTransferringState _transferringState =
      const CrossTransferringState.loading();

  @computed
  Decimal get sourceBalance {
    return _getBalance(_sourceChain);
  }

  @computed
  Decimal get destinationBalance {
    return _getBalance(_destinationChain);
  }

  @action
  transferring() async {
    await _export();
    await _import();
  }

  @action
  setCrossTransferInfo(CrossTransferInfo info) {
    _sourceChain = info.sourceChain;
    _destinationChain = info.destinationChain;
    _amountDouble = info.amount.toDouble();
    transferring();
  }

  @action
  _export() async {
    try {
      final feeP = getTxFeeP();
      final feeX = getTxFeeX();

      if (_sourceChain == CrossChainType.xChain &&
          _destinationChain == CrossChainType.pChain) {
        // x -> p
        final amountAvax = numberToBNAvaxX(_amountDouble) + feeP;
        _exportTxId = await _wallet.exportXChain(amountAvax, ExportChainsX.P);
      } else if (_sourceChain == CrossChainType.pChain &&
          _destinationChain == CrossChainType.xChain) {
        // p -> x
        final amountAvax = numberToBNAvaxP(_amountDouble) + feeX;
        _exportTxId = await _wallet.exportPChain(amountAvax, ExportChainsP.X);
      } else if (_sourceChain == CrossChainType.cChain &&
          _destinationChain == CrossChainType.xChain) {
        // c -> x
        final hexAddress = _wallet.getAddressC();
        const destinationChain = ExportChainsC.X;
        final destinationAddress = _wallet.getAddressX();
        final exportFee = await estimateExportGasFee(
          destinationChain,
          numberToBNAvaxX(_amountDouble),
          hexAddress,
          destinationAddress,
        );
        final amountAvax = numberToBNAvaxX(_amountDouble) + feeX;
        _exportTxId = await _wallet.exportCChain(
          amountAvax,
          destinationChain,
          exportFee: exportFee,
        );
      } else if (_sourceChain == CrossChainType.xChain &&
          _destinationChain == CrossChainType.cChain) {
        // x -> c
        final amountAvax = numberToBNAvaxX(_amountDouble) + feeX;
        _exportTxId = await _wallet.exportXChain(amountAvax, ExportChainsX.C);
      } else if (_sourceChain == CrossChainType.pChain &&
          _destinationChain == CrossChainType.cChain) {
        // p -> c
        final importFee = await estimateImportGasFee();
        final amountAvax = numberToBNAvaxX(_amountDouble) + importFee;
        _exportTxId = await _wallet.exportPChain(amountAvax, ExportChainsP.C);
      } else if (_sourceChain == CrossChainType.cChain &&
          _destinationChain == CrossChainType.pChain) {
        // c -> p
        final hexAddress = _wallet.getAddressC();
        const destinationChain = ExportChainsC.P;
        final destinationAddress = _wallet.getAddressP();
        final exportFee = await estimateExportGasFee(
          destinationChain,
          numberToBNAvaxP(_amountDouble),
          hexAddress,
          destinationAddress,
        );
        final amountAvax = numberToBNAvaxP(_amountDouble) + feeP;
        _exportTxId = await _wallet.exportCChain(
          amountAvax,
          destinationChain,
          exportFee: exportFee,
        );
      }
      _exportState = const CrossTransferringState.success();
    } catch (e) {
      _exportState = const CrossTransferringState.error();
      _importState = const CrossTransferringState.error();
      _transferringState = const CrossTransferringState.error();
      logger.e(e);
    }
  }

  @action
  _import() async {
    try {
      if (_sourceChain == CrossChainType.xChain &&
          _destinationChain == CrossChainType.pChain) {
        _importTxId = await _wallet.importPChain(ExportChainsP.X);
      } else if (_sourceChain == CrossChainType.pChain &&
          _destinationChain == CrossChainType.xChain) {
        _importTxId = await _wallet.importXChain(ExportChainsX.P);
      } else if (_sourceChain == CrossChainType.cChain &&
          _destinationChain == CrossChainType.xChain) {
        _importTxId = await _wallet.importXChain(ExportChainsX.C);
      } else if (_sourceChain == CrossChainType.xChain &&
          _destinationChain == CrossChainType.cChain) {
        _importTxId = await _wallet.importCChain(ExportChainsC.X);
      } else if (_sourceChain == CrossChainType.pChain &&
          _destinationChain == CrossChainType.cChain) {
        _importTxId = await _wallet.importCChain(ExportChainsC.P);
      } else if (_sourceChain == CrossChainType.cChain &&
          _destinationChain == CrossChainType.pChain) {
        _importTxId = await _wallet.importPChain(ExportChainsP.C);
      }
      _importState = const CrossTransferringState.success();
      _transferringState = const CrossTransferringState.success();
    } catch (e) {
      _importState = const CrossTransferringState.error();
      _transferringState = const CrossTransferringState.error();
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

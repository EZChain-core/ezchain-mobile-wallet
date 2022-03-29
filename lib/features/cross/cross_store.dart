import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/types.dart';
import 'package:wallet/ezc/wallet/utils/fee_utils.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/store/price_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/cross/transfer/cross_transfer.dart';
import 'package:wallet/generated/l10n.dart';

part 'cross_store.g.dart';

class CrossStore = _CrossStore with _$CrossStore;

abstract class _CrossStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  final _balanceStore = getIt<BalanceStore>();
  final _priceStore = getIt<PriceStore>();

  @computed
  Decimal get avaxPrice => _priceStore.ezcPrice;

  @observable
  Decimal amount = Decimal.zero;

  @readonly
  Decimal _fee = Decimal.zero;

  @readonly
  String? _amountError;

  @observable
  bool isConfirm = false;

  @readonly
  CrossChainType _sourceChain = CrossChainType.xChain;

  @observable
  CrossChainType destinationChain = CrossChainType.pChain;

  @computed
  Decimal get sourceBalance {
    return _getBalance(_sourceChain);
  }

  @computed
  Decimal get destinationBalance {
    return _getBalance(destinationChain);
  }

  List<CrossChainType> get destinationList =>
      CrossChainType.values.toList()..remove(_sourceChain);

  CrossTransferInfo get crossTransferInfo =>
      CrossTransferInfo(_sourceChain, destinationChain, amount);

  get _amountDouble => amount.toDouble();

  @action
  init() async {
    setSourceChain(_sourceChain);
  }

  @action
  setSourceChain(CrossChainType type) async {
    _sourceChain = type;
    destinationChain = destinationList.first;
    updateFee();
  }

  @action
  setDestinationChain(CrossChainType type) async {
    destinationChain = type;
    updateFee();
  }

  @action
  switchChain() {
    final chain = _sourceChain;
    _sourceChain = destinationChain;
    destinationChain = chain;
    updateFee();
  }

  @action
  bool validate() {
    final isAmountValid = sourceBalance > amount && amount > Decimal.zero;
    if (!isAmountValid) {
      _amountError = Strings.current.sharedInvalidAmount;
    }
    return isAmountValid;
  }

  @action
  removeAmountError() {
    if (_amountError != null) {
      _amountError = null;
    }
  }

  @action
  updateFee() async {
    _fee = await _getFeeExport() + await _getFeeImport();
  }

  Future<Decimal> _getFeeExport() async {
    switch (_sourceChain) {
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
            ? numberToBNAvaxX(_amountDouble)
            : numberToBNAvaxP(_amountDouble);
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

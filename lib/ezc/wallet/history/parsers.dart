import 'package:wallet/ezc/wallet/explorer/ortelius/types.dart';
import 'package:wallet/ezc/wallet/explorer/ortelius/utils.dart';
import 'package:wallet/ezc/wallet/explorer/ortelius/utxo_utils.dart';
import 'package:wallet/ezc/wallet/history/base_tx_parser.dart';
import 'package:wallet/ezc/wallet/history/history_helpers.dart';
import 'package:wallet/ezc/wallet/history/import_export_parser.dart';
import 'package:wallet/ezc/wallet/history/types.dart';
import 'package:wallet/ezc/wallet/network/helpers/alias_from_network_id.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/network/utils.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

Future<HistoryItem> getTransactionSummary(
  OrteliusTx tx,
  List<String> walletAddresses,
  String evmAddress,
) async {
  final cleanAddressesXP =
      walletAddresses.map((address) => address.split("-")[1]).toList();
  switch (tx.type) {
    case OrteliusTxType.import:
    case OrteliusTxType.pvmImport:
      return getImportSummary(tx, cleanAddressesXP);
    case OrteliusTxType.atomicImportTx:
      return getImportSummaryC(tx, evmAddress);
    case OrteliusTxType.export:
    case OrteliusTxType.pvmExport:
    case OrteliusTxType.atomicExportTx:
      return getExportSummary(tx, cleanAddressesXP);
    case OrteliusTxType.addValidator:
    case OrteliusTxType.addDelegator:
      return getStakingSummary(tx, cleanAddressesXP);
    case OrteliusTxType.createAsset:
    case OrteliusTxType.operation:
    case OrteliusTxType.base:
      return getBaseTxSummary(tx, cleanAddressesXP);
    default:
      return getUnsupportedSummary(tx);
  }
}

HistoryItem getUnsupportedSummary(OrteliusTx tx) {
  return HistoryItem(
    id: tx.id,
    type: HistoryItemTypeName.notSupported,
    fee: BigInt.zero,
    timestamp: tx.timestamp,
  );
}

HistoryStaking getStakingSummary(
  OrteliusTx tx,
  List<String> ownerAddresses,
) {
  final ins = tx.inputs?.map((tx) => tx.output).toList() ?? [];
  final myIns = getOwnedOutputs(ins, ownerAddresses);

  final outs = tx.outputs ?? [];
  final myOuts = getOwnedOutputs(outs, ownerAddresses);

  final stakeAmount = getStakeAmount(tx);

  /// Assign the type
  var type = tx.type == OrteliusTxType.addValidator
      ? HistoryItemTypeName.addValidator
      : HistoryItemTypeName.addDelegator;

  /// If this wallet only received the fee
  if (myIns.isEmpty && type == HistoryItemTypeName.addDelegator) {
    type = HistoryItemTypeName.delegationFee;
  } else if (myIns.isEmpty && type == HistoryItemTypeName.addValidator) {
    type = HistoryItemTypeName.validationFee;
  }

  BigInt rewardAmount = BigInt.zero;
  String rewardAmountClean = "";
  if (tx.rewarded) {
    final rewardOuts = getRewardOuts(myOuts);
    rewardAmount = getOutputTotals(rewardOuts);
    rewardAmountClean = bnToAvaxP(rewardAmount);
  }

  return HistoryStaking(
    id: tx.id,
    nodeId: tx.validatorNodeId,
    stakeStart: tx.validatorStart * 1000,
    stakeEnd: tx.validatorEnd * 1000,
    amount: stakeAmount,
    amountDisplayValue: bnToAvaxP(stakeAmount),
    isRewarded: tx.rewarded,
    rewardAmount: rewardAmount,
    rewardAmountDisplayValue: rewardAmountClean,
    timestamp: tx.timestamp,
    type: type,
    fee: BigInt.zero,
    memo: parseMemo(tx.memo),
  );
}

/// Returns the summary for a C chain import TX
HistoryImportExport getImportSummaryC(
  OrteliusTx tx,
  String ownerAddresses,
) {
  final sourceChain = findSourceChain(tx);
  final chainAliasFrom = idToChainAlias(sourceChain);
  final chainAliasTo = idToChainAlias(tx.chainId);

  final avaxId = getAvaxAssetId();
  final outs = tx.outputs ?? [];
  final amtOut = getEvmAssetBalanceFromUTXOs(
    outs,
    ownerAddresses,
    avaxId,
    tx.chainId,
  );

  return HistoryImportExport(
    id: tx.id,
    source: chainAliasFrom,
    destination: chainAliasTo,
    amount: amtOut,
    amountDisplayValue: bnToAvaxX(amtOut),
    timestamp: tx.timestamp,
    type: HistoryItemTypeName.import,
    fee: xChain.getTxFee(),
    memo: parseMemo(tx.memo),
  );
}

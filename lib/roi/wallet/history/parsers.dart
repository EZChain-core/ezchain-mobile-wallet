import 'package:wallet/roi/wallet/history/base_tx_parser.dart';
import 'package:wallet/roi/wallet/history/history_helpers.dart';
import 'package:wallet/roi/wallet/history/import_export_parser.dart';
import 'package:wallet/roi/wallet/history/raw_types.dart';
import 'package:wallet/roi/wallet/network/helpers/alias_from_network_id.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

Future<void> getTransactionSummary(
  Transaction tx,
  List<String> walletAddresses,
  String evmAddress,
) async {
  final cleanAddressesXP =
      walletAddresses.map((address) => address.split("-")[1]).toList();
  switch (tx.type) {
    case TransactionType.import:
    case TransactionType.pvmImport:
      return getImportSummary(tx, cleanAddressesXP);
    case TransactionType.atomicImportTx:
      return getImportSummaryC(tx, evmAddress);
    case TransactionType.export:
    case TransactionType.pvmExport:
    case TransactionType.atomicExportTx:
      return getExportSummary(tx, cleanAddressesXP);
    case TransactionType.addValidator:
    case TransactionType.addDelegator:
      return getStakingSummary(tx, cleanAddressesXP);
    case TransactionType.operation:
    case TransactionType.base:
      return getBaseTxSummary(tx, cleanAddressesXP);
    default:
      return getUnsupportedSummary(tx);
  }
}

Future<dynamic> getUnsupportedSummary(Transaction tx) async {
  return {
    "id": tx.id,
    "type": "not_supported",
    "timestamp": tx.timestamp,
    "fee": BigInt.zero
  };
}

Future<dynamic> getStakingSummary(
  Transaction tx,
  List<String> ownerAddresses,
) async {
  final ins = tx.inputs?.map((tx) => tx.output).toList() ?? [];
  final myIns = getOwnedOutputs(ins, ownerAddresses);

  final outs = tx.outputs ?? [];
  final myOuts = getOwnedOutputs(outs, ownerAddresses);

  final stakeAmount = getStakeAmount(tx);

  // Assign the type
  var type = tx.type == TransactionType.addValidator
      ? 'add_validator'
      : 'add_delegator';
  // If this wallet only received the fee
  if (myIns.isEmpty && type == 'add_delegator') {
    type = 'delegation_fee';
  } else if (myIns.isEmpty && type == 'add_validator') {
    type = 'validation_fee';
  }

  BigInt rewardAmount = BigInt.zero;
  String rewardAmountClean = "";
  if (tx.rewarded) {
    final rewardOuts = getRewardOuts(myOuts);
    rewardAmount = getOutputTotals(rewardOuts);
    rewardAmountClean = bnToAvaxP(rewardAmount);
  }

  return {
    "id": tx.id,
    "nodeId": tx.validatorNodeId,
    "stakeStart": tx.validatorStart * 1000,
    "stakeEnd": tx.validatorEnd * 1000,
    "timestamp": tx.timestamp,
    "type": type,
    "fee": BigInt.zero,
    "amount": stakeAmount,
    "amountDisplayValue": bnToAvaxP(stakeAmount),
    "memo": parseMemo(tx.memo),
    "isRewarded": tx.rewarded,
    "rewardAmount": rewardAmount,
    "rewardAmountDisplayValue": rewardAmountClean,
  };
}

// Returns the summary for a C chain import TX
Future<dynamic> getImportSummaryC(
  Transaction tx,
  String ownerAddresses,
) async {
  final sourceChain = findSourceChain(tx);
  final chainAliasFrom = idToChainAlias(sourceChain);
  final chainAliasTo = idToChainAlias(tx.chainId);

  final avaxId = activeNetwork.avaxId!;
  final outs = tx.outputs ?? [];
  final amtOut = getEvmAssetBalanceFromUTXOs(
    outs,
    ownerAddresses,
    avaxId,
    tx.chainId,
  );

  return {
    "id": tx.id,
    "source": chainAliasFrom,
    "destination": chainAliasTo,
    "amount": amtOut,
    "amountDisplayValue": bnToAvaxX(amtOut),
    "timestamp": tx.timestamp,
    "type": "import",
    "fee": xChain.getTxFee(),
    "memo": parseMemo(tx.memo)
  };
}

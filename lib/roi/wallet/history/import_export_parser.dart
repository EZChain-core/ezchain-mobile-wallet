import 'package:wallet/roi/wallet/explorer/ortelius/types.dart';
import 'package:wallet/roi/wallet/explorer/ortelius/utils.dart';
import 'package:wallet/roi/wallet/explorer/ortelius/utxo_utils.dart';
import 'package:wallet/roi/wallet/history/history_helpers.dart';
import 'package:wallet/roi/wallet/history/types.dart';
import 'package:wallet/roi/wallet/network/helpers/alias_from_network_id.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

HistoryImportExport getImportSummary(
  OrteliusTx tx,
  List<String> addresses,
) {
  final sourceChain = findSourceChain(tx);
  final chainAliasFrom = idToChainAlias(sourceChain);
  final chainAliasTo = idToChainAlias(tx.chainId);

  final outs = tx.outputs ?? [];
  final myOuts = getOwnedOutputs(outs, addresses);
  final amtOut = getOutputTotals(myOuts);

  final fee = xChain.getTxFee();

  return HistoryImportExport(
    id: tx.id,
    memo: parseMemo(tx.memo),
    source: chainAliasFrom,
    destination: chainAliasTo,
    amount: amtOut,
    amountDisplayValue: bnToAvaxX(amtOut),
    timestamp: tx.timestamp,
    type: HistoryItemTypeName.import,
    fee: fee,
  );
}

HistoryImportExport getExportSummary(
  OrteliusTx tx,
  List<String> addresses,
) {
  final sourceChain = findSourceChain(tx);
  final chainAliasFrom = idToChainAlias(sourceChain);

  final destinationChain = findDestinationChain(tx);
  final chainAliasTo = idToChainAlias(destinationChain);

  final outs = tx.outputs ?? [];
  final myOuts = getOwnedOutputs(outs, addresses);
  final chainOuts = getOutputsOfChain(myOuts, destinationChain);
  final amtOut = getOutputTotals(chainOuts);

  final fee = xChain.getTxFee();

  return HistoryImportExport(
    id: tx.id,
    memo: parseMemo(tx.memo),
    source: chainAliasFrom,
    destination: chainAliasTo,
    amount: amtOut,
    amountDisplayValue: bnToAvaxX(amtOut),
    timestamp: tx.timestamp,
    type: HistoryItemTypeName.export,
    fee: fee,
  );
}

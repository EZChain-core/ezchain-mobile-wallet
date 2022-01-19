import 'package:wallet/roi/wallet/history/history_helpers.dart';
import 'package:wallet/roi/wallet/history/raw_types.dart';
import 'package:wallet/roi/wallet/network/helpers/alias_from_network_id.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

Future<dynamic> getImportSummary(
  Transaction tx,
  List<String> addresses,
) async {
  final sourceChain = findSourceChain(tx);
  final chainAliasFrom = idToChainAlias(sourceChain);
  final chainAliasTo = idToChainAlias(tx.chainId);

  final outs = tx.outputs ?? [];
  final myOuts = getOwnedOutputs(outs, addresses);
  final amtOut = getOutputTotals(myOuts);

  final fee = xChain.getTxFee();

  return {
    "id": tx.id,
    "memo": parseMemo(tx.memo),
    "source": chainAliasFrom,
    "destination": chainAliasTo,
    "amount": amtOut,
    "amountDisplayValue": bnToAvaxX(amtOut),
    "timestamp": tx.timestamp,
    "type": 'import',
    "fee": fee,
  };
}

Future<dynamic> getExportSummary(
  Transaction tx,
  List<String> addresses,
) async {
  final sourceChain = findSourceChain(tx);
  final chainAliasFrom = idToChainAlias(sourceChain);

  final destinationChain = findDestinationChain(tx);
  final chainAliasTo = idToChainAlias(destinationChain);

  final outs = tx.outputs ?? [];
  final myOuts = getOwnedOutputs(outs, addresses);
  final chainOuts = getOutputsOfChain(myOuts, destinationChain);
  final amtOut = getOutputTotals(chainOuts);

  final fee = xChain.getTxFee();

  return {
    "id": tx.id,
    "memo": parseMemo(tx.memo),
    "source": chainAliasFrom,
    "destination": chainAliasTo,
    "amount": amtOut,
    "amountDisplayValue": bnToAvaxX(amtOut),
    "timestamp": tx.timestamp,
    "type": 'export',
    "fee": fee,
  };
}

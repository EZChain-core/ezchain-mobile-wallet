import 'package:wallet/roi/sdk/apis/avm/constants.dart';
import 'package:wallet/roi/wallet/history/history_helpers.dart';
import 'package:wallet/roi/wallet/history/raw_types.dart';
import 'package:wallet/roi/wallet/utils/fee_utils.dart';

Future<dynamic> getBaseTxSummary(
  Transaction tx,
  List<String> ownerAddresses,
) async {
  final ins = tx.inputs?.map((input) => input.output).toList() ?? [];
  final outs = tx.outputs ?? [];

  // Calculate losses from inputs
  final losses = getOwnedTokens(ins, ownerAddresses);
  final gains = getOwnedTokens(outs, ownerAddresses);

  final nowOwnedIns = getNotOwnedOutputs(ins, ownerAddresses);
  final nowOwnedOuts = getNotOwnedOutputs(outs, ownerAddresses);

  final froms = getOutputsAssetOwners(nowOwnedIns);
  final tos = getOutputsAssetOwners(nowOwnedOuts);

  final tokens = await getBaseTxTokensSummary(gains, losses, froms, tos);

  return {
    "id": tx.id,
    "fee": getTxFeeX(),
    "type": 'transaction',
    "timestamp": tx.timestamp,
    "memo": parseMemo(tx.memo),
    "tokens": tokens,
  };
}

Future<dynamic> getBaseTxTokensSummary(
  dynamic gains,
  dynamic losses,
  dynamic froms,
  dynamic tos,
) async {}

/// Returns a dictionary of asset totals belonging to the owner
/// @param utxos
/// @param ownerAddrs
getOwnedTokens(List<TransactionOutput> utxos, List<String> ownerAddresses) {
  final tokenUTXOs = getOutputsOfType(utxos, SECPXFEROUTPUTID);

  /// Owned inputs
  final myUTXOs = getOwnedOutputs(tokenUTXOs, ownerAddresses);

  /// Asset IDs received
  final assetIDs = getOutputsAssetIds(myUTXOs);

  final res = {};

  for (var i = 0; i < assetIDs.length; i++) {
    final assetID = assetIDs[i];
    final assetUTXOs = getAssetOutputs(myUTXOs, assetID);
    final tot = getOutputTotals(assetUTXOs);
    res[assetID] = tot;
  }

  return res;
}

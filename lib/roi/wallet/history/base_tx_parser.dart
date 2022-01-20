import 'package:wallet/roi/sdk/apis/avm/constants.dart';
import 'package:wallet/roi/wallet/asset/assets.dart';
import 'package:wallet/roi/wallet/asset/types.dart';
import 'package:wallet/roi/wallet/history/history_helpers.dart';
import 'package:wallet/roi/wallet/history/parsed_types.dart';
import 'package:wallet/roi/wallet/history/raw_types.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/utils/fee_utils.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

Future<HistoryBaseTx> getBaseTxSummary(
  Transaction tx,
  List<String> ownerAddresses,
) async {
  final ins = tx.inputs?.map((input) => input.output).toList() ?? [];
  final outs = tx.outputs ?? [];

  /// Calculate losses from inputs
  final losses = getOwnedTokens(ins, ownerAddresses);
  final gains = getOwnedTokens(outs, ownerAddresses);

  final nowOwnedIns = getNotOwnedOutputs(ins, ownerAddresses);
  final nowOwnedOuts = getNotOwnedOutputs(outs, ownerAddresses);

  final froms = getOutputsAssetOwners(nowOwnedIns);
  final tos = getOutputsAssetOwners(nowOwnedOuts);

  final tokens = await getBaseTxTokensSummary(gains, losses, froms, tos);

  return HistoryBaseTx(
    id: tx.id,
    fee: getTxFeeX(),
    type: HistoryItemTypeName.transaction,
    timestamp: tx.timestamp,
    memo: parseMemo(tx.memo),
    tokens: tokens,
  );
}

Future<List<HistoryBaseTxToken>> getBaseTxTokensSummary(
  HistoryBaseTxTokenLossGain gains,
  HistoryBaseTxTokenLossGain losses,
  HistoryBaseTxTokenOwners froms,
  HistoryBaseTxTokenOwners tos,
) async {
  final res = <HistoryBaseTxToken>[];

  final assetIds =
      <String>{...gains.result.keys, ...losses.result.keys}.toList();

  /// Fetch asset descriptions
  final calls = assetIds.map((id) => getAssetDescription(id));
  final descs = await Future.wait(calls);
  final descsDict = <String, AssetDescriptionClean>{};

  /// Convert array to dict
  for (var i = 0; i < descs.length; i++) {
    final desc = descs[i];
    descsDict[desc.assetId] = desc;
  }

  for (var i = 0; i < assetIds.length; i++) {
    final id = assetIds[i];
    final tokenGain = gains.result[id] ?? BigInt.zero;
    var tokenLost = losses.result[id] ?? BigInt.zero;
    final tokenDesc = descsDict[id]!;

    /// If we sent avax, deduct the fee
    if (id == activeNetwork.avaxId && tokenLost > BigInt.zero) {
      tokenLost = tokenLost - getTxFeeX();
    }

    /// How much we gained/lost of this token
    final diff = tokenGain - tokenLost;
    final diffClean =
        bnToLocaleString(diff, decimals: int.parse(tokenDesc.denomination));

    /// If we didnt gain or lose anything, ignore this token
    if (diff == BigInt.zero) continue;

    if (diff.isNegative) {
      res.add(HistoryBaseTxToken(
        diff,
        diffClean,
        tos.result[id]!,
        tokenDesc,
      ));
    } else {
      res.add(HistoryBaseTxToken(
        diff,
        diffClean,
        froms.result[id]!,
        tokenDesc,
      ));
    }
  }

  return res;
}

/// Returns a dictionary of asset totals belonging to the owner
/// @param utxos
/// @param ownerAddrs
HistoryBaseTxTokenLossGain getOwnedTokens(
    List<TransactionOutput> utxos, List<String> ownerAddresses) {
  final tokenUTXOs = getOutputsOfType(utxos, SECPXFEROUTPUTID);

  /// Owned inputs
  final myUTXOs = getOwnedOutputs(tokenUTXOs, ownerAddresses);

  /// Asset IDs received
  final assetIDs = getOutputsAssetIds(myUTXOs);

  final res = <String, BigInt>{};

  for (var i = 0; i < assetIDs.length; i++) {
    final assetID = assetIDs[i];
    final assetUTXOs = getAssetOutputs(myUTXOs, assetID);
    final tot = getOutputTotals(assetUTXOs);
    res[assetID] = tot;
  }

  return HistoryBaseTxTokenLossGain(res);
}

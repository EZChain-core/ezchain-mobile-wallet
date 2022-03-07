import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/wallet/asset/assets.dart';
import 'package:wallet/ezc/wallet/asset/types.dart';
import 'package:wallet/ezc/wallet/explorer/ortelius/types.dart';
import 'package:wallet/ezc/wallet/explorer/ortelius/utxo_utils.dart';
import 'package:wallet/ezc/wallet/history/history_helpers.dart';
import 'package:wallet/ezc/wallet/history/types.dart';
import 'package:wallet/ezc/wallet/network/utils.dart';
import 'package:wallet/ezc/wallet/utils/fee_utils.dart';

Future<HistoryBaseTx> getBaseTxSummary(
  OrteliusTx tx,
  List<String> ownerAddresses,
) async {
  // final ins = tx.inputs?.map((input) => input.output).toList() ?? [];
  // final outs = tx.outputs ?? [];
  //
  // /// Calculate losses from inputs
  // final losses = getOwnedTokens(ins, ownerAddresses);
  // final gains = getOwnedTokens(outs, ownerAddresses);
  //
  // final nowOwnedIns = getNotOwnedOutputs(ins, ownerAddresses);
  // final nowOwnedOuts = getNotOwnedOutputs(outs, ownerAddresses);
  //
  // final froms = getOutputsAssetOwners(nowOwnedIns);
  // final tos = getOutputsAssetOwners(nowOwnedOuts);

  // final tokens = <HistoryBaseTxToken>[];
  // tokens.addAll(await getBaseTxTokensSummary(gains, losses, froms, tos));

  final losses = await _getLoss(tx, ownerAddresses);
  final profits = await _getProfit(tx, ownerAddresses);

  final tokens = <String, HistoryBaseTxToken>{};

  tokens.addAll(losses.map((assetId, loss) {
    loss.amount *= BigInt.from(-1);
    return MapEntry(assetId, loss);
  }));

  profits.forEach((assetId, profit) {
    final token = tokens[assetId];
    if (token != null) {
      token.amount += profit.amount;
    } else {
      tokens[assetId] = profit;
    }
  });

  final nftLoss = _getLossNFT(tx, ownerAddresses);
  final nftGain = _getGainNFT(tx, ownerAddresses);

  return HistoryBaseTx(
    id: tx.id,
    fee: getTxFeeX(),
    type: HistoryItemTypeName.transaction,
    timestamp: tx.timestamp,
    memo: parseMemo(tx.memo),
    tokens: tokens.values.toList(),
    collectibles: HistoryBaseTxNFT(
      sent: nftLoss,
      received: nftGain,
    ),
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
    if (id == getAvaxAssetId() && tokenLost > BigInt.zero) {
      tokenLost -= getTxFeeX();
    }

    /// How much we gained/lost of this token
    final diff = tokenGain - tokenLost;
    // final diffClean = bnToLocaleString(
    //   diff,
    //   decimals: int.tryParse(tokenDesc.denomination) ?? 0,
    // );

    /// If we didnt gain or lose anything, ignore this token
    if (diff == BigInt.zero) continue;

    if (diff.isNegative) {
      res.add(HistoryBaseTxToken(
        diff,
        tos.result[id] ?? [],
        tokenDesc,
      ));
    } else {
      res.add(HistoryBaseTxToken(
        diff,
        froms.result[id] ?? [],
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
  List<OrteliusTxOutput> utxos,
  List<String> ownerAddresses,
) {
  final tokenUTXOs = getOutputsOfType(utxos, SECPXFEROUTPUTID);

  /// Owned inputs
  final myUTXOs = getOwnedOutputs(tokenUTXOs, ownerAddresses);

  /// Asset IDs received
  final assetIds = getOutputsAssetIds(myUTXOs);

  final res = <String, BigInt>{};

  for (var i = 0; i < assetIds.length; i++) {
    final assetID = assetIds[i];
    final assetUTXOs = getAssetOutputs(myUTXOs, assetID);
    final tot = getOutputTotals(assetUTXOs);
    res[assetID] = tot;
  }

  return HistoryBaseTxTokenLossGain(res);
}

Future<Map<String, HistoryBaseTxToken>> _getLoss(
  OrteliusTx tx,
  List<String> ownerAddresses,
) async {
  final ins = tx.inputs ?? [];
  final outs = tx.outputs ?? [];

  final loss = <String, HistoryBaseTxToken>{};

  for (var input in ins) {
    final utxo = input.output;
    if (utxo.outputType == NFTXFEROUTPUTID) {
      continue;
    }

    final addresses = utxo.addresses ?? [];

    final intersect =
        addresses.where((address) => ownerAddresses.contains(address));

    if (intersect.isEmpty) {
      continue;
    }

    final assetId = utxo.assetId;
    final amount = BigInt.tryParse(utxo.amount) ?? BigInt.zero;
    final receivers = <String>[];
    for (var output in outs) {
      if (output.assetId == assetId) {
        final outAddresses = output.addresses ?? [];
        final targets = outAddresses
            .where((address) =>
                !ownerAddresses.contains(address) &&
                !receivers.contains(address))
            .toList();
        if (targets.isNotEmpty) {
          receivers.addAll(targets);
        }
      }
    }
    await _addToDict(assetId, amount, loss, utxo, receivers);
  }

  return loss;
}

Future<Map<String, HistoryBaseTxToken>> _getProfit(
  OrteliusTx tx,
  List<String> ownerAddresses,
) async {
  final ins = tx.inputs ?? [];
  final outs = tx.outputs ?? [];

  final profit = <String, HistoryBaseTxToken>{};

  for (var utxo in outs) {
    if (utxo.outputType == NFTXFEROUTPUTID) {
      continue;
    }

    final addresses = utxo.addresses ?? [];

    final intersect =
        addresses.where((address) => ownerAddresses.contains(address));

    if (intersect.isEmpty) {
      continue;
    }

    final assetId = utxo.assetId;
    final amount = BigInt.tryParse(utxo.amount) ?? BigInt.zero;
    final senders = <String>[];
    for (var input in ins) {
      final output = input.output;
      if (output.assetId == assetId) {
        final outAddresses = output.addresses ?? [];
        final targets = outAddresses
            .where((address) =>
                !ownerAddresses.contains(address) && !senders.contains(address))
            .toList();
        if (targets.isNotEmpty) {
          senders.addAll(targets);
        }
      }
    }
    await _addToDict(assetId, amount, profit, utxo, senders);
  }

  return profit;
}

_addToDict(
  String assetId,
  BigInt amount,
  Map<String, HistoryBaseTxToken> dict,
  OrteliusTxOutput utxo,
  List<String> addresses,
) async {
  final txAssetSum = dict[assetId];
  if (txAssetSum != null) {
    txAssetSum.amount += amount;
    final diffAddresses =
        addresses.where((address) => !txAssetSum.addresses.contains(address));
    txAssetSum.addresses.addAll(diffAddresses);
  } else {
    final asset = await getAssetDescription(assetId);
    dict[assetId] = HistoryBaseTxToken(
      amount,
      addresses,
      asset,
    );
  }
}

HistoryBaseTxNFTSummaryResultDict _getLossNFT(
  OrteliusTx tx,
  List<String> ownerAddresses,
) {
  final inputs = tx.inputs ?? [];
  final outputs = tx.outputs ?? [];

  final nftIns = inputs
      .where((input) => input.output.outputType == NFTXFEROUTPUTID)
      .toList();

  final nftOuts =
      outputs.where((output) => output.outputType == NFTXFEROUTPUTID).toList();

  final loss = HistoryBaseTxNFTSummaryResultDict({}, []);

  for (var input in nftIns) {
    final utxo = input.output;
    final owners = utxo.addresses ?? [];
    final assetId = utxo.assetId;

    final intersect =
        owners.where((address) => ownerAddresses.contains(address)).toList();

    if (intersect.isNotEmpty) {
      if (loss.assets.keys.contains(assetId)) {
        loss.assets[assetId]!.add(utxo);
      } else {
        loss.assets[assetId] = [utxo];
      }
      for (var nftOut in nftOuts) {
        final doesMatch =
            nftOut.groupId == utxo.groupId && nftOut.assetId == utxo.assetId;
        final addressNotAdded = (nftOut.addresses ?? [])
            .where((address) => !loss.addresses.contains(address))
            .toList();
        if (doesMatch && addressNotAdded.isNotEmpty) {
          loss.addresses.addAll(addressNotAdded);
          break;
        }
      }
    }
  }

  return loss;
}

HistoryBaseTxNFTSummaryResultDict _getGainNFT(
  OrteliusTx tx,
  List<String> ownerAddresses,
) {
  final inputs = tx.inputs ?? [];
  final outputs = tx.outputs ?? [];
  final nftIns = inputs
      .where((input) => input.output.outputType == NFTXFEROUTPUTID)
      .toList();

  final nftOuts =
      outputs.where((output) => output.outputType == NFTXFEROUTPUTID).toList();

  final gain = HistoryBaseTxNFTSummaryResultDict({}, []);

  for (var utxo in nftOuts) {
    final owners = utxo.addresses ?? [];
    final assetId = utxo.assetId;

    final intersect =
        owners.where((address) => ownerAddresses.contains(address)).toList();

    if (intersect.isNotEmpty) {
      if (gain.assets.keys.contains(assetId)) {
        gain.assets[assetId]!.add(utxo);
      } else {
        gain.assets[assetId] = [utxo];
      }
      for (var nftIn in nftIns) {
        final output = nftIn.output;
        final doesMatch =
            output.groupId == utxo.groupId && output.assetId == utxo.assetId;
        final addressNotAdded = (output.addresses ?? [])
            .where((address) => !gain.addresses.contains(address))
            .toList();
        if (doesMatch && addressNotAdded.isNotEmpty) {
          gain.addresses.addAll(addressNotAdded);
          break;
        }
      }
    }
  }
  return gain;
}

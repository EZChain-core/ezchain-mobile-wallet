import 'dart:convert';

import 'package:wallet/roi/wallet/history/raw_types.dart';

List<String> filterDuplicateStrings(List<String> values) {
  final res = <String>[];
  for (var i = 0; i < values.length; i++) {}
  return res;
}

String findSourceChain(Transaction tx) {
  final baseChain = tx.chainId;
  final ins = tx.inputs ?? [];

  for (var i = 0; i < ins.length; i++) {
    final inChainId = ins[i].output.inChainId;
    if (inChainId != baseChain) return inChainId;
  }
  return baseChain;
}

/// Returns the destination chain id.
/// @param tx Tx data from the explorer.
String findDestinationChain(Transaction tx) {
  final baseChain = tx.chainId;
  final outs = tx.outputs ?? [];

  for (var i = 0; i < outs.length; i++) {
    final outChainId = outs[i].outChainId;
    if (outChainId != baseChain) return outChainId;
  }
  return baseChain;
}

bool isArraysOverlap(List<dynamic> arr1, List<dynamic> arr2) {
  final overlaps = arr1.where((item) => arr2.contains(item));
  return overlaps.isNotEmpty;
}

bool isOutputOwnerC(String ownerAddress, TransactionOutput output) {
  final outAddresses = output.cAddresses;
  if (outAddresses == null) return false;
  return outAddresses.contains(ownerAddress);
}

/// To get the stake amount, sum the non-reward output utxos.
BigInt getStakeAmount(Transaction tx) {
  final outs = tx.outputs ?? [];
  final nonRewardUtxos =
      outs.where((utxo) => !utxo.rewardUtxo && utxo.stake != null).toList();
  return getOutputTotals(nonRewardUtxos);
}

/// Returns UTXOs not owned by the given addresses
/// @param outs UTXOs to filter
/// @param myAddresses Addresses to filter by
List<TransactionOutput> getNotOwnedOutputs(
  List<TransactionOutput> outs,
  List<String> myAddresses,
) {
  return outs.where((out) {
    final outAddresses = out.addresses ?? [];
    return !isArraysOverlap(myAddresses, outAddresses);
  }).toList();
}

List<TransactionOutput> getRewardOuts(List<TransactionOutput> outs) {
  return outs.where((out) => out.rewardUtxo).toList();
}

BigInt getOutputTotals(List<TransactionOutput> outs) {
  return outs.fold<BigInt>(
      BigInt.zero, (acc, out) => acc + BigInt.parse(out.amount));
}

/// Returns only the UTXOs of the given asset id.
/// @param outs
/// @param assetID
List<TransactionOutput> getAssetOutputs(
  List<TransactionOutput> outs,
  String assetId,
) {
  return outs.where((out) => out.assetId == assetId).toList();
}

/// Returns UTXOs owned by the given addresses
/// @param outs UTXOs to filter
/// @param myAddresses Addresses to filter by
List<TransactionOutput> getOwnedOutputs(
  List<TransactionOutput> outs,
  List<String> myAddresses,
) {
  return outs.where((out) {
    final outAddresses = out.addresses ?? [];
    return isArraysOverlap(myAddresses, outAddresses);
  }).toList();
}

BigInt getEvmAssetBalanceFromUTXOs(
  List<TransactionOutput> utxos,
  String address,
  String assetId,
  String chainId, {
  bool isStake = false,
}) {
  final myOuts = utxos.where((utxo) =>
      assetId == utxo.assetId &&
      isOutputOwnerC(address, utxo) &&
      chainId == utxo.chainId &&
      utxo.stake == isStake);

  return myOuts.fold<BigInt>(
      BigInt.zero, (acc, utxo) => acc + BigInt.parse(utxo.amount));
}

String parseMemo(String? memo) {
  if (memo == null) return "";
  final memoText = utf8.decode(base64.decode(memo));
  // Bug that sets memo to empty string (AAAAAA==) for some tx types
  if (memo == 'AAAAAA==') return "";
  return memoText;
}

/// Returns outputs belonging to the given chain ID
/// @param outs UTXOs to filter
/// @param chainID Chain ID to filter by
List<TransactionOutput> getOutputsOfChain(
  List<TransactionOutput> outs,
  String chainId,
) {
  return outs.where((out) => out.chainId == chainId).toList();
}

/// Returns an array of Asset IDs from the given UTXOs
/// @param outs Array of UTXOs
List<String> getOutputsAssetIds(List<TransactionOutput> outs) {
  final res = <String>[];
  for (var i = 0; i < outs.length; i++) {
    res.add(outs[i].assetId);
  }
  return res.toSet().toList();
}

/// Returns addresses of the given UTXOs
/// @param outs UTXOs to get the addresses of.
List<String> getAddresses(List<TransactionOutput> outs) {
  final allAddresses = <String>[];

  for (var i = 0; i < outs.length; i++) {
    final out = outs[i];
    final addresses = out.addresses ?? [];
    allAddresses.addAll(addresses);
  }

  /// Remove duplicated
  return allAddresses.toSet().toList();
}

/// Returns a map of asset id to owner addresses
/// @param outs
getOutputsAssetOwners(List<TransactionOutput> outs) {
  final assetIds = getOutputsAssetIds(outs);
  final res = {};

  for (var i = 0; i < assetIds.length; i++) {
    final id = assetIds[i];
    final assetUTXOs = getAssetOutputs(outs, id);
    final address = getAddresses(assetUTXOs);
    res[id] = address;
  }

  return res;
}

/// Filters the UTXOs of a certain output type
/// @param outs UTXOs to filter
/// @param type Output type to filter by
List<TransactionOutput> getOutputsOfType(
  List<TransactionOutput> outs,
  int type,
) {
  return outs.where((out) => out.outputType == type).toList();
}

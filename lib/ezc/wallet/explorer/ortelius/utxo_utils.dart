import 'package:wallet/ezc/wallet/explorer/ortelius/types.dart';
import 'package:wallet/ezc/wallet/history/types.dart';

bool isArraysOverlap(List<dynamic> arr1, List<dynamic> arr2) {
  final overlaps = arr1.where((item) => arr2.contains(item));
  return overlaps.isNotEmpty;
}

/// Returns true if this utxo is owned by any of the given addresses
/// @param ownerAddrs Addresses to check against
/// @param output The UTXO
bool isOutputOwnerC(String ownerAddress, OrteliusTxOutput output) {
  final outAddresses = output.cAddresses;
  if (outAddresses == null) return false;
  return outAddresses.contains(ownerAddress);
}

/// Returns the total amount of `assetID` in the given `utxos` owned by `address`. Checks for EVM address.
/// @param utxos UTXOs to calculate balance from.
/// @param address The wallet's  evm address `0x...`.
/// @param assetID Only count outputs of this asset ID.
/// @param chainID Only count the outputs on this chain.
/// @param isStake Set to `true` if looking for staking utxos.
BigInt getEvmAssetBalanceFromUTXOs(
  List<OrteliusTxOutput> utxos,
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

/// Returns UTXOs owned by the given addresses
/// @param outs UTXOs to filter
/// @param myAddresses Addresses to filter by
List<OrteliusTxOutput> getOwnedOutputs(
  List<OrteliusTxOutput> outs,
  List<String> myAddresses,
) {
  return outs.where((out) {
    final outAddresses = out.addresses ?? [];
    return isArraysOverlap(myAddresses, outAddresses);
  }).toList();
}

/// Returns addresses of the given UTXOs
/// @param outs UTXOs to get the addresses of.
List<String> getAddresses(List<OrteliusTxOutput> outs) {
  final allAddresses = <String>[];

  for (var i = 0; i < outs.length; i++) {
    final out = outs[i];
    final addresses = out.addresses ?? [];
    allAddresses.addAll(addresses);
  }

  /// Remove duplicated
  return allAddresses.toSet().toList();
}

/// Returns only the UTXOs of the given asset id.
/// @param outs
/// @param assetID
List<OrteliusTxOutput> getAssetOutputs(
  List<OrteliusTxOutput> outs,
  String assetId,
) {
  return outs.where((out) => out.assetId == assetId).toList();
}

/// Returns UTXOs not owned by the given addresses
/// @param outs UTXOs to filter
/// @param myAddresses Addresses to filter by
List<OrteliusTxOutput> getNotOwnedOutputs(
  List<OrteliusTxOutput> outs,
  List<String> myAddresses,
) {
  return outs.where((out) {
    final outAddresses = out.addresses ?? [];
    return !isArraysOverlap(myAddresses, outAddresses);
  }).toList();
}

BigInt getOutputTotals(List<OrteliusTxOutput> outs) {
  return outs.fold<BigInt>(
      BigInt.zero, (acc, out) => acc + BigInt.parse(out.amount));
}

List<OrteliusTxOutput> getRewardOuts(List<OrteliusTxOutput> outs) {
  return outs.where((out) => out.rewardUtxo).toList();
}

/// Returns outputs belonging to the given chain ID
/// @param outs UTXOs to filter
/// @param chainID Chain ID to filter by
List<OrteliusTxOutput> getOutputsOfChain(
  List<OrteliusTxOutput> outs,
  String chainId,
) {
  return outs.where((out) => out.chainId == chainId).toList();
}

/// Filters the UTXOs of a certain output type
/// @param outs UTXOs to filter
/// @param type Output type to filter by
List<OrteliusTxOutput> getOutputsOfType(
  List<OrteliusTxOutput> outs,
  int type,
) {
  return outs.where((out) => out.outputType == type).toList();
}

/// Returns an array of Asset IDs from the given UTXOs
/// @param outs Array of UTXOs
List<String> getOutputsAssetIds(List<OrteliusTxOutput> outs) {
  final res = <String>[];
  for (var i = 0; i < outs.length; i++) {
    res.add(outs[i].assetId);
  }
  return res.toSet().toList();
}

/// Returns a map of asset id to owner addresses
/// @param outs
HistoryBaseTxTokenOwners getOutputsAssetOwners(List<OrteliusTxOutput> outs) {
  final assetIds = getOutputsAssetIds(outs);
  final res = <String, List<String>>{};

  for (var i = 0; i < assetIds.length; i++) {
    final id = assetIds[i];
    final assetUTXOs = getAssetOutputs(outs, id);
    final address = getAddresses(assetUTXOs);
    res[id] = address;
  }

  return HistoryBaseTxTokenOwners(res);
}

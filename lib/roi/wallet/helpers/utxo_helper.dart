import 'package:wallet/roi/sdk/apis/avm/model/get_utxos.dart' as avmUTXOs;
import 'package:wallet/roi/sdk/apis/pvm/model/get_utxos.dart' as pvmUTXOs;
import 'package:wallet/roi/sdk/apis/avm/utxos.dart';
import 'package:wallet/roi/sdk/apis/pvm/utxos.dart';
import 'package:wallet/roi/wallet/network/network.dart';

Future<AvmUTXOSet> avmGetAllUTXOs({List<String> addresses = const []}) async {
  if (addresses.length < 1024) {
    return await avmGetAllUTXOsForAddresses(addresses: addresses);
  } else {
    final chunk = addresses.sublist(0, 1024);
    final remainingChunk = addresses.sublist(1024);

    final newSet = await avmGetAllUTXOsForAddresses(addresses: chunk);
    return newSet.merge(await avmGetAllUTXOs(addresses: remainingChunk))
        as AvmUTXOSet;
  }
}

Future<AvmUTXOSet> avmGetAllUTXOsForAddresses(
    {List<String> addresses = const [], dynamic endIndex}) async {
  assert(addresses.length <= 1024, "Maximum length of addresses is 1024");
  final avmUTXOs.GetUTXOsResponse response;
  if (endIndex != null) {
    response = await xChain.getUTXOs(addresses);
  } else {
    response = await xChain.getUTXOs(addresses, limit: 0, startIndex: endIndex);
  }

  final utxoSet = response.getUTXOs();
  final nextEndIndex = response.endIndex;
  final length = int.parse(response.numFetched);

  if (length > 1024) {
    final subUtxos = await avmGetAllUTXOsForAddresses(
        addresses: addresses, endIndex: nextEndIndex);
    return utxoSet.merge(subUtxos) as AvmUTXOSet;
  }

  return utxoSet;
}

Future<PvmUTXOSet> pvmGetAllUTXOs({List<String> addresses = const []}) async {
  if (addresses.length < 1024) {
    return await pvmGetAllUTXOsForAddresses(addresses: addresses);
  } else {
    final chunk = addresses.sublist(0, 1024);
    final remainingChunk = addresses.sublist(1024);

    final newSet = await pvmGetAllUTXOsForAddresses(addresses: chunk);
    return newSet.merge(await pvmGetAllUTXOs(addresses: remainingChunk))
    as PvmUTXOSet;
  }
}

Future<PvmUTXOSet> pvmGetAllUTXOsForAddresses(
    {List<String> addresses = const [], dynamic endIndex}) async {
  assert(addresses.length <= 1024, "Maximum length of addresses is 1024");
  final pvmUTXOs.GetUTXOsResponse response;
  if (endIndex != null) {
    response = await pChain.getUTXOs(addresses);
  } else {
    response = await pChain.getUTXOs(addresses, limit: 0, startIndex: endIndex);
  }

  final utxoSet = response.getUTXOs();
  final nextEndIndex = response.endIndex;
  final length = int.parse(response.numFetched);

  if (length > 1024) {
    final subUtxos = await pvmGetAllUTXOsForAddresses(addresses: addresses, endIndex: nextEndIndex);
    return utxoSet.merge(subUtxos) as PvmUTXOSet;
  }

  return utxoSet;
}
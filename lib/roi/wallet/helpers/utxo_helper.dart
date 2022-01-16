import 'package:wallet/roi/sdk/apis/avm/model/get_utxos.dart' as avm_utxos;
import 'package:wallet/roi/sdk/apis/pvm/model/get_stake.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_utxos.dart' as pvm_utxos;
import 'package:wallet/roi/sdk/apis/avm/utxos.dart';
import 'package:wallet/roi/sdk/apis/pvm/utxos.dart';
import 'package:wallet/roi/sdk/apis/evm/utxos.dart';
import 'package:wallet/roi/wallet/network/helpers/id_from_alias.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/types.dart';

Future<AvmUTXOSet> avmGetAtomicUTXOs(
  List<String> addresses,
  ExportChainsX sourceChain,
) async {
  final sourceChainId = chainIdFromAlias(sourceChain.value);
  if (addresses.length < 1024) {
    return (await xChain.getUTXOs(addresses, sourceChain: sourceChainId))
        .getUTXOs();
  } else {
    final selection = addresses.sublist(0, 1024);
    final remaining = addresses.sublist(1024);
    var utxoSet = (await xChain.getUTXOs(selection, sourceChain: sourceChainId))
        .getUTXOs();
    if (remaining.isNotEmpty) {
      final nextSet = await avmGetAtomicUTXOs(remaining, sourceChain);
      utxoSet = utxoSet.merge(nextSet) as AvmUTXOSet;
    }
    return utxoSet;
  }
}

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

Future<AvmUTXOSet> avmGetAllUTXOsForAddresses({
  List<String> addresses = const [],
  dynamic endIndex,
}) async {
  if (addresses.length > 1024) {
    throw Exception("Maximum length of addresses is 1024");
  }
  final avm_utxos.GetUTXOsResponse response;
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

Future<PvmUTXOSet> pvmGetAllUTXOsForAddresses({
  List<String> addresses = const [],
  dynamic endIndex,
}) async {
  if (addresses.length > 1024) {
    throw Exception("Maximum length of addresses is 1024");
  }
  final pvm_utxos.GetUTXOsResponse response;
  if (endIndex != null) {
    response = await pChain.getUTXOs(addresses);
  } else {
    response = await pChain.getUTXOs(addresses, limit: 0, startIndex: endIndex);
  }

  final utxoSet = response.getUTXOs();
  final nextEndIndex = response.endIndex;
  final length = int.parse(response.numFetched);

  if (length > 1024) {
    final subUtxos = await pvmGetAllUTXOsForAddresses(
        addresses: addresses, endIndex: nextEndIndex);
    return utxoSet.merge(subUtxos) as PvmUTXOSet;
  }

  return utxoSet;
}

Future<GetStakeResponse> getStakeForAddresses(List<String> addresses) async {
  if (addresses.length <= 256) {
    return await pChain.getStake(addresses);
  } else {
    final chunk = addresses.sublist(0, 256);
    final remainingChunk = addresses.sublist(256);

    final chunkData = await pChain.getStake(chunk);
    final chunkStake = chunkData.staked;
    final chunkUtxos = chunkData.stakedOutputs;

    final next = await getStakeForAddresses(remainingChunk);

    final finalStaked = chunkStake + next.staked;
    final finalStakedOutputs = [...chunkUtxos, ...next.stakedOutputs];
    return GetStakeResponse(
        staked: finalStaked, stakedOutputs: finalStakedOutputs);
  }
}

Future<PvmUTXOSet> platformGetAtomicUTXOs(
  List<String> addresses,
  ExportChainsP sourceChain,
) async {
  final sourceChainId = chainIdFromAlias(sourceChain.value);
  if (addresses.length < 1024) {
    return (await pChain.getUTXOs(addresses, sourceChain: sourceChainId))
        .getUTXOs();
  } else {
    final selection = addresses.sublist(0, 1024);
    final remaining = addresses.sublist(1024);
    var utxoSet = (await pChain.getUTXOs(selection, sourceChain: sourceChainId))
        .getUTXOs();
    if (remaining.isNotEmpty) {
      final nextSet = await platformGetAtomicUTXOs(remaining, sourceChain);
      utxoSet = utxoSet.merge(nextSet) as PvmUTXOSet;
    }
    return utxoSet;
  }
}

Future<EvmUTXOSet> evmGetAtomicUTXOs(
  List<String> addresses,
  ExportChainsC sourceChain,
) async {
  if (addresses.length > 1024) {
    throw Exception("Number of addresses can not be greater than 1024.");
  }
  final sourceChainId = chainIdFromAlias(sourceChain.value);
  return (await cChain.getUTXOs(addresses, sourceChain: sourceChainId))
      .getUTXOs();
}

import 'package:wallet/ezc/wallet/explorer/ortelius/rest_client.dart';
import 'package:wallet/ezc/wallet/explorer/ortelius/types.dart';
import 'package:wallet/ezc/wallet/network/network.dart' as ezc_network;

/// Returns transactions FROM and TO the address given
/// @param address The address to get historic transactions for.
Future<List<OrteliusEvmTx>> getAddressHistoryEVM(String address) async {
  final explorerApi = ezc_network.explorerApi;
  if (explorerApi == null) throw Exception("Explorer API not found.");
  final explorerClient = OrteliusRestClient(explorerApi);
  final response = await explorerClient.getEvmTransactions(address);
  // TODO handle sort
  return response.transactions ?? [];
}

/// Returns ortelius data for a transaction hash on C chain EVM,
/// @param txHash
Future<OrteliusEvmTx> getEvmTx(String txHash) async {
  final explorerApi = ezc_network.explorerApi;
  if (explorerApi == null) throw Exception("Explorer API not found.");
  final explorerClient = OrteliusRestClient(explorerApi);
  final response = await explorerClient.getEvmTransaction(txHash);
  // TODO handle exception
  return response.transactions![0];
}

/// Returns, X or P chain transactions belonging to the given address array.
/// @param addresses Addresses to check for. Max number of addresses is 1024
/// @param limit
/// @param chainID The blockchain ID of X or P chain
/// @param endTime
Future<List<OrteliusTx>> getTransactions(
  String chainId,
  List<String> addresses, {
  int limit = 20,
  String? endTime,
}) async {
  final explorerApi = ezc_network.explorerApi;
  if (explorerApi == null) throw Exception("Explorer API not found.");
  final explorerClient = OrteliusRestClient(explorerApi);
  if (addresses.length > 1024) {
    throw Exception("Number of addresses can not exceed 1024.");
  }

  final addressesRaw =
      addresses.map((address) => address.split('-')[1]).toList();

  final request = GetOrteliusTxsRequest(
    addressesRaw,
    ["timestamp-desc"],
    ["1"],
    [chainId],
    ["false"],
    limit > 0 ? [limit.toString()] : null,
    endTime == null ? null : [endTime],
  );

  final response = await explorerClient.getTransactions(request);
  final transactions = response.transactions ?? [];
  var next = response.next;

  /// If we need to fetch more for this address
  if (next != null && next.isNotEmpty) {
    final endTime = next.split('&')[0].split('=')[1];
    final nextResponse = await getAddressHistory(
      chainId,
      addresses,
      limit: limit,
      endTime: endTime,
    );
    transactions.addAll(nextResponse);
  }

  return transactions;
}

/// Returns, X or P chain transactions belonging to the given address array.
/// @param addresses Addresses to check for.
/// @param limit
/// @param chainID The blockchain ID of X or P chain
/// @param endTime
Future<List<OrteliusTx>> getAddressHistory(
  String chainId,
  List<String> addresses, {
  int limit = 20,
  String? endTime,
}) async {
  final explorerApi = ezc_network.explorerApi;
  if (explorerApi == null) throw Exception("Explorer API not found.");
  const addressSize = 1024;
  final addressesChunks = <List<String>>[];
  if (addresses.length > addressSize) {
    for (var i = 0; i < addresses.length; i += addressSize) {
      final chunk = addresses.sublist(i, i + addressSize);
      addressesChunks.add(chunk);
    }
  } else {
    addressesChunks.add(addresses);
  }

  /// Get histories in parallel
  final promises = addressesChunks.map((chunk) =>
      getTransactions(chainId, chunk, limit: limit, endTime: endTime));

  final results = await Future.wait(promises);
  return results.fold<List<OrteliusTx>>([], (acc, txs) => [...acc, ...txs]);
}

/// Returns the ortelius data from the given tx id.
/// @param txID
Future<OrteliusTx> getTx(String txId) async {
  final explorerApi = ezc_network.explorerApi;
  if (explorerApi == null) throw Exception("Explorer API not found.");
  final explorerClient = OrteliusRestClient(explorerApi);
  return await explorerClient.getTransaction(txId);
}

import 'package:wallet/roi/wallet/explorer/ortelius/ortelius_rest_client.dart';
import 'package:wallet/roi/wallet/explorer/ortelius/types.dart';
import 'package:wallet/roi/wallet/network/network.dart' as ezc_network;

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

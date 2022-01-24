import 'package:wallet/roi/wallet/explorer/ortelius/ortelius_rest_client.dart';
import 'package:wallet/roi/wallet/explorer/ortelius/types.dart';
import 'package:wallet/roi/wallet/network/network.dart' as ezc_network;

Future<List<OrteliusTx>> getAddressHistory(
  String chainId,
  List<String> addresses, {
  int limit = 20,
  String? endTime,
}) async {
  final explorerApi = ezc_network.explorerApi;
  if (explorerApi == null) throw Exception("Explorer API not found.");
  final explorerClient = OrteliusRestClient(explorerApi);
  const addressSize = 1024;
  var selection = addresses;
  var remaining = <String>[];
  if (addresses.length > addressSize) {
    selection = addresses.sublist(0, addressSize);
    remaining = addresses.sublist(addressSize);
  }
  final addressesRaw =
      selection.map((address) => address.split('-')[1]).toList();

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
  final transactions = response.transactions;
  final next = response.next;

  /// If we need to fetch more for this address
  if (next != null && next.isNotEmpty) {
    final endTime = next.split('&')[0].split('=')[1];
    final nextResponse = await getAddressHistory(
      chainId,
      remaining,
      limit: limit,
      endTime: endTime,
    );
    transactions.addAll(nextResponse);
  }

  /// If there are addresses left, fetch them too
  if (remaining.isNotEmpty) {
    final nextResponse = await getAddressHistory(
      chainId,
      remaining,
      limit: limit,
    );
    transactions.addAll(nextResponse);
  }

  return transactions;
}

/// Returns the ortelius data from the given tx id.
/// @param txID
Future<OrteliusTx> getTx(String txId) async {
  final explorerApi = ezc_network.explorerApi;
  if (explorerApi == null) throw Exception("Explorer API not found.");
  final explorerClient = OrteliusRestClient(explorerApi);
  return await explorerClient.getTransaction(txId);
}

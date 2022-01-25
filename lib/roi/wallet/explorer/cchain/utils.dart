import 'package:wallet/roi/wallet/explorer/cchain/types.dart';

/// Filter duplicate CChain-Explorer transactions
/// @param txs
List<CChainExplorerTx> filterDuplicateTransactions(List<CChainExplorerTx> txs) {
  final hashes = txs.map((tx) => tx.hash).toList();
  final distinct = <CChainExplorerTx>[];
  for (int i = 0; i < txs.length; i++) {
    final tx = txs[i];
    if (hashes.indexOf(tx.hash) == i) {
      distinct.add(tx);
    }
  }
  return distinct;
}

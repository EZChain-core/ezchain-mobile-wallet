import 'package:wallet/ezc/wallet/explorer/cchain/types.dart';

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

/// Filter duplicate ERC20 transactions
/// @param txs
List<CChainErc20Tx> filterDuplicateERC20Txs(List<CChainErc20Tx> txs) {
  final hashes = txs.map((tx) => tx.hash).toList();
  final distinct = <CChainErc20Tx>[];
  for (int i = 0; i < txs.length; i++) {
    final tx = txs[i];
    if (hashes.indexOf(tx.hash) == i) {
      distinct.add(tx);
    }
  }
  return distinct;
}

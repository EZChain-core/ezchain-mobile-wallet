import 'package:mobx/mobx.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/explorer/cchain/types.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/chain_type/ezc_type.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/transaction/transactions_item.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';

part 'transactions_ant_store.g.dart';

class TransactionsAntStore = _TransactionsAntStore with _$TransactionsAntStore;

abstract class _TransactionsAntStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  String get addressX => _wallet.getAddressX();
  String get addressC => _wallet.getAddressC();

  Future<List<TransactionsItem>> getTransactions(WalletTokenItem token) async {
    try {
      if (token.type == EZCTokenType.ant) {
        final assetId = token.id;
        if (assetId == null) return [];
        final transactions = await _wallet.getXTransactions();
        final filteredTransactions = transactions
            .where((element) =>
                element.inputTotals.keys.contains(assetId) ||
                element.outputTotals.keys.contains(assetId))
            .toList();
        return await mapToTransactionsItemsV2(filteredTransactions);
      } else {
        final contractAddress = token.id;
        if (contractAddress == null) return [];
        final transactions = await _wallet.getHistoryErc20(
          contractAddress: contractAddress,
        );
        return transactions
            .map((e) => mapErc20TransactionToTransactionsItem(e))
            .toList();
      }
    } catch (e) {
      logger.e(e);
      return [];
    }
  }
}

TransactionsItem mapErc20TransactionToTransactionsItem(CChainErc20Tx tx) {
  final amountBN = BigInt.tryParse(tx.value) ?? BigInt.zero;
  String? amount;
  if (amountBN != BigInt.zero) {
    final value = bnToAvaxC(amountBN);
    amount = '$value ${tx.tokenSymbol}';
  }
  final time = tx.timeStamp.parseDateTimeFromTimestamp()?.parseTimeAgo() ?? '';
  const transType = 'Transaction';
  final from = <TransactionsItemAddressInfo>[];
  if (tx.from.isNotEmpty) {
    from.add(TransactionsItemAddressInfo(tx.from));
  }
  final to = <TransactionsItemAddressInfo>[];
  if (tx.to.isNotEmpty) {
    to.add(TransactionsItemAddressInfo(tx.to, amount));
  }
  return TransactionsItem(tx.hash, time, transType, from, to, EZCType.cChain, tx.nonce);
}
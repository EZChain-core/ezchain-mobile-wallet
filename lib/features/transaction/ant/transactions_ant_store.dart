import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/ezc/wallet/explorer/ortelius/types.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/chain_type/ezc_type.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/features/common/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/transaction/transactions_item.dart';
import 'package:wallet/features/wallet/receive/wallet_receive.dart';

part 'transactions_ant_store.g.dart';

class TransactionsAntStore = _TransactionsAntStore with _$TransactionsAntStore;

abstract class _TransactionsAntStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  Future<List<TransactionsItem>> getTransactions(String assetId) async {
    try {
      final transactions = await _wallet.getXTransactions();
      final filteredTransactions = transactions
          .where((element) =>
      element.inputTotals.keys.contains(assetId) ||
          element.outputTotals.keys.contains(assetId))
          .toList();
      return await mapToTransactionsItemsV2(filteredTransactions);
    } catch (e) {
      logger.e(e);
      return [];
    }
  }
}

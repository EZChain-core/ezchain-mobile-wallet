import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/transaction/detail/transaction_detail_view_data.dart';

part 'transaction_detail_store.g.dart';

class TransactionDetailStore = _TransactionDetailStore
    with _$TransactionDetailStore;

abstract class _TransactionDetailStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  Future<TransactionDetailViewData?> getTransactionDetail(String txId) async {
    try {
      final transaction = await _wallet.getTransaction(txId);
      return transaction.mapToTransactionDetailViewData();
    } catch (e) {
      logger.e(e);
      return null;
    }
  }
}

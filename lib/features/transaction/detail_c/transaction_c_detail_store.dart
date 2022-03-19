import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/explorer/cchain/types.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/wallet_factory.dart';

part 'transaction_c_detail_store.g.dart';

class TransactionCDetailStore = _TransactionCDetailStore
    with _$TransactionCDetailStore;

abstract class _TransactionCDetailStore with Store {
  final _wallet = getIt<WalletFactory>().activeWallet;

  Future<TransactionCChainViewData?> getTransactionDetail(String txHash,
      String nonce, CChainExplorerTxReceiptStatus? receiptStatus) async {
    try {
      final tx = await _wallet.getCChainTransaction(txHash);
      return TransactionCChainViewData.mapFromCChainExplorerTxInfo(
          tx, nonce, receiptStatus);
    } catch (e) {
      logger.e(e);
      return null;
    }
  }
}

class TransactionCChainViewData {
  final String hash;
  final bool result;
  final bool? status;
  final String block;
  final String from;
  final String to;
  final String amount;
  final String fee;
  final String gasPrice;
  final String gasLimit;
  final String gasUsed;
  final String nonce;

  TransactionCChainViewData(
      this.hash,
      this.result,
      this.status,
      this.block,
      this.from,
      this.to,
      this.amount,
      this.fee,
      this.gasPrice,
      this.gasLimit,
      this.gasUsed,
      this.nonce);

  factory TransactionCChainViewData.mapFromCChainExplorerTxInfo(
      CChainExplorerTxInfo tx,
      String nonce,
      CChainExplorerTxReceiptStatus? receiptStatus) {
    final value = bnToAvaxC(BigInt.tryParse(tx.value) ?? BigInt.zero);
    final amount = '$value $ezcSymbol';
    final gasPrice = BigInt.tryParse(tx.gasPrice) ?? BigInt.zero;
    final gasPriceText = '${bnToAvaxX(gasPrice)} w$ezcSymbol';
    final gasUsed = BigInt.tryParse(tx.gasUsed) ?? BigInt.zero;
    final fee = '${bnToAvaxC(gasPrice * gasUsed)} $ezcSymbol';
    final result = tx.success;
    final status = receiptStatus != null
        ? receiptStatus == CChainExplorerTxReceiptStatus.ok
        : null;
    final block = '#${tx.blockNumber}';
    final gasUsedText =
        '${tx.gasUsed} | ${(int.parse(tx.gasUsed) ~/ int.parse(tx.gasLimit)) * 100}%';

    return TransactionCChainViewData(tx.hash, result, status, block, tx.from,
        tx.to, amount, fee, gasPriceText, tx.gasLimit, gasUsedText, nonce);
  }
}

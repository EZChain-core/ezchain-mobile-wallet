import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/explorer/cchain/types.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/wallet_factory.dart';

part 'transaction_c_detail_store.g.dart';

class TransactionCDetailStore = _TransactionCDetailStore
    with _$TransactionCDetailStore;

abstract class _TransactionCDetailStore with Store {
  final _walletFactory = getIt<WalletFactory>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  Future<TransactionCChainViewData?> getTransactionDetail(
    String txHash,
    String? contractAddress,
  ) async {
    try {
      final tx = await _wallet.getErc20Transaction(
        txHash,
        contractAddress: contractAddress,
      );
      return tx == null
          ? null
          : TransactionCChainViewData.mapFromCChainExplorerTxInfo(tx);
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
    this.nonce,
  );

  factory TransactionCChainViewData.mapFromCChainExplorerTxInfo(
    CChainErc20Tx tx,
  ) {
    final amountBN = tx.valueBN;
    final denomination = int.tryParse(tx.tokenDecimal) ?? 0;
    String amount =
        "${amountBN.toLocaleString(denomination: denomination)} ${tx.tokenSymbol}";
    final gasPrice = tx.gasPriceBN;
    final gasPriceText = '${gasPrice.toAvaxX()} wei';
    final gasUsed = tx.gasUsedBN;
    final fee = '${(gasPrice * gasUsed).toAvaxC()} $ezcSymbol';
    final result = tx.success ?? false;
    final status = (int.tryParse(tx.confirmations) ?? 0) > 0;
    final block = '#${tx.blockNumber}';
    final gasUsedText =
        '${tx.gasUsed} | ${((int.tryParse(tx.gasUsed) ?? 0) ~/ (int.tryParse(tx.gas) ?? 1)) * 100}%';

    return TransactionCChainViewData(
      tx.hash,
      result,
      status,
      block,
      tx.from,
      tx.to,
      amount,
      fee,
      gasPriceText,
      tx.gas,
      gasUsedText,
      tx.nonce,
    );
  }
}

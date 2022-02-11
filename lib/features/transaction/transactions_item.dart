import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/roi/wallet/explorer/cchain/types.dart';
import 'package:wallet/roi/wallet/history/types.dart';
import 'package:wallet/roi/wallet/network/utils.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class TransactionsItem {
  final String id;
  final String time;

  TransactionsItem(this.id, this.time);
}

class TransactionsBaseImportExportItem extends TransactionsItem {
  final String type;
  final String amount;
  final bool isIncrease;

  TransactionsBaseImportExportItem(
      String id, String time, this.type, this.amount, this.isIncrease)
      : super(id, time);
}

class TransactionsStakingItem extends TransactionsItem {
  final String stakeEndDate;
  final String rewardPending;
  final String addDelegator;
  final String addValidator;

  TransactionsStakingItem(String id, String time, this.stakeEndDate,
      this.rewardPending, this.addDelegator, this.addValidator)
      : super(id, time);
}

class TransactionsCChainItem extends TransactionsItem {
  final String blockNumber;
  final String from;
  final String to;
  final String amount;
  final String fee;
  final CChainExplorerTx cChainExplorerTx;

  TransactionsCChainItem(String id, String time, this.blockNumber, this.from,
      this.to, this.amount, this.fee, this.cChainExplorerTx)
      : super(id, time);
}

class TransactionsSendImportExportItemWidget extends StatelessWidget {
  final TransactionsBaseImportExportItem item;
  final VoidCallback onPressed;

  const TransactionsSendImportExportItemWidget(
      {Key? key, required this.item, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
            splashFactory: NoSplash.splashFactory),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.time,
                  style: EZCBodyLargeTextStyle(color: provider.themeMode.text),
                ),
                Assets.icons.icSearchBlack.svg()
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.type,
                  style:
                      EZCBodyLargeTextStyle(color: provider.themeMode.text60),
                ),
                Text(
                  item.amount,
                  style: EZCBodyLargeTextStyle(
                    color: item.isIncrease
                        ? provider.themeMode.stateSuccess
                        : provider.themeMode.stateDanger,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionsStakingItemWidget extends StatelessWidget {
  final TransactionsStakingItem item;
  final VoidCallback onPressed;

  const TransactionsStakingItemWidget(
      {Key? key, required this.item, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
            splashFactory: NoSplash.splashFactory),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.time,
                  style: EZCBodyLargeTextStyle(color: provider.themeMode.text),
                ),
                Assets.icons.icSearchBlack.svg()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionsCChainItemWidget extends StatelessWidget {
  final TransactionsCChainItem item;
  final VoidCallback onPressed;

  const TransactionsCChainItemWidget(
      {Key? key, required this.item, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i("vit ${item.id} ${item.time} ${item.from} ${item.to}");
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
            splashFactory: NoSplash.splashFactory),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.time,
                  style: EZCBodyLargeTextStyle(color: provider.themeMode.text),
                ),
                Assets.icons.icSearchBlack.svg()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionsItemViewData {
  final String txId;
  final String time;
  final String type;
  final String amount;
  final bool isIncrease;

  TransactionsItemViewData(
      this.txId, this.time, this.type, this.amount, this.isIncrease);
}

Widget buildTransactionWidget(TransactionsItem transaction) {
  if (transaction is TransactionsBaseImportExportItem) {
    return TransactionsSendImportExportItemWidget(
      item: transaction,
      onPressed: () {
        walletContext?.pushRoute(TransactionDetailRoute(txId: transaction.id));
      },
    );
  }
  if (transaction is TransactionsCChainItem) {
    return TransactionsCChainItemWidget(
      item: transaction,
      onPressed: () {
        walletContext?.pushRoute(TransactionCDetailRoute(
            cChainExplorerTx: transaction.cChainExplorerTx));
      },
    );
  }
  if (transaction is TransactionsStakingItem) {
    return TransactionsStakingItemWidget(
      item: transaction,
      onPressed: () {
        walletContext?.pushRoute(TransactionDetailRoute(txId: transaction.id));
      },
    );
  }
  return const SizedBox.shrink();
}

List<TransactionsItem> mapToTransactionsItem(List<HistoryItem> items,
    {List<Validator>? validators}) {
  final List<TransactionsItem> transactions = [];

  try {
    final result = items.where((tx) {
      if (tx is HistoryBaseTx) {
        return tx.tokens.isNotEmpty;
      } else if (tx is HistoryStaking) {
        return tx.type == HistoryItemTypeName.addValidator ||
            tx.type == HistoryItemTypeName.addDelegator;
      } else {
        return tx.type != HistoryItemTypeName.notSupported;
      }
    }).toList();
    for (var item in result) {
      final transId = item.id;
      final transTime = item.timestamp?.parseDateTime()?.parseTimeAgo() ?? '';
      String transAmount = '';
      String transType = '';
      bool transIncrease = false;

      if (item is HistoryBaseTx) {
        final token = item.tokens.firstWhereOrNull(
            (token) => token.asset.assetId == getAvaxAssetId());

        if (token == null || token.amount == BigInt.zero) {
          continue;
        }
        if (token.amount < BigInt.zero) {
          final amount = bnToLocaleString(
            token.amount - item.fee,
            decimals: int.tryParse(token.asset.denomination) ?? 0,
          );

          transType = Strings.current.sharedSent;
          transAmount = '$amount ${token.asset.symbol}';
          transIncrease = false;
        } else {
          transType = Strings.current.sharedReceived;
          transAmount = '${token.amountDisplayValue} ${token.asset.symbol}';
          transIncrease = true;
        }
        transactions.add(TransactionsBaseImportExportItem(
            transId, transTime, transType, transAmount, transIncrease));
      } else if (item is HistoryImportExport) {
        if (item.amount > BigInt.zero) {
          if (item.type == HistoryItemTypeName.import) {
            transType = Strings.current.sharedImport;
            transAmount = "${item.amountDisplayValue} EZC";
            transIncrease = true;
          } else if (item.type == HistoryItemTypeName.export) {
            final amount =
                bnToAvaxX((item.amount + item.fee) * BigInt.from(-1));

            transType = Strings.current.sharedExport;
            transAmount = '$amount EZC';
            transIncrease = false;
          }
        }
        transactions.add(TransactionsBaseImportExportItem(
            transId, transTime, transType, transAmount, transIncrease));
      } else if (item is HistoryStaking && validators != null) {
        String reward = '';
        String addValidator = '';
        String addDelegator = '';
        final stakeEndTime = DateTime.fromMillisecondsSinceEpoch(item.stakeEnd)
            .format('MM/dd/yyyy, HH:mm:ss a');
        String? potentialReward;
        final validator = validators.firstWhereOrNull((validator) {
          final nodeId = validator.nodeId.split("-")[1];
          return nodeId == item.nodeId;
        });
        if (validator != null) {
          if (item.type == HistoryItemTypeName.addValidator) {
            potentialReward = validator.potentialReward;
            addValidator = "${item.amountDisplayValue} EZC";
          } else {
            final delegators = validator.delegators;
            if (delegators != null) {
              final delegator = delegators
                  .firstWhere((delegator) => delegator.txId == item.id);
              potentialReward = delegator.potentialReward;
              addDelegator = "${item.amountDisplayValue} EZC";
            }
          }
          if (potentialReward != null) {
            reward =
                '${bnToAvaxP(BigInt.tryParse(potentialReward) ?? BigInt.zero)} EZC';
          }
        }
        transactions.add(TransactionsStakingItem(transId, transTime,
            stakeEndTime, reward, addDelegator, addValidator));
      }
    }
  } catch (e) {
    logger.e(e);
  }

  return transactions;
}

List<TransactionsItem> mapCChainToTransactionsItem(
    List<CChainExplorerTx> cTransactions) {
  final List<TransactionsItem> transactions = [];
  try {
    for (var tx in cTransactions) {
      final time =
          tx.timeStamp.parseDateTimeFromTimestamp()?.parseTimeAgo() ?? '';
      final blockNumber = '#${tx.blockNumber}';
      final value = bnToAvaxC(BigInt.tryParse(tx.value) ?? BigInt.zero);
      final gasPrice = BigInt.tryParse(tx.gasPrice) ?? BigInt.zero;
      final gasUsed = BigInt.tryParse(tx.gasUsed) ?? BigInt.zero;
      final fee = '${bnToAvaxC(gasPrice * gasUsed)} EZC';
      final amount = '$value EZC';
      transactions.add(TransactionsCChainItem(
          tx.hash, time, blockNumber, tx.from, tx.to, amount, fee, tx));
    }
  } catch (e) {
    logger.e(e);
  }
  return transactions;
}

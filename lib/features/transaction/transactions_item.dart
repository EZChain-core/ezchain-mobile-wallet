import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/ezc/wallet/explorer/cchain/types.dart';
import 'package:wallet/ezc/wallet/history/types.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/features/common/chain_type/ezc_type.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class TransactionsItem {
  final String id;
  final String time;
  final String type;
  final List<TransactionsItemAddressInfo> from;
  final List<TransactionsItemAddressInfo> to;
  final EZCType chain;
  final CChainExplorerTx? cChainExplorerTx;

  TransactionsItem(
      this.id, this.time, this.type, this.from, this.to, this.chain,
      [this.cChainExplorerTx]);
}

class TransactionsItemAddressInfo {
  final String address;
  final String? amount;

  TransactionsItemAddressInfo(this.address, [this.amount]);
}

class TransactionsItemWidget extends StatelessWidget {
  final TransactionsItem item;
  final VoidCallback onPressed;

  const TransactionsItemWidget(
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
              children: [
                Column(
                  children: [
                    Text(
                      item.id.useCorrectEllipsis(),
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          item.time,
                          style: EZCLabelMediumTextStyle(
                              color: provider.themeMode.text60),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: provider.themeMode.bg,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            item.type,
                            style: EZCLabelMediumTextStyle(
                                color: provider.themeMode.text60),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 50),
                Assets.icons.icSearchBlack.svg()
              ],
            ),
            if (item.from.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                '${Strings.current.sharedFrom}:',
                style:
                    EZCTitleMediumTextStyle(color: provider.themeMode.text60),
              ),
              const SizedBox(height: 8),
              Column(
                children: item.from
                    .map((e) => TransactionsItemAddressInfoWidget(info: e))
                    .toList(),
              ),
            ],
            if (item.to.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                '${Strings.current.sharedTo}:',
                style:
                    EZCTitleMediumTextStyle(color: provider.themeMode.text60),
              ),
              const SizedBox(height: 8),
              Column(
                children: item.to
                    .map((e) => TransactionsItemAddressInfoWidget(info: e))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class TransactionsItemAddressInfoWidget extends StatelessWidget {
  final TransactionsItemAddressInfo info;

  const TransactionsItemAddressInfoWidget({Key? key, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: provider.themeMode.bg,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              info.address.useCorrectEllipsis(),
              style: EZCTitleMediumTextStyle(color: provider.themeMode.text),
            ),
            if (info.amount != null)
              Text(
                info.amount!,
                style: EZCTitleMediumTextStyle(color: provider.themeMode.text),
              ),
          ],
        ),
      ),
    );
  }
}

Widget buildTransactionWidget(TransactionsItem transaction) {
  return TransactionsItemWidget(
    item: transaction,
    onPressed: () {
      switch (transaction.chain) {
        case EZCType.xChain:
          walletContext
              ?.pushRoute(TransactionDetailRoute(txId: transaction.id));
          break;
        case EZCType.pChain:
          walletContext
              ?.pushRoute(TransactionDetailRoute(txId: transaction.id));
          break;
        case EZCType.cChain:
          if (transaction.cChainExplorerTx != null) {
            walletContext?.pushRoute(TransactionCDetailRoute(
                cChainExplorerTx: transaction.cChainExplorerTx!));
          }
          break;
      }
    },
  );
}

List<TransactionsItem> mapToTransactionsItem(
  List<HistoryItem> items, {
  List<Validator>? validators,
}) {
  final List<TransactionsItem> transactions = [];

  try {
    final result = items
        .where((tx) => tx.type != HistoryItemTypeName.notSupported)
        .toList();
    for (var item in result) {
      final transId = item.id;
      final transTime = item.timestamp?.parseDateTime()?.parseTimeAgo() ?? '';
      String transType = '';

      if (item is HistoryBaseTx) {
        // final token = item.tokens.firstWhereOrNull(
        //     (token) => token.asset.assetId == getAvaxAssetId());
        //
        // if (token == null || token.amount == BigInt.zero) {
        //   continue;
        // }
        // if (token.amount < BigInt.zero) {
        //   final amount = bnToLocaleString(
        //     token.amount - item.fee,
        //     decimals: int.tryParse(token.asset.denomination) ?? 0,
        //   );
        //
        //   transType = Strings.current.sharedSent;
        //   transAmount = '$amount ${token.asset.symbol}';
        //   transIncrease = false;
        // } else {
        //   transType = Strings.current.sharedReceived;
        //   transAmount = '${token.amountDisplayValue} ${token.asset.symbol}';
        //   transIncrease = true;
        // }
        // transactions.add(TransactionsBaseImportExportItem(
        //     transId, transTime, transType, transAmount, transIncrease));
      } else if (item is HistoryImportExport) {
        if (item.amount > BigInt.zero) {
          if (item.type == HistoryItemTypeName.import) {
            transType = Strings.current.sharedImport;
          } else if (item.type == HistoryItemTypeName.export) {
            final amount =
                bnToAvaxX((item.amount + item.fee) * BigInt.from(-1));

            transType = Strings.current.sharedExport;
          }
        }
        // transactions.add(TransactionsBaseImportExportItem(
        //     transId, transTime, transType, transAmount, transIncrease));
      } else if (item is HistoryStaking && validators != null) {
        String reward = '';
        String addValidator = '';
        String addDelegator = '';
        final stakeEndTime = DateTime.fromMillisecondsSinceEpoch(item.stakeEnd)
            .format('MM/dd/yyyy, HH:mm:ss a');
        BigInt? potentialReward;
        final validator = validators.firstWhereOrNull((validator) {
          final nodeId = validator.nodeId.split("-")[1];
          return nodeId == item.nodeId;
        });
        if (validator != null) {
          if (item.type == HistoryItemTypeName.addValidator) {
            potentialReward = validator.potentialRewardBN;
            addValidator = "${item.amountDisplayValue} EZC";
            transType = Strings.current.sharedValidate;
          } else {
            final delegators = validator.delegators;
            if (delegators != null) {
              final delegator = delegators
                  .firstWhere((delegator) => delegator.txId == item.id);
              potentialReward = delegator.potentialRewardBN;
              addDelegator = "${item.amountDisplayValue} EZC";
              transType = Strings.current.sharedDelegate;
            }
          }
          if (potentialReward != null) {
            reward = '${bnToAvaxP(potentialReward)} EZC';
          }
        }
        // transactions.add(TransactionsStakingItem(transId, transTime, transType,
        //     stakeEndTime, reward, addDelegator, addValidator));
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
      final transType = '';
      // transactions.add(TransactionsCChainItem(tx.hash, time, transType,
      //     blockNumber, tx.from, tx.to, amount, fee, tx));
    }
  } catch (e) {
    logger.e(e);
  }
  return transactions;
}

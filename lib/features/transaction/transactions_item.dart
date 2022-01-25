import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/roi/wallet/history/types.dart';
import 'package:wallet/roi/wallet/network/utils.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class TransactionsItemWidget extends StatelessWidget {
  final TransactionsItemViewData item;
  final VoidCallback onPressed;

  const TransactionsItemWidget(
      {Key? key, required this.item, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => GestureDetector(
        onTap: onPressed,
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

class TransactionsItemViewData {
  final String txId;
  final String time;
  final String type;
  final String amount;
  final bool isIncrease;

  TransactionsItemViewData(
      this.txId, this.time, this.type, this.amount, this.isIncrease);
}

List<TransactionsItemViewData> mapToTransactionsItemViewData(
    List<HistoryItem> items,
    {List<Validator>? validators}) {
  final List<TransactionsItemViewData> transactions = [];

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
      final token = item.tokens
          .firstWhereOrNull((token) => token.asset.assetId == getAvaxAssetId());

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
    } else if (item is HistoryImportExport) {
      if (item.amount > BigInt.zero) {
        if (item.type == HistoryItemTypeName.import) {
          transType = Strings.current.sharedImport;
          transAmount = "${item.amountDisplayValue} EZC";
          transIncrease = true;
        } else if (item.type == HistoryItemTypeName.export) {
          final amount = bnToAvaxX((item.amount + item.fee) * BigInt.from(-1));

          transType = Strings.current.sharedExport;
          transAmount = '$amount EZC';
          transIncrease = false;
        }
      }
    } else if (item is HistoryStaking && validators != null) {
      // var message = "Date = ${item.timestamp}\n";
      //
      // final stakeEndDate = DateTime.fromMillisecondsSinceEpoch(item.stakeEnd);
      // final dateFormatter = DateFormat("MM/dd/yyyy, HH:mm:ss a");
      // message += "Stake End Date = ${dateFormatter.format(stakeEndDate)}\n";
      // String? potentialReward;
      // final validator = validators.firstWhereOrNull((validator) {
      //   final nodeId = validator.nodeId.split("-")[1];
      //   return nodeId == item.nodeId;
      // });
      // if (validator != null) {
      //   if (item.type == HistoryItemTypeName.addValidator) {
      //     potentialReward = validator.potentialReward;
      //     message += "Add Validator = ${item.amountDisplayValue}\n";
      //   } else {
      //     final delegators = validator.delegators;
      //     if (delegators != null) {
      //       final delegator =
      //           delegators.firstWhere((delegator) => delegator.txId == item.id);
      //       potentialReward = delegator.potentialReward;
      //       message += "Add Delegator = ${item.amountDisplayValue}\n";
      //     }
      //   }
      //   if (potentialReward != null) {
      //     final reward =
      //         bnToAvaxP(BigInt.tryParse(potentialReward) ?? BigInt.zero);
      //     message += "Reward Pending = $reward";
      //   } else {
      //     message += "Reward Pending = ?";
      //   }
      // }
      // logger.i(message);
    }
    transactions.add(TransactionsItemViewData(
        transId, transTime, transType, transAmount, transIncrease));
  }

  return transactions;
}

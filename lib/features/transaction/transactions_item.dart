import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/roi/wallet/history/raw_types.dart';
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
                  item.timestamp,
                  style:
                      EZCBodyLargeTextStyle(color: provider.themeMode.text),
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
                  '${item.amount} EZC',
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
  final String timestamp;
  final String type;
  final Decimal amount;
  final bool isIncrease;

  TransactionsItemViewData(
      this.timestamp, this.type, this.amount, this.isIncrease);
}

extension TransactionExtension on Transaction {
  TransactionsItemViewData mapToTransactionsItemViewData() {
    return TransactionsItemViewData(
        timestamp ?? '', type.name, Decimal.zero, true);
  }
}

extension TransactionTypeExtension on TransactionType {
  String get name {
    return [
      "Send",
      "Send",
      "Send",
      "Send",
      "Send",
      "Send",
      "Send",
      "Send",
      "Send",
      "Send",
      "Send",
      "Send",
      "Send",
      "Send",
      "Send",
      "Send",
    ][index];
  }
}

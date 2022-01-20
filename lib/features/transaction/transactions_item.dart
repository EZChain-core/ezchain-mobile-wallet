import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/roi/wallet/history/raw_types.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class TransactionsItemWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const TransactionsItemWidget({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => GestureDetector(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '21 minutes ago',
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
                    'Send',
                    style:
                        EZCBodyLargeTextStyle(color: provider.themeMode.text60),
                  ),
                  Text(
                    '-22 ROI',
                    style: EZCBodyLargeTextStyle(
                        color: provider.themeMode.stateDanger),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionsItem {
  final String timestamp;
  final TransactionType type;

  TransactionsItem(this.timestamp, this.type);

}
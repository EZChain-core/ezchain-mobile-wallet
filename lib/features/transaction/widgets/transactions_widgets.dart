import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class TransactionsButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String text;

  const TransactionsButton(
      {Key? key,
      required this.onPressed,
      required this.icon,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => GestureDetector(
        onTap: onPressed,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: provider.themeMode.primary10,
              ),
              child: icon,
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: EZCTitleSmallTextStyle(color: provider.themeMode.primary),
            )
          ],
        ),
      ),
    );
  }
}

class TransactionsNoData extends StatelessWidget {
  const TransactionsNoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Assets.images.imgNoData.svg(),
            const SizedBox(height: 18),
            Text(
              Strings.current.transactionsNoRecord,
              style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
            )
          ],
        ),
      ),
    );
  }
}

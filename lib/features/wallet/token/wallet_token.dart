import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class WalletTokenScreen extends StatelessWidget {
  const WalletTokenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                const SizedBox(width: 16),
                Text(
                  Strings.current.sharedBalance,
                  style: ROIHeadlineSmallTextStyle(
                      color: provider.themeMode.white),
                ),
                Expanded(
                  child: Text(
                    r'$ 4.000.000',
                    textAlign: TextAlign.end,
                    style: ROIHeadlineSmallTextStyle(
                        color: provider.themeMode.primary),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 65),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                Strings.current.sharedToken,
                style:
                    ROIHeadlineSmallTextStyle(color: provider.themeMode.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class WalletROIChainScreen extends StatelessWidget {
  const WalletROIChainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                const SizedBox(width: 16),
                Assets.images.imgLogoRoi.image(width: 63, height: 48),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '24.000.000.000 ROI',
                        style: ROIHeadlineSmallTextStyle(
                            color: provider.themeMode.primary),
                      ),
                      Text(
                        '\$2.000.000.000',
                        style: ROITitleLargeTextStyle(
                            color: provider.themeMode.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

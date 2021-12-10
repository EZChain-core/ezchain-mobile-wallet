import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
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
                        r'$2.000.000.000',
                        style: ROITitleLargeTextStyle(
                            color: provider.themeMode.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: provider.themeMode.bg,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Strings.current.sharedXChain,
                        style: ROIHeadlineSmallTextStyle(
                            color: provider.themeMode.text),
                      ),
                      const Spacer(),
                      _WalletButton(
                        text: Strings.current.sharedSend,
                        icon: Assets.icons.icArrowUp.svg(),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      _WalletButton(
                        text: Strings.current.sharedReceive,
                        icon: Assets.icons.icArrowDown.svg(),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Strings.current.sharedAvailable,
                        style: ROITitleMediumTextStyle(
                            color: provider.themeMode.secondary60),
                      ),
                      Text(
                        '8.000.000.000 ROI',
                        style: ROITitleMediumTextStyle(
                            color: provider.themeMode.text),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Strings.current.sharedLock,
                        style: ROITitleMediumTextStyle(
                            color: provider.themeMode.secondary60),
                      ),
                      Text(
                        '0 ROI',
                        style: ROITitleMediumTextStyle(
                            color: provider.themeMode.text),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _WalletButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onPressed;

  const _WalletButton(
      {Key? key,
      required this.text,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        height: 24,
        child: TextButton.icon(
          onPressed: onPressed,
          label: Text(
            text,
            style: ROITitleSmallTextStyle(color: provider.themeMode.text90),
            textAlign: TextAlign.center,
          ),
          icon: icon,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            backgroundColor: provider.themeMode.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ),
    );
  }
}

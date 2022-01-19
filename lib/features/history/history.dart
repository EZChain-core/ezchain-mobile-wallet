import 'package:auto_route/auto_route.dart';
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/common/chain_type/ezc_type.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class HistoryScreen extends StatelessWidget {
  final EZCType ezcType;

  const HistoryScreen({Key? key, required this.ezcType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) =>
          Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EZCAppBar(
                    title: 'EZC(${ezcType.name})',
                    onPressed: () {
                      context.router.pop();
                    },
                  ),
                  SizedBox(
                    height: 210,
                    child: Stack(
                      children: [
                        Assets.images.imgBgHistory.svg(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 64,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 16),
                                  Assets.icons.icEzc64.svg(),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Text(
                                          '10,000,000 EZC'.useCorrectEllipsis(),
                                          style: EZCHeadlineSmallTextStyle(
                                              color: provider.themeMode.text),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '\$66,887.47',
                                          style: EZCTitleSmallTextStyle(
                                              color: provider.themeMode.text40),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: EZCChainLabelText(
                                          text: ezcType.name)),
                                  const SizedBox(width: 16),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (ezcType != EZCType.pChain)
                                  _HistoryButton(
                                    text: Strings.current.sharedSend,
                                    icon: Assets.icons.icArrowUpPrimary.svg(),
                                    onPressed: () {
                                      final route = ezcType.sendRoute;
                                      if (route != null) {
                                        context.pushRoute(route);
                                      }
                                    },
                                  ),
                                const SizedBox(width: 40),
                                _HistoryButton(
                                  text: Strings.current.sharedReceive,
                                  icon: Assets.icons.icArrowDownPrimary.svg(),
                                  onPressed: () {},
                                ),
                                const SizedBox(width: 40),
                                _HistoryButton(
                                  text: Strings.current.sharedCopy,
                                  icon: Assets.icons.icCopyPrimary.svg(),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Divider(
                            color: provider.themeMode.text10,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      Strings.current.sharedTransaction,
                      style: EZCTitleLargeTextStyle(
                          color: provider.themeMode.text),
                    ),
                  )
                ],
              ),
            ),
          ),
    );
  }
}

class _HistoryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String text;

  const _HistoryButton({Key? key,
    required this.onPressed,
    required this.icon,
    required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) =>
          GestureDetector(
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
                  style: EZCTitleSmallTextStyle(
                      color: provider.themeMode.primary),
                )
              ],
            ),
          ),
    );
  }
}

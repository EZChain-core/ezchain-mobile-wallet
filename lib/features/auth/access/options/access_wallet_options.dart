import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class AccessWalletOptionsScreen extends StatefulWidget {
  const AccessWalletOptionsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccessWalletOptionsScreenState();
}

class _AccessWalletOptionsScreenState extends State<AccessWalletOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: Center(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: Text(
                    Strings.current.accessWalletOptionsTitle,
                    style: ROIHeadlineMediumTextStyle(
                      color: provider.themeMode.text,
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 64,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: provider.themeMode.bg,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        onPressed: () {
                          context.router.push(AccessPrivateKeyRoute());
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                Strings.current.sharedPrivateKey,
                                style: ROIBodyLargeTextStyle(
                                    color: provider.themeMode.text),
                              ),
                            ),
                            Assets.icons.icKeyOutlineBlack.svg(
                                width: 24,
                                height: 24,
                                color: provider.themeMode.text),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 64,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: provider.themeMode.bg,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        onPressed: () {
                          context.router.push(AccessMnemonicKeyRoute());
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                Strings.current.accessWalletOptionsMnemonic,
                                style: ROIBodyLargeTextStyle(
                                    color: provider.themeMode.text),
                              ),
                            ),
                            Assets.icons.icDocOutlineBlack.svg(
                                width: 24,
                                height: 24,
                                color: provider.themeMode.text),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 1),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ROIBodyLargeNoneButton(
                          text:
                              Strings.current.accessWalletOptionsDontHaveWallet,
                          onPressed: () {
                            context.router.push(CreateWalletRoute());
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ROIBodyLargeNoneButton(
                          text: Strings.current.sharedCancel,
                          onPressed: () {
                            context.router.pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

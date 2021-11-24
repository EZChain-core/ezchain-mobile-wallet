import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class AccessPrivateKeyScreen extends StatefulWidget {
  const AccessPrivateKeyScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccessPrivateKeyScreenState();
}

class _AccessPrivateKeyScreenState extends State<AccessPrivateKeyScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: Center(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 20),
                    child: Text(
                      Strings.current.sharedPrivateKey,
                      style: ROIHeadlineMediumTextStyle(
                        color: provider.themeMode.text,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ROITextField(
                          hint: Strings
                              .current.accessPrivateKeyYourPrivateKeyHint,
                          label: Strings.current.accessPrivateKeyYourPrivateKey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 164,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ROIMediumPrimaryButton(
                                text: Strings.current.sharedAccessWallet,
                                onPressed: () {
                                  context.router.push(const DashboardRoute());
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              child: ROISpecialNoneButton(
                                text: Strings.current.sharedCancel,
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

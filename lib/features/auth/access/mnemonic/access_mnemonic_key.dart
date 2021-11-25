import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class AccessMnemonicKeyScreen extends StatelessWidget {
  const AccessMnemonicKeyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
        builder: (context, provider, child) => Scaffold(
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 20),
                      child: Text(
                        Strings.current.accessMnemonicKeyTitle,
                        style: ROIHeadlineMediumTextStyle(
                          color: provider.themeMode.text,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 58, top: 16),
                      child: Text(
                        Strings.current.accessMnemonicKeyDes,
                        style: ROIBodyLargeTextStyle(
                          color: provider.themeMode.text70,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 164,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ROISpecialNoneButton(
                              text: Strings.current.sharedCancel,
                              onPressed: () {
                                context.router.navigateBack();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class AccessMnemonicKeyScreen extends StatelessWidget {
  const AccessMnemonicKeyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _showWarningDialog() async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Consumer<WalletThemeProvider>(
            builder: (context, provider, child) => AlertDialog(
              insetPadding: const EdgeInsets.all(16),
              title: Assets.images.imgWarning.svg(width: 130, height: 130),
              content: Text(
                Strings.current.accessMnemonicKeyWarning,
                textAlign: TextAlign.center,
                style:
                    ROIHeadlineSmallTextStyle(color: provider.themeMode.text70),
              ),
            ),
          );
        },
      );
    }

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Text(
                  Strings.current.accessMnemonicKeyTitle,
                  style: ROIHeadlineMediumTextStyle(
                    color: provider.themeMode.text,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 58, top: 16),
                child: Text(
                  Strings.current.accessMnemonicKeyDes,
                  style: ROIBodyLargeTextStyle(
                    color: provider.themeMode.text70,
                  ),
                ),
              ),
              Container(
                  width: double.infinity,
                  height: 384,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: provider.themeMode.bg),
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, top: 44, bottom: 64),
                  child: TextField()),
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
                          // context.router.push(const DashboardRoute());
                          _showWarningDialog();
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
                          context.router.pop();
                        },
                      ),
                    ),
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

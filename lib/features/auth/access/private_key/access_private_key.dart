import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/auth/access/private_key/access_private_key_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class AccessPrivateKeyScreen extends StatelessWidget {
  const AccessPrivateKeyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accessPrivateKeyStore = AccessPrivateKeyStore();

    final privateKeyInputController = TextEditingController();

    Future<void> _showWarningDialog() async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Consumer<WalletThemeProvider>(
            builder: (context, provider, child) => Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 318,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.images.imgPrivateKeyWraning
                        .image(width: 130, height: 130),
                    const SizedBox(height: 24),
                    Text(
                      Strings.current.accessPrivateKeyWarning,
                      textAlign: TextAlign.center,
                      style: ROIHeadlineSmallTextStyle(
                          color: provider.themeMode.text70),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    void _onClickAccess() {
      accessPrivateKeyStore
          .accessWithPrivateKey(privateKeyInputController.text);
      context.router.push(const DashboardRoute());
      // _showWarningDialog();
    }

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
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
                        hint:
                            Strings.current.accessPrivateKeyYourPrivateKeyHint,
                        label: Strings.current.accessPrivateKeyYourPrivateKey,
                        controller: privateKeyInputController,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                                _onClickAccess();
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
            ],
          ),
        ),
      ),
    );
  }
}

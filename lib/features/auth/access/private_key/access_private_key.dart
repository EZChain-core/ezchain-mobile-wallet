import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/dialog_extensions.dart';
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

    final privateKeyInputController = TextEditingController(
        text: 'PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M');

    void _showWarningDialog() {
      context.showWarningDialog(
        Assets.images.imgPrivateKeyWraning.image(width: 130, height: 130),
        Strings.current.accessPrivateKeyWarning,
      );
    }

    void _onClickAccess() {
      bool isSuccess = accessPrivateKeyStore
          .accessWithPrivateKey(privateKeyInputController.text);
      if (isSuccess) {
        context.router.replaceAll([const DashboardRoute()]);
      } else {
        _showWarningDialog();
      }
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

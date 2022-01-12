import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/dialog_extensions.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/auth/access/mnemonic/widgets/access_mnemonic_input.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/sdk/utils/mnemonic.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

import 'access_mnemonic_key_store.dart';

class AccessMnemonicKeyScreen extends StatelessWidget {
  final _accessMnemonicKeyStore = AccessMnemonicKeyStore();

  AccessMnemonicKeyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 44),
                  child: AccessMnemonicInput(
                    onPhrasesChanged: (List<String> phrases) {
                      _accessMnemonicKeyStore.mnemonicPhrase = phrases;
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Stack(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onClickAccess() {
    final mnemonicPhrase = _accessMnemonicKeyStore.mnemonicPhrase;
    if (mnemonicPhrase.length != Mnemonic.mnemonicLength) {
      _showWarningDialog();
    } else {
      String mnemonic = mnemonicPhrase.join(' ');
      final isSuccess = _accessMnemonicKeyStore.accessWithMnemonicKey(mnemonic);
      if (isSuccess) {
        walletContext?.router.replaceAll([const DashboardRoute()]);
      } else {
        _showWarningDialog();
      }
    }
  }

  void _showWarningDialog() {
    walletContext?.showWarningDialog(
      Assets.images.imgWarning.svg(width: 130, height: 130),
      Strings.current.accessMnemonicKeyWarning,
    );
  }
}

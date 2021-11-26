import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/utils/mnemonic.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class CreateWalletConfirmScreen extends StatelessWidget {
  const CreateWalletConfirmScreen({Key? key}) : super(key: key);

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
                  Strings.current.sharedConfirm,
                  style: ROIHeadlineMediumTextStyle(
                    color: provider.themeMode.text,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  Strings.current.createWalletConfirmDes,
                  style: ROIBodyLargeTextStyle(
                    color: provider.themeMode.text70,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: provider.themeMode.bg,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(
                    left: 16, right: 16, top: 72, bottom: 64),
                child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _buildRandomMnemonicList()),
              ),
              Center(
                child: SizedBox(
                  width: 169,
                  child: ROIMediumPrimaryButton(
                    text: Strings.current.sharedConfirm,
                    onPressed: () {
                      context.router.push(const DashboardRoute());
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<ROIMnemonicText> _buildRandomMnemonicList() => Mnemonic.instance
      .generateMnemonic()
      .split(" ")
      .mapIndexed((index, text) => ROIMnemonicText(text: '$index. $text'))
      .toList();
}

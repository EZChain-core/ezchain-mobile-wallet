import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/auth/create/create_wallet_store.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class CreateWalletScreen extends StatelessWidget {
  CreateWalletScreen({Key? key}) : super(key: key);

  final _createWalletStore = CreateWalletStore();
  final sizeOfMnemonic = 24;
  final sizeOfRandomInputMnemonic = 4;

  List<ROIMnemonicText> _buildRandomMnemonicList() => _createWalletStore
      .mnemonicPhrase
      .split(' ')
      .mapIndexed((index, text) => ROIMnemonicText(text: '${index + 1}. $text'))
      .toList();

  @override
  Widget build(BuildContext context) {
    _createWalletStore.generateMnemonicPhrase();
    List<int> randomIndex = List.generate(
        sizeOfRandomInputMnemonic, (_) => Random().nextInt(sizeOfMnemonic) + 1);

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Text(
                  Strings.current.createWalletPassphraseToRestore,
                  style: ROIHeadlineMediumTextStyle(
                    color: provider.themeMode.text,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  Strings.current.createWalletDes,
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
                    left: 16, right: 16, top: 32, bottom: 64),
                child: Observer(
                  builder: (_) => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _buildRandomMnemonicList()),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 211,
                  child: ROIMediumPrimaryButton(
                    text: Strings.current.createWalletKeptKey,
                    onPressed: () {
                      context.router.push(
                        CreateWalletConfirmRoute(
                            mnemonic: _createWalletStore.mnemonicPhrase,
                            randomIndex: randomIndex),
                      );
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
}

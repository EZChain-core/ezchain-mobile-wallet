import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/roi/sdk/utils/mnemonic.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class CreateWalletConfirmScreen extends StatelessWidget {
  const CreateWalletConfirmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const sizeOfMnemonic = 24;
    const sizeOfRandomInputMnemonic = 4;
    List<String> phrase = Mnemonic.instance.generateMnemonic().split(' ');

    List<String> resultPhrase = List.from(phrase);

    List<Widget> _buildRandomMnemonicList() {
      List<int> randomIndex = List.generate(sizeOfRandomInputMnemonic,
          (_) => Random().nextInt(sizeOfMnemonic) + 1);
      return phrase
          .mapIndexed((index, text) => randomIndex.contains(index)
              ? _MnemonicConfirmTextField(
                  index: index,
                  onChanged: (String word) {
                    resultPhrase.removeAt(index);
                    resultPhrase.insert(index, word);
                  },
                )
              : ROIMnemonicText(text: '${index + 1}. $text'))
          .toList();
    }

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

    void _onClickConfirm() {
      if (phrase.equals(resultPhrase)) {
        context.router.push(const PinCodeSetupRoute());
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
                      _onClickConfirm();
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

class _MnemonicConfirmTextField extends StatelessWidget {
  final int index;

  final Function(String word) onChanged;

  const _MnemonicConfirmTextField(
      {Key? key, required this.index, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    onChanged('');
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        width: 90,
        height: 32,
        decoration: BoxDecoration(
          color: provider.themeMode.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Text(
              '${index + 1}. ',
              style: ROISemiBoldSmallTextStyle(color: provider.themeMode.white),
            ),
            Expanded(
              child: TextField(
                onChanged: (text) {
                  onChanged(text);
                },
                textAlignVertical: TextAlignVertical.center,
                style: ROIBodySmallTextStyle(color: provider.themeMode.white),
                cursorColor: provider.themeMode.white,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

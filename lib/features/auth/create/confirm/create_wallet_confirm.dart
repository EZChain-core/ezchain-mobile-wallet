import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/auth/create/confirm/create_wallet_confirm_store.dart';
import 'package:wallet/features/common/dialog/dialog_extensions.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class CreateWalletConfirmScreen extends StatelessWidget {
  final _createWalletConfirmStore = CreateWalletConfirmStore();

  final List<int> randomIndex;
  final List<String> phrase = [];
  final List<String> resultPhrase = [];

  CreateWalletConfirmScreen(
      {Key? key, required String mnemonic, required this.randomIndex})
      : super(key: key) {
    final temp = mnemonic.split(' ');
    phrase.addAll(temp);
    resultPhrase.addAll(temp);
  }

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
                  style: EZCHeadlineMediumTextStyle(
                    color: provider.themeMode.text,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  Strings.current.createWalletConfirmDes,
                  style: EZCBodyLargeTextStyle(
                    color: provider.themeMode.text70,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: provider.themeMode.bg,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 72),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _buildRandomMnemonicList()),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: SizedBox(
                    width: 169,
                    child: Observer(
                      builder: (_) => EZCMediumPrimaryButton(
                        text: Strings.current.sharedConfirm,
                        onPressed: () {
                          _onClickConfirm();
                        },
                        isLoading: _createWalletConfirmStore.isLoading,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRandomMnemonicList() {
    return phrase
        .mapIndexed((index, text) => randomIndex.contains(index)
            ? _MnemonicConfirmTextField(
                index: index,
                onChanged: (String word) {
                  resultPhrase.removeAt(index);
                  resultPhrase.insert(index, word);
                },
              )
            : EZCMnemonicText(text: '${index + 1}. $text'))
        .toList();
  }

  void _showWarningDialog() {
    walletContext?.showWarningDialog(
      Assets.images.imgWarning.svg(width: 130, height: 130),
      Strings.current.accessMnemonicKeyWarning,
    );
  }

  void _onClickConfirm() async {
    if (phrase.equals(resultPhrase) &&
        await _createWalletConfirmStore
            .accessWithMnemonicKey(resultPhrase.join(' '))) {
      walletContext?.router.push(const PinCodeSetupRoute());
    } else {
      _showWarningDialog();
    }
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
              style: EZCSemiBoldSmallTextStyle(color: provider.themeMode.white),
            ),
            Expanded(
              child: TextField(
                onChanged: (text) {
                  onChanged(text);
                },
                textAlignVertical: TextAlignVertical.center,
                style: EZCBodySmallTextStyle(color: provider.themeMode.white),
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

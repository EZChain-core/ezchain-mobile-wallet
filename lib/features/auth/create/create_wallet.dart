import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/auth/create/create_wallet_store.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class CreateWalletScreen extends StatelessWidget {
  CreateWalletScreen({Key? key}) : super(key: key);

  final _createWalletStore = CreateWalletStore();

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
                  Strings.current.createWalletPassphraseToRestore,
                  style: EZCHeadlineMediumTextStyle(
                    color: provider.themeMode.text,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  Strings.current.createWalletDes,
                  style: EZCBodyLargeTextStyle(
                    color: provider.themeMode.text70,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: provider.themeMode.bg,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 32,
                    bottom: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FutureBuilder<String>(
                          future: _createWalletStore.generateMnemonicPhrase(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final mnemonic = snapshot.data!;
                              return SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: mnemonic
                                      .split(' ')
                                      .mapIndexed((index, text) =>
                                          EZCMnemonicText(
                                              text: '${index + 1}. $text'))
                                      .toList(),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: EZCBodyLargeNoneButton(
                          text: Strings.current.createWalletCopyPassphrase,
                          onPressed: () {
                            _onClickCopy(_createWalletStore.mnemonicPhrase);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: SizedBox(
                    width: 211,
                    child: EZCMediumPrimaryButton(
                      text: Strings.current.createWalletKeptKey,
                      onPressed: () {
                        context.router.push(
                          CreateWalletConfirmRoute(
                            mnemonic: _createWalletStore.mnemonicPhrase,
                            randomIndex: _createWalletStore.randomIndex,
                          ),
                        );
                      },
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

  _onClickCopy(String mnemonic) {
    Clipboard.setData(ClipboardData(text: mnemonic));
    showSnackBar(Strings.current.sharedCopied);
  }
}

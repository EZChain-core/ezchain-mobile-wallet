import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/wallet/token/add/wallet_token_add_store.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletTokenAddScreen extends StatelessWidget {
  WalletTokenAddScreen({Key? key}) : super(key: key);

  final _walletTokenAddStore = WalletTokenAddStore();
  final _addressController = TextEditingController(text: erc20AddressTest);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => ReactionBuilder(
        builder: (context) {
          return autorun((_) {
            final error = _walletTokenAddStore.error;
            if (error.isNotEmpty) {
              showSnackBar(error);
            }
          });
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                EZCAppBar(
                  title: Strings.current.walletAddToken,
                  onPressed: context.popRoute,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'C-Chain(ERC-20)',
                          style: EZCHeadlineSmallTextStyle(
                              color: provider.themeMode.text),
                        ),
                        const SizedBox(height: 24),
                        EZCTextField(
                          label: Strings.current.walletTokenContractAddress,
                          controller: _addressController,
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.center,
                          child: EZCMediumPrimaryButton(
                            text: Strings.current.sharedNext,
                            width: 161,
                            onPressed: _onClickNext,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onClickNext() async {
    final address = _addressController.text.trim();
    _walletTokenAddStore.validate(address);
  }
}

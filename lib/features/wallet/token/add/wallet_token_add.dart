import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/wallet/token/add/wallet_token_add_store.dart';
import 'package:wallet/features/wallet/token/add_confirm/wallet_token_add_confirm.dart';
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
  final _addressController = TextEditingController(text: receiverAddressCTest);
  final _nameController = TextEditingController();
  final _symbolController = TextEditingController();
  final _decimalController = TextEditingController();

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
                  child: SingleChildScrollView(
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
                        const SizedBox(height: 16),
                        EZCTextField(
                          label: Strings.current.walletTokenName,
                          controller: _nameController,
                        ),
                        const SizedBox(height: 16),
                        EZCTextField(
                          label: Strings.current.walletTokenSymbol,
                          controller: _symbolController,
                          textCapitalization: TextCapitalization.characters,
                        ),
                        const SizedBox(height: 16),
                        EZCTextField(
                          label: Strings.current.walletTokenDecimal,
                          controller: _decimalController,
                          hint: '0',
                          inputType: TextInputType.number,
                        ),
                        const SizedBox(height: 115),
                        Align(
                          alignment: Alignment.center,
                          child: EZCMediumPrimaryButton(
                            text: Strings.current.sharedNext,
                            width: 161,
                            onPressed: _onClickNext,
                          ),
                        ),
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
    final name = _nameController.text.trim();
    final symbol = _symbolController.text.trim();
    final decimal = int.tryParse(_decimalController.text) ?? 0;
    _walletTokenAddStore.validate(address, name, symbol, decimal);
    // walletContext?.pushRoute(WalletTokenAddConfirmRoute(
    //     args: WalletTokenAddConfirmArgs(address, name, symbol, decimal)));
  }
}

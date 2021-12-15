import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/wallet/send/widgets/wallet_send_widgets.dart';
import 'package:wallet/features/wallet/send/x_chain/wallet_send_x_chain_confirm.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletSendXChainScreen extends StatelessWidget {
  const WalletSendXChainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController addressController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController momoController = TextEditingController();

    void _onClickConfirm() {
      context.router.push(
        WalletSendXChainConfirmRoute(
          walletViewData:
          WalletSendXChainTransactionViewData(
            addressController.text,
            momoController.text,
            double.tryParse(amountController.text) ?? 0,
            0.01,
            2.01,
          ),
        ),
      );
    }

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) =>
          Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  ROIAppBar(
                    title: Strings.current.sharedSend,
                    onPressed: () {
                      context.router.pop();
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Assets.icons.icRoi.svg(),
                                const SizedBox(width: 8),
                                Text(
                                  'ROI',
                                  style: ROIBodyLargeTextStyle(
                                      color: provider.themeMode.text),
                                ),
                                const SizedBox(width: 16),
                                const ROIChainLabelText(text: 'X-Chain'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ROIAddressTextField(
                              label: Strings.current.sharedSendTo,
                              hint: Strings.current.sharedPasteAddress,
                              controller: addressController,
                            ),
                            const SizedBox(height: 16),
                            ROIAmountTextField(
                              label: Strings.current.sharedSetAmount,
                              hint: '0.0',
                              suffixText: 'Ballance: 1000',
                              prefixText: r'$ 8.778',
                              controller: amountController,
                            ),
                            const SizedBox(height: 16),
                            ROITextField(
                              label: Strings.current.walletSendMemo,
                              hint: Strings.current.sharedMemo,
                              maxLines: 3,
                              controller: momoController,
                            ),
                            const SizedBox(height: 16),
                            WalletSendHorizontalText(
                              title: Strings.current.sharedTransactionFee,
                              content: '0.02 ROI',
                              rightColor: provider.themeMode.text60,
                            ),
                            const SizedBox(height: 4),
                            WalletSendHorizontalText(
                              title: Strings.current.sharedTotal,
                              content: '--',
                              rightColor: provider.themeMode.text60,
                            ),
                            const SizedBox(height: 157),
                            ROIMediumPrimaryButton(
                              text: Strings.current.sharedConfirm,
                              width: 185,
                              padding: const EdgeInsets.symmetric(),
                              onPressed: _onClickConfirm,
                            )
                          ],
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
}

import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/wallet/send/evm/wallet_send_evm_confirm.dart';
import 'package:wallet/features/wallet/send/widgets/wallet_send_widgets.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletSendEvmScreen extends StatelessWidget {
  const WalletSendEvmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController addressController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController gasPriceController = TextEditingController();

    void _onClickConfirm() {

    }

    void _onClickSendTransaction() {
      context.router.push(WalletSendEvmConfirmRoute(
          transactionInfo: WalletSendEvmTransactionViewData(
              addressController.text, 0, 0, 0, 0, 0)));
    }

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
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
                            const ROIChainLabelText(text: 'C-Chain'),
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
                          label: Strings.current.walletSendGasPriceGWEI,
                          hint: '0',
                          controller: gasPriceController,
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            Strings.current.walletSendGasPriceNote,
                            style: ROILabelMediumTextStyle(
                                color: provider.themeMode.text40),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.current.walletSendGasLimit,
                              style: ROITitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Strings.current.walletSendGasLimitNote,
                              style: ROILabelMediumTextStyle(
                                  color: provider.themeMode.text40),
                            ),
                          ],
                        ),
                        ROITextField(
                          label: Strings.current.walletSendGasLimit,
                          hint: '0',
                          controller: gasPriceController,
                          inputType: TextInputType.number,
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
                        const SizedBox(height: 100),
                        ROIMediumPrimaryButton(
                          text: Strings.current.sharedConfirm,
                          width: 185,
                          padding: const EdgeInsets.symmetric(),
                          onPressed: _onClickConfirm,
                        ),
                        ROIMediumSuccessButton(
                          text: Strings.current.sharedSendTransaction,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 64,
                            vertical: 8,
                          ),
                          onPressed: _onClickSendTransaction,
                        ),
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

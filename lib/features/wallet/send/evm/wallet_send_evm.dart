import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/dialog_extensions.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/wallet/send/evm/confirm/wallet_send_evm_confirm.dart';
import 'package:wallet/features/wallet/send/evm/wallet_send_evm_store.dart';
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
    final walletSendEvmStore = WalletSendEvmStore();
    walletSendEvmStore.getBalanceC();
    final addressController = TextEditingController(
        text: '0xd30a9f6645a73f67b7850b9304b6a3172dda75bf');
    final amountController = TextEditingController();

    double getAmount() {
      return double.tryParse(amountController.text) ?? 0;
    }

    void _onClickConfirm() {
      final address = addressController.text;
      walletSendEvmStore.confirm(address, getAmount());
    }

    void _showWarningDialog() {
      context.showWarningDialog(
        Assets.images.imgSendChainError.svg(width: 130, height: 130),
        Strings.current.walletSendCChainErrorAddress,
      );
    }

    Future<void> _onClickSendTransaction() async {
      final address = addressController.text;
      final sendSuccess = await walletSendEvmStore.sendEvm(
          address, getAmount());
      if (sendSuccess) {
        context.router.push(WalletSendEvmConfirmRoute(
            transactionInfo: WalletSendEvmTransactionViewData(
                addressController.text, 0, 0, 0, 0, 0)));
      }
    }

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) =>
          Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            Observer(
                              builder: (_) =>
                                  ROIAddressTextField(
                                    label: Strings.current.sharedSendTo,
                                    hint: Strings.current.sharedPasteAddress,
                                    controller: addressController,
                                    error: walletSendEvmStore.addressError,
                                    onChanged: (_) =>
                                        walletSendEvmStore.removeAddressError(),
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Observer(
                              builder: (_) =>
                                  ROIAmountTextField(
                                    label: Strings.current.sharedSetAmount,
                                    hint: '0.0',
                                    suffixText: Strings.current
                                        .walletSendBalance(
                                        walletSendEvmStore.balanceC),
                                    rateUsd: walletSendEvmStore.rateAvax,
                                    error: walletSendEvmStore.amountError,
                                    onChanged: (_) =>
                                        walletSendEvmStore.removeAmountError(),
                                    controller: amountController,
                                    onSuffixPressed: () {
                                      amountController.text = walletSendEvmStore
                                          .balanceC
                                          .replaceAll(',', '');
                                    },
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Observer(
                              builder: (_) =>
                                  ROITextField(
                                    label: Strings.current
                                        .walletSendGasPriceGWEI,
                                    hint: '0',
                                    enabled: false,
                                    controller: TextEditingController(
                                        text: walletSendEvmStore.gasPrice
                                            .toString()),
                                  ),
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
                            Observer(
                              builder: (_) =>
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      if (!walletSendEvmStore
                                          .confirmSuccess) ...[
                                        Text(
                                          Strings.current.walletSendGasLimit,
                                          style: ROITitleLargeTextStyle(
                                              color: provider.themeMode.text60),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          Strings.current
                                              .walletSendGasLimitNote,
                                          style: ROILabelMediumTextStyle(
                                              color: provider.themeMode.text40),
                                        ),
                                      ],
                                      if (walletSendEvmStore.confirmSuccess)
                                        ROITextField(
                                          label: Strings.current
                                              .walletSendGasLimit,
                                          hint: '0',
                                          enabled: false,
                                          controller: TextEditingController(
                                              text: walletSendEvmStore.gasLimit
                                                  .toString()),
                                        ),
                                    ],
                                  ),
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
                            Observer(
                              builder: (_) =>
                              walletSendEvmStore.confirmSuccess
                                  ? ROIMediumSuccessButton(
                                text: Strings.current.sharedSendTransaction,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 64,
                                  vertical: 8,
                                ),
                                onPressed: _onClickSendTransaction,
                              )
                                  : ROIMediumPrimaryButton(
                                text: Strings.current.sharedConfirm,
                                width: 185,
                                padding: const EdgeInsets.symmetric(),
                                onPressed: _onClickConfirm,
                              ),
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

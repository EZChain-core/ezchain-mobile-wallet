import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/wallet/send/avm/confirm/wallet_send_avm_confirm.dart';
import 'package:wallet/features/wallet/send/avm/wallet_send_avm_store.dart';
import 'package:wallet/features/wallet/send/widgets/wallet_send_widgets.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/inputs.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletSendAvmScreen extends StatelessWidget {
  const WalletSendAvmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walletSendAvmStore = WalletSendAvmStore();
    walletSendAvmStore.getBalanceX();
    final addressController = TextEditingController(
        text: 'X-fuji129sdwasyyvdlqqsg8d9pguvzlqvup6cmtd8jad');
    final amountController = TextEditingController();
    final memoController = TextEditingController();

    void _onClickConfirm() {
      final address = addressController.text;
      final amount = double.tryParse(amountController.text) ?? 0;
      if (walletSendAvmStore.validate(address, amount)) {
        context.router.push(
          WalletSendAvmConfirmRoute(
            transactionInfo: WalletSendAvmTransactionViewData(
              address,
              memoController.text,
              amount,
              0.01,
              2.01,
            ),
          ),
        );
      }
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
                            const ROIChainLabelText(text: 'X-Chain'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => ROIAddressTextField(
                            label: Strings.current.sharedSendTo,
                            hint: Strings.current.sharedPasteAddress,
                            controller: addressController,
                            error: walletSendAvmStore.addressError,
                            onChanged: (_) =>
                                walletSendAvmStore.removeAddressError(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => ROIAmountTextField(
                            label: Strings.current.sharedSetAmount,
                            hint: '0.0',
                            suffixText: Strings.current
                                .walletSendBalance(walletSendAvmStore.balanceX),
                            rateUsd: walletSendAvmStore.rateAvax,
                            error: walletSendAvmStore.amountError,
                            onChanged: (_) =>
                                walletSendAvmStore.removeAmountError(),
                            controller: amountController,
                            onSuffixPressed: () {
                              amountController.text = walletSendAvmStore
                                  .balanceX
                                  .replaceAll(',', '');
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        ROITextField(
                          label: Strings.current.walletSendMemo,
                          hint: Strings.current.sharedMemo,
                          maxLines: 3,
                          controller: memoController,
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

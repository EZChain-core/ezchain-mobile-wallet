import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/balance_store.dart';
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

  BalanceStore get balanceStore => getIt<BalanceStore>();

  @override
  Widget build(BuildContext context) {
    final walletSendAvmStore = WalletSendAvmStore();
    walletSendAvmStore.getBalanceX();
    balanceStore.updateBalanceX();
    final addressController = TextEditingController(
        text: 'X-fuji129sdwasyyvdlqqsg8d9pguvzlqvup6cmtd8jad');
    final amountController = TextEditingController();
    final memoController = TextEditingController();

    void _onClickConfirm() {
      final address = addressController.text;
      final amount = double.tryParse(amountController.text) ?? 0;
      if (walletSendAvmStore.validate(
          address, amount, balanceStore.balanceXDouble)) {
        context.router.push(
          WalletSendAvmConfirmRoute(
            transactionInfo: WalletSendAvmTransactionViewData(
              address,
              memoController.text,
              amount,
              walletSendAvmStore.fee,
              walletSendAvmStore.total,
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
              EZCAppBar(
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
                              'EZC',
                              style: EZCBodyLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                            const SizedBox(width: 16),
                            const EZCChainLabelText(text: 'X-Chain'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => EZCAddressTextField(
                            label: Strings.current.sharedSendTo,
                            hint: Strings.current.sharedPasteAddress,
                            controller: addressController,
                            error: walletSendAvmStore.addressError,
                            onChanged: (_) =>
                                walletSendAvmStore.removeAddressError(),
                            onSuffixPressed: () {
                              context.pushRoute(const QrCodeRoute());
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => EZCAmountTextField(
                            label: Strings.current.sharedSetAmount,
                            hint: '0.0',
                            suffixText: Strings.current
                                .walletSendBalance(balanceStore.balanceX),
                            rateUsd: walletSendAvmStore.avaxPrice,
                            error: walletSendAvmStore.amountError,
                            onChanged: (amount) {
                              walletSendAvmStore.removeAmountError();
                              walletSendAvmStore
                                  .updateTotal(double.tryParse(amount) ?? 0);
                            },
                            controller: amountController,
                            onSuffixPressed: () {
                              amountController.text =
                                  balanceStore.balanceX.replaceAll(',', '');
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        EZCTextField(
                          label: Strings.current.walletSendMemo,
                          hint: Strings.current.sharedMemo,
                          maxLines: 3,
                          controller: memoController,
                        ),
                        const SizedBox(height: 16),
                        Observer(
                          builder: (_) => WalletSendHorizontalText(
                            title: Strings.current.sharedTransactionFee,
                            content: '${walletSendAvmStore.fee} EZC',
                            rightColor: provider.themeMode.text60,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Observer(
                          builder: (_) => WalletSendHorizontalText(
                            title: Strings.current.sharedTotal,
                            content: '${walletSendAvmStore.total} USD',
                            rightColor: provider.themeMode.text60,
                          ),
                        ),
                        const SizedBox(height: 157),
                        EZCMediumPrimaryButton(
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

// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/features/auth/pin/verify/pin_code_verify.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/wallet/send/avm/confirm/wallet_send_avm_confirm_store.dart';
import 'package:wallet/features/wallet/send/widgets/wallet_send_widgets.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletSendAvmConfirmScreen extends StatelessWidget {
  final WalletSendAvmTransactionViewData transactionInfo;

  final _walletSendAvmStore = WalletSendAvmConfirmStore();

  WalletSendAvmConfirmScreen({Key? key, required this.transactionInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EZCAppBar(
                title: Strings.current.sharedSend,
                onPressed: () async {
                  await context.router.pop();
                  context.router.pop();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Assets.icons.icEzc64.svg(width: 32, height: 32),
                          const SizedBox(width: 8),
                          Text(
                            ezcSymbol,
                            style: EZCBodyLargeTextStyle(
                                color: provider.themeMode.text),
                          ),
                          const SizedBox(width: 16),
                          const EZCChainLabelText(text: 'X-Chain'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(
                        height: 1,
                        color: provider.themeMode.text10,
                      ),
                      const SizedBox(height: 8),
                      WalletSendVerticalText(
                        title: Strings.current.sharedSendTo,
                        content: transactionInfo.address,
                        hasDivider: true,
                      ),
                      const SizedBox(height: 8),
                      WalletSendVerticalText(
                        title: Strings.current.sharedMemo,
                        content: transactionInfo.memo,
                        hasDivider: true,
                      ),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.sharedAmount,
                        content: '${transactionInfo.amount} $ezcSymbol',
                      ),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.sharedTransactionFee,
                        content: '${transactionInfo.fee} $ezcSymbol',
                      ),
                      const SizedBox(height: 8),
                      EZCDashedLine(color: provider.themeMode.text10),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.sharedTotal,
                        content: '${transactionInfo.total} USD',
                        leftColor: provider.themeMode.text,
                        rightColor: provider.themeMode.stateSuccess,
                      ),
                      const Spacer(),
                      Observer(
                        builder: (_) => Column(
                          children: [
                            if (_walletSendAvmStore.sendSuccess)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  Strings.current.sharedTransactionSent,
                                  style: EZCBodyMediumTextStyle(
                                      color: provider.themeMode.stateSuccess),
                                ),
                              ),
                            _walletSendAvmStore.sendSuccess
                                ? EZCMediumSuccessButton(
                                    text: Strings.current.sharedStartAgain,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 64,
                                      vertical: 8,
                                    ),
                                    onPressed: () {
                                      context.router.popUntilRoot();
                                      context.pushRoute(WalletSendAvmRoute());
                                    },
                                  )
                                : EZCMediumSuccessButton(
                                    text: Strings.current.sharedSendTransaction,
                                    width: 251,
                                    onPressed: _onClickSendTransaction,
                                    isLoading: _walletSendAvmStore.isLoading,
                                  ),
                            const SizedBox(height: 4),
                            if (!_walletSendAvmStore.sendSuccess)
                              EZCMediumNoneButton(
                                width: 82,
                                text: Strings.current.sharedCancel,
                                textColor: provider.themeMode.text90,
                                onPressed: context.router.pop,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 45),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onClickSendTransaction() async {
    final verified = await verifyPinCode();
    if (verified) {
      _walletSendAvmStore.sendAvm(
        transactionInfo.address,
        transactionInfo.amount,
        memo: transactionInfo.memo,
      );
    }
  }
}

class WalletSendAvmTransactionViewData {
  final String address;
  final String memo;
  final Decimal amount;
  final Decimal fee;
  final Decimal total;

  WalletSendAvmTransactionViewData(
      this.address, this.memo, this.amount, this.fee, this.total);
}

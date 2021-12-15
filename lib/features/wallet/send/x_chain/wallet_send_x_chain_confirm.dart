import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/wallet/send/widgets/wallet_send_widgets.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletSendXChainConfirmScreen extends StatelessWidget {
  final WalletSendXChainViewData walletViewData;

  const WalletSendXChainConfirmScreen({Key? key, required this.walletViewData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSuccess = false;
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
                      Divider(
                        height: 1,
                        color: provider.themeMode.text10,
                      ),
                      const SizedBox(height: 8),
                      WalletSendVerticalText(
                        title: Strings.current.sharedSendTo,
                        content: walletViewData.address,
                        hasDivider: true,
                      ),
                      const SizedBox(height: 8),
                      WalletSendVerticalText(
                        title: Strings.current.sharedMemo,
                        content: walletViewData.memo,
                        hasDivider: true,
                      ),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.sharedAmount,
                        content: walletViewData.amount,
                      ),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.sharedTransactionFee,
                        content: walletViewData.fee,
                      ),
                      const SizedBox(height: 8),
                      ROIDashedLine(color: provider.themeMode.text10),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.sharedTotal,
                        content: walletViewData.total,
                        leftColor: provider.themeMode.text,
                        rightColor: provider.themeMode.stateSuccess,
                      ),
                      const Spacer(),
                      if (isSuccess)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            Strings.current.sharedTransactionSent,
                            style: ROIBodyMediumTextStyle(
                                color: provider.themeMode.stateSuccess),
                          ),
                        ),
                      isSuccess
                          ? ROIMediumSuccessButton(
                              text: Strings.current.sharedStartAgain,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 64,
                                vertical: 8,
                              ),
                              onPressed: () {},
                            )
                          : ROIMediumSuccessButton(
                              text: Strings.current.sharedSendTransaction,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 64,
                                vertical: 8,
                              ),
                              onPressed: () {},
                            ),
                      const SizedBox(height: 4),
                      if (!isSuccess)
                        ROIMediumNoneButton(
                          width: 82,
                          text: Strings.current.sharedCancel,
                          textColor: provider.themeMode.text90,
                          onPressed: () {},
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
}

class WalletSendXChainViewData {
  final String address;
  final String memo;
  final String amount;
  final String fee;
  final String total;

  WalletSendXChainViewData(
      this.address, this.memo, this.amount, this.fee, this.total);
}

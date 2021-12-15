import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
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
                        ROIAddressTextField(
                            label: Strings.current.sharedSendTo,
                            hint: Strings.current.sharedPasteAddress),
                        const SizedBox(height: 16),
                        ROIAmountTextField(
                          label: Strings.current.sharedSetAmount,
                          hint: '0.0',
                          suffixText: 'Ballance: 1000',
                          prefixText: r'$ 8.778',
                        ),
                        const SizedBox(height: 16),
                        ROITextField(
                          label: Strings.current.walletSendMemo,
                          hint: Strings.current.sharedMemo,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              Strings.current.sharedTransactionFee,
                              style: ROITitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            const Spacer(),
                            Text(
                              '0.02 ROI',
                              style: ROITitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              Strings.current.sharedTotal,
                              style: ROITitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            ),
                            const Spacer(),
                            Text(
                              '--',
                              style: ROITitleLargeTextStyle(
                                  color: provider.themeMode.text60),
                            )
                          ],
                        ),
                        const SizedBox(height: 157),
                        ROIMediumPrimaryButton(
                          text: Strings.current.sharedConfirm,
                          width: 185,
                          padding: const EdgeInsets.symmetric(),
                          onPressed: () => {
                            context.router.push(
                              WalletSendXChainConfirmRoute(
                                walletViewData: WalletSendXChainViewData(
                                  "2Z5ozYCLDqxZqDAJggm9eSH8dNVfVdfhp4bJ4Y3DvZXzqobzm1",
                                  'Send to ABC wallet',
                                  '1000 ROI',
                                  '0.02 ROI',
                                  '1000.02 ROI',
                                ),
                              ),
                            ),
                          },
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

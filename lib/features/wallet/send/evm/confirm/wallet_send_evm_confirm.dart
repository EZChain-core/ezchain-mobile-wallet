// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/wallet/send/widgets/wallet_send_widgets.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletSendEvmConfirmScreen extends StatelessWidget {
  final WalletSendEvmTransactionViewData transactionInfo;

  const WalletSendEvmConfirmScreen({Key? key, required this.transactionInfo})
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
                            transactionInfo.symbol,
                            style: EZCBodyLargeTextStyle(
                                color: provider.themeMode.text),
                          ),
                          const SizedBox(width: 16),
                          const EZCChainLabelText(text: 'C-Chain'),
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
                      WalletSendHorizontalText(
                        title: Strings.current.sharedAmount,
                        content:
                            '${transactionInfo.amount} ${transactionInfo.symbol}',
                      ),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.walletSendGasGWEI,
                        content: '${transactionInfo.gwei}',
                      ),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.walletSendGasPrice,
                        content: '${transactionInfo.gasPrice}',
                      ),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.sharedTransactionFee,
                        content: '${transactionInfo.fee} $ezcSymbol',
                      ),
                      const SizedBox(height: 8),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          Strings.current.sharedTransactionSent,
                          style: EZCBodyMediumTextStyle(
                            color: provider.themeMode.stateSuccess,
                          ),
                        ),
                      ),
                      EZCMediumSuccessButton(
                        text: Strings.current.sharedStartAgain,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 64,
                          vertical: 8,
                        ),
                        onPressed: () {
                          context.router.popUntilRoot();
                          context.pushRoute(WalletSendEvmRoute());
                        },
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

class WalletSendEvmTransactionViewData {
  final String address;
  final int gwei;
  final BigInt gasPrice;
  final Decimal amount;
  final Decimal fee;
  final String symbol;

  WalletSendEvmTransactionViewData(
    this.address,
    this.gwei,
    this.gasPrice,
    this.amount,
    this.fee,
    this.symbol,
  );
}

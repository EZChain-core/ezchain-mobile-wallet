// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/features/wallet/send/erc721/wallet_send_erc721.dart';
import 'package:wallet/features/wallet/send/widgets/wallet_send_widgets.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletSendEvmConfirmScreen extends StatelessWidget {
  final WalletSendEvmConfirmArgs args;

  const WalletSendEvmConfirmScreen({Key? key, required this.args})
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
                            args.symbol,
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
                        content: args.address,
                        hasDivider: true,
                      ),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.sharedAmount,
                        content: '${args.amount} ${args.symbol}',
                      ),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.walletSendGasGWEI,
                        content: '${args.gwei}',
                      ),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.walletSendGasPrice,
                        content: '${args.gasPrice}',
                      ),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.sharedTransactionFee,
                        content: '${args.fee} $ezcSymbol',
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
                          if (args.erc721 != null) {
                            context.pushRoute(
                                WalletSendErc721Route(args: args.erc721!));
                          } else {
                            context.pushRoute(
                                WalletSendEvmRoute(fromToken: args.token));
                          }
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

class WalletSendEvmConfirmArgs {
  final String address;
  final int gwei;
  final BigInt gasPrice;
  final Decimal amount;
  final Decimal fee;
  final String symbol;
  final WalletTokenItem? token;
  final WalletSendErc721Args? erc721;

  WalletSendEvmConfirmArgs({
    required this.address,
    required this.gwei,
    required this.gasPrice,
    required this.amount,
    required this.fee,
    required this.symbol,
    this.token,
    this.erc721,
  });
}

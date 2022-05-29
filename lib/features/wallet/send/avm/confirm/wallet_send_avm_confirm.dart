// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/auth/pin/verify/pin_code_verify.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/features/wallet/send/avm/confirm/wallet_send_avm_confirm_store.dart';
import 'package:wallet/features/wallet/send/widgets/wallet_send_widgets.dart';
import 'package:wallet/features/wallet/token/wallet_token_item.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletSendAvmConfirmScreen extends StatelessWidget {
  final WalletSendAvmConfirmArgs args;

  final _walletSendAvmStore = WalletSendAvmConfirmStore();

  WalletSendAvmConfirmScreen({Key? key, required this.args}) : super(key: key);

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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        content: args.address,
                        hasDivider: true,
                      ),
                      const SizedBox(height: 8),
                      WalletSendVerticalText(
                        title: Strings.current.sharedMemo,
                        content: args.memo,
                        hasDivider: true,
                      ),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.sharedAmount,
                        content: '${args.amount} ${args.symbol}',
                      ),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.sharedTransactionFee,
                        content: '${args.fee} $ezcSymbol',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Strings.current.sharedNft,
                        style: EZCTitleLargeTextStyle(
                            color: provider.themeMode.text60),
                      ),
                      const SizedBox(height: 4),
                      _NftWidget(),
                      const SizedBox(height: 20),
                      EZCDashedLine(color: provider.themeMode.text10),
                      const SizedBox(height: 8),
                      WalletSendHorizontalText(
                        title: Strings.current.sharedTotal,
                        content: '${args.total} USD',
                        leftColor: provider.themeMode.text,
                        rightColor: provider.themeMode.stateSuccess,
                      ),
                      const Spacer(),
                      Observer(
                        builder: (_) => SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                        context.pushRoute(WalletSendAvmRoute(
                                            fromToken: args.token));
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
                      ),
                      const SizedBox(height:20),
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
    if (!verified) return;
    if (args.withToken) {
      _walletSendAvmStore.sendAnt(args);
    } else {
      _walletSendAvmStore.sendAvm(
        args.address,
        args.amount,
        memo: args.memo,
      );
    }
  }
}

class WalletSendAvmConfirmArgs {
  final String address;
  final String memo;
  final Decimal amount;
  final Decimal fee;
  final Decimal total;
  final WalletTokenItem? token;

  WalletSendAvmConfirmArgs(
      this.address, this.memo, this.amount, this.fee, this.total,
      [this.token]);

  String? get assetId => token?.id;

  bool get withToken => token != null;

  String get symbol => token != null ? token!.symbol : ezcSymbol;
}

class _NftWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 40,
                height: 40,
                child: CachedNetworkImage(
                  imageUrl: '',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                      color: provider.themeMode.text30,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      color: provider.themeMode.secondary,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          // child: item.type.icon,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(200)),
                  border: Border.all(color: provider.themeMode.white),
                  color: provider.themeMode.primary,
                ),
                child: Text(
                  '2',
                  style: EZCTitleCustomTextStyle(
                      size: 8, color: provider.themeMode.secondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

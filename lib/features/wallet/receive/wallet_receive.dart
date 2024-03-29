// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wallet/features/common/constant/wallet_constant.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletReceiveScreen extends StatelessWidget {
  final WalletReceiveArgs args;

  const WalletReceiveScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EZCAppBar(
                title: Strings.current.sharedReceive,
                onPressed: () {
                  context.router.pop();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Assets.icons.icEzc64.svg(width: 32, height: 32),
                            const SizedBox(width: 8),
                            Text(
                              args.symbol,
                              style: EZCBodyLargeTextStyle(
                                  color: provider.themeMode.text),
                            ),
                            const SizedBox(width: 16),
                            EZCChainLabelText(text: args.chain),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 453,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: provider.themeMode.bg,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16))),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            Assets.images.imgEzcAbout.image(
                              width: 151,
                              height: 48,
                            ),
                            const SizedBox(height: 8),
                            QrImage(
                              data: args.address,
                              version: QrVersions.auto,
                              size: 180,
                            ),
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 45),
                              child: Text(
                                args.address.useCorrectEllipsis(),
                                maxLines: 3,
                                style: EZCBodyLargeTextStyle(
                                    color: provider.themeMode.text),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EZCMediumNoneButton(
                                  text: Strings.current.sharedCopy,
                                  iconLeft: Assets.icons.icCopyPrimary.svg(),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  onPressed: _onClickCopy,
                                ),
                                const SizedBox(width: 16),
                                EZCMediumNoneButton(
                                  text: Strings.current.sharedShare,
                                  iconLeft: Assets.icons.icSharePrimary.svg(),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  onPressed: _onClickShare,
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 24),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: Strings.current.walletReceiveSendOnly,
                            style: EZCBodySmallTextStyle(
                                color: provider.themeMode.text90),
                            children: <TextSpan>[
                              TextSpan(
                                  text: args.receiverName,
                                  style: EZCSemiBoldSmallTextStyle(
                                      color: provider.themeMode.text90)),
                              TextSpan(
                                  text: Strings.current.walletReceiveToThis,
                                  style: EZCBodySmallTextStyle(
                                      color: provider.themeMode.text90)),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 16, bottom: 4),
                          child: Text(
                            Strings.current.walletReceiveSetAmount,
                            style: EZCTitleLargeTextStyle(
                                color: provider.themeMode.text60),
                          ),
                        ),
                      )
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

  _onClickCopy() {
    Clipboard.setData(ClipboardData(text: args.address));
    showSnackBar(Strings.current.sharedCopied);
  }

  _onClickShare() {
    shareText(args.address);
  }
}

class WalletReceiveArgs {
  final String chain;
  final String address;
  final String symbol;
  final String name;

  WalletReceiveArgs(
    this.chain,
    this.address, [
    this.symbol = ezcSymbol,
    this.name = ezcName,
  ]);

  String get receiverName => '$name ($symbol)';
}

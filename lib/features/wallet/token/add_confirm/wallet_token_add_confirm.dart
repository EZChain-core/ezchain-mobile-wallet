import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/router.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/asset/erc20/types.dart';
import 'package:wallet/features/common/token/token_store.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/images.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class WalletTokenAddConfirmScreen extends StatelessWidget {
  final WalletTokenAddConfirmArgs args;

  WalletTokenAddConfirmScreen({Key? key, required this.args}) : super(key: key);

  final _tokenStore = getIt<TokenStore>();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EZCAppBar(
                title: Strings.current.walletAddToken,
                onPressed: context.popRoute,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'C-Chain(ERP-20)',
                          style: EZCHeadlineSmallTextStyle(
                              color: provider.themeMode.text),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Strings.current.sharedToken,
                            style: EZCBodyMediumTextStyle(
                                color: provider.themeMode.text),
                          ),
                          Text(
                            Strings.current.sharedBalance,
                            style: EZCBodyMediumTextStyle(
                                color: provider.themeMode.text),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          EZCCircleImage(
                            size: 40,
                            placeholder: Assets.icons.icToken.svg(),
                            src: '',
                          ),
                          const SizedBox(width: 8),
                          Text(
                            args.title,
                            style: EZCBodyMediumTextStyle(
                                color: provider.themeMode.text),
                          ),
                          const Spacer(),
                          Text(
                            args.balance,
                            style: EZCBodyMediumTextStyle(
                                color: provider.themeMode.text),
                          ),
                        ],
                      ),
                      const Spacer(),
                      EZCMediumPrimaryButton(
                        text: Strings.current.walletAddToken,
                        width: 161,
                        onPressed: _onClickAddToken,
                      ),
                      const SizedBox(height: 8),
                      EZCMediumNoneButton(
                        width: 82,
                        text: Strings.current.sharedCancel,
                        textColor: provider.themeMode.text90,
                        onPressed: context.popRoute,
                      ),
                      const SizedBox(height: 24),
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

  _onClickAddToken() async {
    final isSuccess = await _tokenStore.addToken(args.token);
    if (isSuccess) {
      walletContext?.router.replaceAll([const DashboardRoute()]);
    } else {
      showSnackBar(Strings.current.sharedCommonError);
    }
  }
}

class WalletTokenAddConfirmArgs {
  final Erc20TokenData token;

  WalletTokenAddConfirmArgs(this.token);

  get title => '${token.name} (${token.symbol})';

  String get symbol => token.symbol;

  String get balance => '${token.balance} ${token.symbol}';
}

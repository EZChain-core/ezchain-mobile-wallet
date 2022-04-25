// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/route/router.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/store/balance_store.dart';
import 'package:wallet/features/common/store/price_store.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/common/store/validators_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/setting/widgets/setting_item.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/widgets.dart';

class SettingGeneralScreen extends StatelessWidget {
  const SettingGeneralScreen({Key? key}) : super(key: key);

  WalletFactory get walletFactory => getIt<WalletFactory>();
  TokenStore get _tokenStore => getIt<TokenStore>();
  BalanceStore get _balanceStore => getIt<BalanceStore>();
  ValidatorsStore get _validatorsStore => getIt<ValidatorsStore>();
  PriceStore get _priceStore => getIt<PriceStore>();

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EZCAppBar(
                title: Strings.current.settingGeneral,
                onPressed: () {
                  context.router.pop();
                },
              ),
              SettingItem(
                text: Strings.current.sharedLanguage,
                rightText: 'ENG',
                onPressed: () => {},
              ),
              SettingItem(
                text: Strings.current.sharedCurrency,
                rightText: 'USD',
                onPressed: () => {},
              ),
              SettingItem(
                text: Strings.current.settingGeneralRemoveWallet,
                textColor: provider.themeMode.stateDanger,
                onPressed: _onClickRemoveWallet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onClickRemoveWallet() {
    _balanceStore.dispose();
    _tokenStore.dispose();
    _priceStore.dispose();
    _validatorsStore.dispose();
    walletFactory.clear();
    walletContext?.router.replaceAll([const OnBoardRoute()]);
  }
}

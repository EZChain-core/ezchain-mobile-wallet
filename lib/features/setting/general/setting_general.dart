import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/setting/widgets/setting_item.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/widgets.dart';

class SettingGeneralScreen extends StatelessWidget {
  const SettingGeneralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              ROIAppBar(
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
                text: Strings.current.settingGeneralDeactivateAccount,
                onPressed: () => {},
              ),
              SettingItem(
                text: Strings.current.settingGeneralRemoveWallet,
                textColor: provider.themeMode.stateDanger,
                onPressed: () => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

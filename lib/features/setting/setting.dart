import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/setting/general/setting_general.dart';
import 'package:wallet/features/setting/widgets/setting_item.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/theme.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SettingItem(
                text: Strings.current.settingChangePin,
                icon: Assets.icons.icChangePin.svg(),
                onPressed: () =>
                    context.router.push(const SettingChangePinRoute()),
              ),
              SettingItem(
                text: Strings.current.settingWalletSecurity,
                icon: Assets.icons.icSecurity.svg(),
                onPressed: () => context.router.push(const SettingSecurityRoute()),
              ),
              SettingItem(
                text: Strings.current.settingGeneral,
                icon: Assets.icons.icGeneralSetting.svg(),
                onPressed: () => context.router.push(const SettingGeneralRoute()),
              ),
              SettingItem(
                text: Strings.current.settingAboutRoi,
                icon: Assets.icons.icQuestion.svg(),
                onPressed: () => context.router.push(const SettingAboutRoute()),
              ),
              SettingItem(
                text: Strings.current.settingTouchId,
                icon: Assets.icons.icTouchId.svg(),
                isSwitch: true,
                onSwitch: (value) => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

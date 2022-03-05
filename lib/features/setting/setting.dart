import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/features/common/network_config_type.dart';
import 'package:wallet/features/setting/setting_store.dart';
import 'package:wallet/features/setting/widgets/setting_item.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/ezc/wallet/network/constants.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class SettingScreen extends StatelessWidget {
  final _settingStore = SettingStore();

  SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                onPressed: () => context.router.push(SettingSecurityRoute()),
              ),
              SettingItem(
                text: Strings.current.settingGeneral,
                icon: Assets.icons.icGeneralSetting.svg(),
                onPressed: () =>
                    context.router.push(const SettingGeneralRoute()),
              ),
              SettingItem(
                text: Strings.current.settingAboutEZC,
                icon: Assets.icons.icQuestion.svg(),
                onPressed: () => context.router.push(const SettingAboutRoute()),
              ),
              Observer(
                builder: (_) => _settingStore.touchIdAvailable
                    ? SettingItem(
                        text: Strings.current.settingTouchId,
                        icon: Assets.icons.icTouchId.svg(),
                        isSwitch: true,
                        initSwitch: _settingStore.touchIdEnabled,
                        onSwitch: (value) => _settingStore.enableTouchId(value),
                      )
                    : const SizedBox.shrink(),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 10),
                child: Text(
                  Strings.current.settingSwitchNetworks,
                  style: EZCTitleLargeTextStyle(color: provider.themeMode.text),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    color: provider.themeMode.bg),
                child: Observer(
                  builder: (_) => Column(
                    children: [
                      _SettingSwitchNetworkWidget(
                        isActive: _settingStore.activeNetworkConfig ==
                            NetworkConfigType.mainnest,
                        title: Strings.current.settingEzcMainnet,
                        host:
                            '${mainnetConfig.rawUrl}:${mainnetConfig.apiPort}',
                        onPressed: () => _settingStore
                            .setNetworkConfig(NetworkConfigType.mainnest),
                      ),
                      _SettingSwitchNetworkWidget(
                        isActive: _settingStore.activeNetworkConfig ==
                            NetworkConfigType.testnet,
                        title: Strings.current.settingEzcTestnet,
                        host:
                            '${testnetConfig.rawUrl}:${testnetConfig.apiPort}',
                        onPressed: () => _settingStore
                            .setNetworkConfig(NetworkConfigType.testnet),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingSwitchNetworkWidget extends StatelessWidget {
  final String title;
  final String host;
  final bool isActive;
  final Function() onPressed;

  const _SettingSwitchNetworkWidget(
      {Key? key,
      required this.title,
      required this.host,
      required this.isActive,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: isActive ? provider.themeMode.primary10 : null,
            border: Border.all(
                width: 1,
                color:
                    isActive ? provider.themeMode.primary : Colors.transparent),
          ),
          child: Row(
            children: [
              Assets.icons.icEzc64.svg(width: 40, height: 40),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: EZCTitleLargeTextStyle(
                        color: provider.themeMode.text,
                      ),
                    ),
                    Text(
                      host,
                      style: EZCLabelSmallTextStyle(
                          color: provider.themeMode.text60),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

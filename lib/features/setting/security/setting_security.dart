import 'dart:ui';

import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/setting/security/setting_security_store.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class SettingSecurityScreen extends StatelessWidget {
  final _settingSecurityStore = SettingSecurityStore();

  SettingSecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => DefaultTabController(
        length: 3,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                EZCAppBar(
                  title: Strings.current.settingSecurityWalletAddress,
                  onPressed: () {
                    context.router.pop();
                  },
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 100),
                          SizedBox(
                            height: 260,
                            child: TabBarView(
                              children: [
                                _WalletAddressTab(
                                  address: _settingSecurityStore.addressX
                                      .useCorrectEllipsis(),
                                ),
                                _WalletAddressTab(
                                  address: _settingSecurityStore.addressC
                                      .useCorrectEllipsis(),
                                ),
                                _WalletAddressTab(
                                  address: _settingSecurityStore.addressP
                                      .useCorrectEllipsis(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 40,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: provider.themeMode.secondary10,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TabBar(
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: provider.themeMode.secondary,
                              ),
                              labelStyle: EZCTitleLargeTextStyle(
                                  color: provider.themeMode.primary),
                              labelColor: provider.themeMode.primary,
                              unselectedLabelStyle: EZCTitleLargeTextStyle(
                                  color: provider.themeMode.text40),
                              unselectedLabelColor: provider.themeMode.text40,
                              tabs: [
                                Tab(text: Strings.current.sharedXChain),
                                Tab(text: Strings.current.sharedCChain),
                                Tab(text: Strings.current.sharedPChain),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletAddressTab extends StatelessWidget {
  final String address;

  const _WalletAddressTab({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            QrImage(
              data: address,
              version: QrVersions.auto,
              size: 200,
            ),
            Text(
              address,
              textAlign: TextAlign.center,
              style: EZCBodyLargeTextStyle(color: provider.themeMode.text),
            ),
          ],
        ),
      ),
    );
  }
}

class _WalletKeyInfoWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final String content;

  const _WalletKeyInfoWidget(
      {Key? key, required this.title, required this.content, this.titleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: EZCTitleLargeTextStyle(
                color: titleColor ?? provider.themeMode.text60),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: provider.themeMode.border),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: SelectableText(
              content,
              style: EZCBodySmallTextStyle(color: provider.themeMode.text),
            ),
          )
        ],
      ),
    );
  }
}

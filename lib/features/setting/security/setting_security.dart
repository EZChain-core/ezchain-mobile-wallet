import 'dart:ui';

import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class SettingSecurityScreen extends StatelessWidget {
  const SettingSecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => DefaultTabController(
        length: 3,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                ROIAppBar(
                  title: Strings.current.settingWalletSecurity,
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
                          Text(
                            Strings.current.settingSecurityWalletAddress,
                            style: ROITitleLargeTextStyle(
                                color: provider.themeMode.text),
                          ),
                          SizedBox(
                            height: 260,
                            child: TabBarView(
                              children: [
                                _WalletAddressTab(),
                                _WalletAddressTab(),
                                _WalletAddressTab(),
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
                              labelStyle: ROITitleLargeTextStyle(
                                  color: provider.themeMode.primary),
                              labelColor: provider.themeMode.primary,
                              unselectedLabelStyle: ROITitleLargeTextStyle(
                                  color: provider.themeMode.secondary60),
                              unselectedLabelColor:
                                  provider.themeMode.secondary60,
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
  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl:
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png",
              width: double.infinity,
              height: 200,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.fitHeight),
                ),
              ),
              placeholder: (context, url) =>
                  ColoredBox(color: provider.themeMode.text10),
              errorWidget: (context, url, error) =>
                  ColoredBox(color: provider.themeMode.text10),
              fadeInCurve: Curves.linear,
              fadeInDuration: const Duration(milliseconds: 0),
              fadeOutCurve: Curves.linear,
              fadeOutDuration: const Duration(milliseconds: 0),
            ),
            Text(
              'X-fuji1qen0kzvn34zc8jsdatym8tacukgdfepyk9ees2',
              textAlign: TextAlign.center,
              style: ROIBodyLargeTextStyle(color: provider.themeMode.text),
            ),
          ],
        ),
      ),
    );
  }
}

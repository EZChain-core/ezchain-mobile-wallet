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
                          const SizedBox(
                            height: 260,
                            child: TabBarView(
                              children: [
                                _WalletAddressTab(
                                  qrCode:
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png',
                                  address:
                                      'X-fuji1qen0kzvn34zc8jsdatym8tacukgdfepyk9ees2',
                                ),
                                _WalletAddressTab(
                                  qrCode:
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png',
                                  address:
                                      'X-fuji1qen0kzvn34zc8jsdatym8tacukgdfepyk9ees2',
                                ),
                                _WalletAddressTab(
                                  qrCode:
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png',
                                  address:
                                      'X-fuji1qen0kzvn34zc8jsdatym8tacukgdfepyk9ees2',
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
                              labelStyle: ROITitleLargeTextStyle(
                                  color: provider.themeMode.primary),
                              labelColor: provider.themeMode.primary,
                              unselectedLabelStyle: ROITitleLargeTextStyle(
                                  color: provider.themeMode.text40),
                              unselectedLabelColor:
                                  provider.themeMode.text40,
                              tabs: [
                                Tab(text: Strings.current.sharedXChain),
                                Tab(text: Strings.current.sharedCChain),
                                Tab(text: Strings.current.sharedPChain),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Divider(color: provider.themeMode.text10),
                          const SizedBox(height: 16),
                          Text(
                            Strings.current.sharedPrivateKey,
                            style: ROITitleLargeTextStyle(
                                color: provider.themeMode.text),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Strings.current.settingSecurityPrivateKeyNote,
                            style: ROIBodySmallTextStyle(
                                color: provider.themeMode.text70),
                          ),
                          const SizedBox(height: 16),
                          _WalletKeyInfoWidget(
                            title: Strings.current.sharedPrivateKey,
                            content:
                                'PrivatekeyHbot5UuF4d65zDPtDGPNFLZacAJku7ErTwK2otD4iwejoywne',
                          ),
                          const SizedBox(height: 16),
                          _WalletKeyInfoWidget(
                            title: Strings.current.settingSecurityCPrivateKey,
                            content:
                                'PrivatekeyHbot5UuF4d65zDPtDGPNFLZacAJku7ErTwK2otD4iwejoywne',
                          ),
                          const SizedBox(height: 24),
                          Divider(color: provider.themeMode.text10),
                          const SizedBox(height: 16),
                          _WalletKeyInfoWidget(
                            title: Strings.current.sharedPassphrase,
                            titleColor: provider.themeMode.text,
                            content:
                                'blouse airport promote orchard glare phone scrap make siren battle settle trade capable urban lecture vacuum prepare oil keep decide saddle inform thunder option',
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
  final String qrCode;
  final String address;

  const _WalletAddressTab(
      {Key? key, required this.qrCode, required this.address})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: qrCode,
              width: 200,
              height: 200,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.fitWidth),
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
              address,
              textAlign: TextAlign.center,
              style: ROIBodyLargeTextStyle(color: provider.themeMode.text),
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
            style: ROITitleLargeTextStyle(
                color: titleColor ?? provider.themeMode.text60),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                border:
                    Border.all(width: 1, color: provider.themeMode.border),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Text(
              content,
              style: ROIBodySmallTextStyle(color: provider.themeMode.text),
            ),
          )
        ],
      ),
    );
  }
}

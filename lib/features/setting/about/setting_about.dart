// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class SettingAboutScreen extends StatelessWidget {
  const SettingAboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EZCAppBar(
                title: Strings.current.settingAboutEZC,
                onPressed: context.router.pop
              ),
              const SizedBox(height: 88),
              Assets.images.imgEzcAbout.image(
                width: 151,
                height: 41,
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  Strings.current.settingEZChainAbout,
                  style:
                      EZCBodyLargeTextStyle(color: provider.themeMode.text70),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Assets.images.imgOnboardOne.image(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

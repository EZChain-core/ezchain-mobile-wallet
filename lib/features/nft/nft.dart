// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class NftScreen extends StatelessWidget {
  const NftScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: provider.themeMode.bg,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.current.nftNewFamily,
                        style: EZCTitleLargeTextStyle(
                            color: provider.themeMode.text),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Strings.current.nftNewFamilyDesc,
                        style: EZCBodyLargeTextStyle(
                            color: provider.themeMode.text70),
                      ),
                      const SizedBox(height: 24),
                      EZCMediumPrimaryButton(
                        width: 130,
                        text: Strings.current.nftNewFamily,
                        enabled: true,
                        onPressed: () {
                          context.pushRoute(NftFamilyCreateRoute());
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: provider.themeMode.bg,
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.current.nftMintCollectible,
                        style: EZCTitleLargeTextStyle(
                            color: provider.themeMode.text),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Strings.current.nftMintCollectibleDesc,
                        style: EZCBodyLargeTextStyle(
                            color: provider.themeMode.text70),
                      ),
                      const SizedBox(height: 24),
                      EZCMediumPrimaryButton(
                        width: 130,
                        text: Strings.current.nftMint,
                        enabled: true,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

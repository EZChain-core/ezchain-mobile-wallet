import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/wallet/roi/wallet_roi_chain.dart';
import 'package:wallet/features/wallet/token/wallet_token.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Stack(
            children: [
              Assets.images.imgBgWallet.image(
                width: double.infinity,
                height: 188,
                fit: BoxFit.cover
              ),
              Column(
                children: [
                  const SizedBox(height: 52),
                  Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: provider.themeMode.midnightBlue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: provider.themeMode.secondary,
                      ),
                      labelStyle: EZCTitleLargeTextStyle(
                          color: provider.themeMode.primary),
                      labelColor: provider.themeMode.primary,
                      unselectedLabelStyle: EZCTitleLargeTextStyle(
                          color: provider.themeMode.secondary60),
                      unselectedLabelColor: provider.themeMode.secondary60,
                      tabs: [
                        Tab(text: Strings.current.sharedEZChain),
                        Tab(text: Strings.current.sharedToken),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        WalletROIChainScreen(),
                        WalletTokenScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => AutoTabsScaffold(
        routes: [
          const WalletRoute(),
          const CrossRoute(),
          const EarnRoute(),
          const NftRoute(),
          SettingRoute(),
        ],
        homeIndex: 0,
        bottomNavigationBuilder: (_, tabsRouter) {
          return BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            selectedItemColor: provider.themeMode.primary,
            unselectedItemColor: provider.themeMode.text40,
            onTap: tabsRouter.setActiveIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                label: Strings.current.dashboardWallet,
                icon: Assets.icons.icWalletOutline.svg(),
                activeIcon: Assets.icons.icWalletOutline
                    .svg(color: provider.themeMode.primary),
                backgroundColor: provider.themeMode.white,
              ),
              BottomNavigationBarItem(
                label: Strings.current.dashboardCross,
                icon: Assets.icons.icTwoArrow.svg(),
                activeIcon: Assets.icons.icTwoArrow
                    .svg(color: provider.themeMode.primary),
                backgroundColor: provider.themeMode.white,
              ),
              BottomNavigationBarItem(
                label: Strings.current.dashboardEarn,
                icon: Assets.icons.icEarnOutline.svg(),
                activeIcon: Assets.icons.icEarnOutline
                    .svg(color: provider.themeMode.primary),
                backgroundColor: provider.themeMode.white,
              ),
              BottomNavigationBarItem(
                label: Strings.current.dashboardNft,
                icon: Assets.icons.icDiamondOutline.svg(),
                activeIcon: Assets.icons.icDiamond.svg(),
                backgroundColor: provider.themeMode.white,
              ),
              BottomNavigationBarItem(
                label: Strings.current.dashboardSetting,
                icon: Assets.icons.icSettingOutline.svg(),
                activeIcon: Assets.icons.icSettingOutline
                    .svg(color: provider.themeMode.primary),
                backgroundColor: provider.themeMode.white,
              ),
            ],
          );
        },
      ),
    );
  }
}

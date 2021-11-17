import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wallet/common/router.gr.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
        routes: const [
          WalletRoute(),
          CrossRoute(),
          SettingRoute(),
        ],
        bottomNavigationBuilder: (_, tabsRouter) {
          return BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: const [
              BottomNavigationBarItem(
                  label: 'Wallet', icon: Icon(Icons.wallet_giftcard)),
              BottomNavigationBarItem(label: 'Cross', icon: Icon(Icons.replay)),
              BottomNavigationBarItem(
                  label: 'Setting', icon: Icon(Icons.app_settings_alt)),
            ],
          );
        });
  }
}

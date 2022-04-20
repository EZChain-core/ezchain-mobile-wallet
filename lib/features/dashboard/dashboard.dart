import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/common/connectivity.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ConnectivityResult? _connectionStatus;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) =>
          AutoTabsScaffold(
            routes: [
              const WalletRoute(),
              const CrossRoute(),
              EarnRoute(),
              NftRoute(),
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
                    activeIcon: Assets.icons.icTwoArrow.svg(
                      color: provider.themeMode.primary,
                    ),
                    backgroundColor: provider.themeMode.white,
                  ),
                  BottomNavigationBarItem(
                    label: Strings.current.dashboardEarn,
                    icon: Assets.icons.icEarnOutline.svg(),
                    activeIcon: Assets.icons.icEarnOutline.svg(
                      color: provider.themeMode.primary,
                    ),
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
                    activeIcon: Assets.icons.icSettingOutline.svg(
                      color: provider.themeMode.primary,
                    ),
                    backgroundColor: provider.themeMode.white,
                  ),
                ],
              );
            },
          ),
    );
  }

  Future<void> _initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      logger.e('Could not check connectivity status', e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    logger.i("Connection status = $result");
    switch (result) {
      case ConnectivityResult.none:
        _connectionStatus = result;
        showInternetConnectionDisconnectedSnackBar();
        break;
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.mobile:
      case ConnectivityResult.bluetooth:
        if (_connectionStatus == ConnectivityResult.none) {
          showInternetConnectionConnectedSnackBar();
        }
        _connectionStatus = result;
        break;
    }
  }
}

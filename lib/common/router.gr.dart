// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:wallet/features/auth/access/mnemonic/access_mnemonic_key.dart'
    as _i7;
import 'package:wallet/features/auth/access/options/access_wallet_options.dart'
    as _i3;
import 'package:wallet/features/auth/access/private_key/access_private_key.dart'
    as _i6;
import 'package:wallet/features/auth/create/create_wallet.dart' as _i4;
import 'package:wallet/features/auth/create/create_wallet_confirm.dart' as _i5;
import 'package:wallet/features/cross/cross.dart' as _i10;
import 'package:wallet/features/dashboard/dashboard.dart' as _i8;
import 'package:wallet/features/onboard/on_board.dart' as _i2;
import 'package:wallet/features/setting/setting.dart' as _i11;
import 'package:wallet/features/splash/screen/splash.dart' as _i1;
import 'package:wallet/features/wallet/wallet.dart' as _i9;

class AppRouter extends _i12.RootStackRouter {
  AppRouter([_i13.GlobalKey<_i13.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i1.SplashScreen());
    },
    OnBoardRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i2.OnBoardScreen());
    },
    AccessWalletOptionsRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.AccessWalletOptionsScreen());
    },
    CreateWalletRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.CreateWalletScreen());
    },
    CreateWalletConfirmRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i5.CreateWalletConfirmScreen());
    },
    AccessPrivateKeyRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i6.AccessPrivateKeyScreen());
    },
    AccessMnemonicKeyRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i7.AccessMnemonicKeyScreen());
    },
    DashboardRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i8.DashboardScreen());
    },
    WalletRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i9.WalletScreen());
    },
    CrossRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i10.CrossScreen());
    },
    SettingRoute.name: (routeData) {
      return _i12.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i11.SettingScreen());
    }
  };

  @override
  List<_i12.RouteConfig> get routes => [
        _i12.RouteConfig('/#redirect',
            path: '/', redirectTo: '/splash', fullMatch: true),
        _i12.RouteConfig(SplashRoute.name, path: '/splash'),
        _i12.RouteConfig(OnBoardRoute.name, path: '/onboard'),
        _i12.RouteConfig(AccessWalletOptionsRoute.name,
            path: '/access-wallet-options-screen'),
        _i12.RouteConfig(CreateWalletRoute.name, path: '/create-wallet-screen'),
        _i12.RouteConfig(CreateWalletConfirmRoute.name,
            path: '/create-wallet-confirm-screen'),
        _i12.RouteConfig(AccessPrivateKeyRoute.name,
            path: '/access-private-key-screen'),
        _i12.RouteConfig(AccessMnemonicKeyRoute.name,
            path: '/access-mnemonic-key-screen'),
        _i12.RouteConfig(DashboardRoute.name, path: '/dashboard', children: [
          _i12.RouteConfig(WalletRoute.name,
              path: 'wallet', parent: DashboardRoute.name),
          _i12.RouteConfig(CrossRoute.name,
              path: 'cross', parent: DashboardRoute.name),
          _i12.RouteConfig(SettingRoute.name,
              path: 'setting', parent: DashboardRoute.name)
        ])
      ];
}

/// generated route for [_i1.SplashScreen]
class SplashRoute extends _i12.PageRouteInfo<void> {
  const SplashRoute() : super(name, path: '/splash');

  static const String name = 'SplashRoute';
}

/// generated route for [_i2.OnBoardScreen]
class OnBoardRoute extends _i12.PageRouteInfo<void> {
  const OnBoardRoute() : super(name, path: '/onboard');

  static const String name = 'OnBoardRoute';
}

/// generated route for [_i3.AccessWalletOptionsScreen]
class AccessWalletOptionsRoute extends _i12.PageRouteInfo<void> {
  const AccessWalletOptionsRoute()
      : super(name, path: '/access-wallet-options-screen');

  static const String name = 'AccessWalletOptionsRoute';
}

/// generated route for [_i4.CreateWalletScreen]
class CreateWalletRoute extends _i12.PageRouteInfo<void> {
  const CreateWalletRoute() : super(name, path: '/create-wallet-screen');

  static const String name = 'CreateWalletRoute';
}

/// generated route for [_i5.CreateWalletConfirmScreen]
class CreateWalletConfirmRoute extends _i12.PageRouteInfo<void> {
  const CreateWalletConfirmRoute()
      : super(name, path: '/create-wallet-confirm-screen');

  static const String name = 'CreateWalletConfirmRoute';
}

/// generated route for [_i6.AccessPrivateKeyScreen]
class AccessPrivateKeyRoute extends _i12.PageRouteInfo<void> {
  const AccessPrivateKeyRoute()
      : super(name, path: '/access-private-key-screen');

  static const String name = 'AccessPrivateKeyRoute';
}

/// generated route for [_i7.AccessMnemonicKeyScreen]
class AccessMnemonicKeyRoute extends _i12.PageRouteInfo<void> {
  const AccessMnemonicKeyRoute()
      : super(name, path: '/access-mnemonic-key-screen');

  static const String name = 'AccessMnemonicKeyRoute';
}

/// generated route for [_i8.DashboardScreen]
class DashboardRoute extends _i12.PageRouteInfo<void> {
  const DashboardRoute({List<_i12.PageRouteInfo>? children})
      : super(name, path: '/dashboard', initialChildren: children);

  static const String name = 'DashboardRoute';
}

/// generated route for [_i9.WalletScreen]
class WalletRoute extends _i12.PageRouteInfo<void> {
  const WalletRoute() : super(name, path: 'wallet');

  static const String name = 'WalletRoute';
}

/// generated route for [_i10.CrossScreen]
class CrossRoute extends _i12.PageRouteInfo<void> {
  const CrossRoute() : super(name, path: 'cross');

  static const String name = 'CrossRoute';
}

/// generated route for [_i11.SettingScreen]
class SettingRoute extends _i12.PageRouteInfo<void> {
  const SettingRoute() : super(name, path: 'setting');

  static const String name = 'SettingRoute';
}

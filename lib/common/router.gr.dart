// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i14;
import 'package:flutter/material.dart' as _i15;
import 'package:wallet/features/auth/access/mnemonic/access_mnemonic_key.dart'
    as _i7;
import 'package:wallet/features/auth/access/options/access_wallet_options.dart'
    as _i3;
import 'package:wallet/features/auth/access/private_key/access_private_key.dart'
    as _i6;
import 'package:wallet/features/auth/create/confirm/create_wallet_confirm.dart'
    as _i5;
import 'package:wallet/features/auth/create/create_wallet.dart' as _i4;
import 'package:wallet/features/auth/pin/pin_code_confirm.dart' as _i9;
import 'package:wallet/features/auth/pin/pin_code_setup.dart' as _i8;
import 'package:wallet/features/cross/cross.dart' as _i12;
import 'package:wallet/features/dashboard/dashboard.dart' as _i10;
import 'package:wallet/features/onboard/on_board.dart' as _i2;
import 'package:wallet/features/setting/setting.dart' as _i13;
import 'package:wallet/features/splash/screen/splash.dart' as _i1;
import 'package:wallet/features/wallet/wallet.dart' as _i11;

class AppRouter extends _i14.RootStackRouter {
  AppRouter([_i15.GlobalKey<_i15.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i14.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i1.SplashScreen());
    },
    OnBoardRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i2.OnBoardScreen());
    },
    AccessWalletOptionsRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.AccessWalletOptionsScreen());
    },
    CreateWalletRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.CreateWalletScreen());
    },
    CreateWalletConfirmRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i5.CreateWalletConfirmScreen());
    },
    AccessPrivateKeyRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i6.AccessPrivateKeyScreen());
    },
    AccessMnemonicKeyRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i7.AccessMnemonicKeyScreen());
    },
    PinCodeSetupRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i8.PinCodeSetupScreen());
    },
    PinCodeConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<PinCodeConfirmRouteArgs>();
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: _i9.PinCodeConfirmScreen(pin: args.pin));
    },
    DashboardRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i10.DashboardScreen());
    },
    WalletRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i11.WalletScreen());
    },
    CrossRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i12.CrossScreen());
    },
    SettingRoute.name: (routeData) {
      return _i14.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i13.SettingScreen());
    }
  };

  @override
  List<_i14.RouteConfig> get routes => [
        _i14.RouteConfig('/#redirect',
            path: '/', redirectTo: '/splash', fullMatch: true),
        _i14.RouteConfig(SplashRoute.name, path: '/splash'),
        _i14.RouteConfig(OnBoardRoute.name, path: '/onboard'),
        _i14.RouteConfig(AccessWalletOptionsRoute.name,
            path: '/access-wallet-options-screen'),
        _i14.RouteConfig(CreateWalletRoute.name, path: '/create-wallet-screen'),
        _i14.RouteConfig(CreateWalletConfirmRoute.name,
            path: '/create-wallet-confirm-screen'),
        _i14.RouteConfig(AccessPrivateKeyRoute.name,
            path: '/access-private-key-screen'),
        _i14.RouteConfig(AccessMnemonicKeyRoute.name,
            path: '/access-mnemonic-key-screen'),
        _i14.RouteConfig(PinCodeSetupRoute.name,
            path: '/pin-code-setup-screen'),
        _i14.RouteConfig(PinCodeConfirmRoute.name,
            path: '/pin-code-confirm-screen'),
        _i14.RouteConfig(DashboardRoute.name, path: '/dashboard', children: [
          _i14.RouteConfig(WalletRoute.name,
              path: 'wallet', parent: DashboardRoute.name),
          _i14.RouteConfig(CrossRoute.name,
              path: 'cross', parent: DashboardRoute.name),
          _i14.RouteConfig(SettingRoute.name,
              path: 'setting', parent: DashboardRoute.name)
        ])
      ];
}

/// generated route for [_i1.SplashScreen]
class SplashRoute extends _i14.PageRouteInfo<void> {
  const SplashRoute() : super(name, path: '/splash');

  static const String name = 'SplashRoute';
}

/// generated route for [_i2.OnBoardScreen]
class OnBoardRoute extends _i14.PageRouteInfo<void> {
  const OnBoardRoute() : super(name, path: '/onboard');

  static const String name = 'OnBoardRoute';
}

/// generated route for [_i3.AccessWalletOptionsScreen]
class AccessWalletOptionsRoute extends _i14.PageRouteInfo<void> {
  const AccessWalletOptionsRoute()
      : super(name, path: '/access-wallet-options-screen');

  static const String name = 'AccessWalletOptionsRoute';
}

/// generated route for [_i4.CreateWalletScreen]
class CreateWalletRoute extends _i14.PageRouteInfo<void> {
  const CreateWalletRoute() : super(name, path: '/create-wallet-screen');

  static const String name = 'CreateWalletRoute';
}

/// generated route for [_i5.CreateWalletConfirmScreen]
class CreateWalletConfirmRoute extends _i14.PageRouteInfo<void> {
  const CreateWalletConfirmRoute()
      : super(name, path: '/create-wallet-confirm-screen');

  static const String name = 'CreateWalletConfirmRoute';
}

/// generated route for [_i6.AccessPrivateKeyScreen]
class AccessPrivateKeyRoute extends _i14.PageRouteInfo<void> {
  const AccessPrivateKeyRoute()
      : super(name, path: '/access-private-key-screen');

  static const String name = 'AccessPrivateKeyRoute';
}

/// generated route for [_i7.AccessMnemonicKeyScreen]
class AccessMnemonicKeyRoute extends _i14.PageRouteInfo<void> {
  const AccessMnemonicKeyRoute()
      : super(name, path: '/access-mnemonic-key-screen');

  static const String name = 'AccessMnemonicKeyRoute';
}

/// generated route for [_i8.PinCodeSetupScreen]
class PinCodeSetupRoute extends _i14.PageRouteInfo<void> {
  const PinCodeSetupRoute() : super(name, path: '/pin-code-setup-screen');

  static const String name = 'PinCodeSetupRoute';
}

/// generated route for [_i9.PinCodeConfirmScreen]
class PinCodeConfirmRoute extends _i14.PageRouteInfo<PinCodeConfirmRouteArgs> {
  PinCodeConfirmRoute({required String pin})
      : super(name,
            path: '/pin-code-confirm-screen',
            args: PinCodeConfirmRouteArgs(pin: pin));

  static const String name = 'PinCodeConfirmRoute';
}

class PinCodeConfirmRouteArgs {
  const PinCodeConfirmRouteArgs({required this.pin});

  final String pin;

  @override
  String toString() {
    return 'PinCodeConfirmRouteArgs{pin: $pin}';
  }
}

/// generated route for [_i10.DashboardScreen]
class DashboardRoute extends _i14.PageRouteInfo<void> {
  const DashboardRoute({List<_i14.PageRouteInfo>? children})
      : super(name, path: '/dashboard', initialChildren: children);

  static const String name = 'DashboardRoute';
}

/// generated route for [_i11.WalletScreen]
class WalletRoute extends _i14.PageRouteInfo<void> {
  const WalletRoute() : super(name, path: 'wallet');

  static const String name = 'WalletRoute';
}

/// generated route for [_i12.CrossScreen]
class CrossRoute extends _i14.PageRouteInfo<void> {
  const CrossRoute() : super(name, path: 'cross');

  static const String name = 'CrossRoute';
}

/// generated route for [_i13.SettingScreen]
class SettingRoute extends _i14.PageRouteInfo<void> {
  const SettingRoute() : super(name, path: 'setting');

  static const String name = 'SettingRoute';
}

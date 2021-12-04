// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i17;
import 'package:flutter/material.dart' as _i18;
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
import 'package:wallet/features/earn/earn.dart' as _i13;
import 'package:wallet/features/onboard/on_board.dart' as _i2;
import 'package:wallet/features/setting/setting.dart' as _i14;
import 'package:wallet/features/splash/screen/splash.dart' as _i1;
import 'package:wallet/features/wallet/roi/wallet_roi_chain.dart' as _i15;
import 'package:wallet/features/wallet/token/wallet_token.dart' as _i16;
import 'package:wallet/features/wallet/wallet.dart' as _i11;

class AppRouter extends _i17.RootStackRouter {
  AppRouter([_i18.GlobalKey<_i18.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i17.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i1.SplashScreen());
    },
    OnBoardRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i2.OnBoardScreen());
    },
    AccessWalletOptionsRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.AccessWalletOptionsScreen());
    },
    CreateWalletRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.CreateWalletScreen());
    },
    CreateWalletConfirmRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i5.CreateWalletConfirmScreen());
    },
    AccessPrivateKeyRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i6.AccessPrivateKeyScreen());
    },
    AccessMnemonicKeyRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i7.AccessMnemonicKeyScreen());
    },
    PinCodeSetupRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i8.PinCodeSetupScreen());
    },
    PinCodeConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<PinCodeConfirmRouteArgs>();
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: _i9.PinCodeConfirmScreen(pin: args.pin));
    },
    DashboardRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i10.DashboardScreen());
    },
    WalletRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i11.WalletScreen());
    },
    CrossRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i12.CrossScreen());
    },
    EarnRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i13.EarnScreen());
    },
    SettingRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i14.SettingScreen());
    },
    WalletROIChainRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i15.WalletROIChainScreen());
    },
    WalletTokenRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i16.WalletTokenScreen());
    }
  };

  @override
  List<_i17.RouteConfig> get routes => [
        _i17.RouteConfig('/#redirect',
            path: '/', redirectTo: '/splash', fullMatch: true),
        _i17.RouteConfig(SplashRoute.name, path: '/splash'),
        _i17.RouteConfig(OnBoardRoute.name, path: '/onboard'),
        _i17.RouteConfig(AccessWalletOptionsRoute.name,
            path: '/access-wallet-options-screen'),
        _i17.RouteConfig(CreateWalletRoute.name, path: '/create-wallet-screen'),
        _i17.RouteConfig(CreateWalletConfirmRoute.name,
            path: '/create-wallet-confirm-screen'),
        _i17.RouteConfig(AccessPrivateKeyRoute.name,
            path: '/access-private-key-screen'),
        _i17.RouteConfig(AccessMnemonicKeyRoute.name,
            path: '/access-mnemonic-key-screen'),
        _i17.RouteConfig(PinCodeSetupRoute.name,
            path: '/pin-code-setup-screen'),
        _i17.RouteConfig(PinCodeConfirmRoute.name,
            path: '/pin-code-confirm-screen'),
        _i17.RouteConfig(DashboardRoute.name, path: '/dashboard', children: [
          _i17.RouteConfig(WalletRoute.name,
              path: 'wallet',
              parent: DashboardRoute.name,
              children: [
                _i17.RouteConfig(WalletROIChainRoute.name,
                    path: 'roi', parent: WalletRoute.name),
                _i17.RouteConfig(WalletTokenRoute.name,
                    path: 'token', parent: WalletRoute.name)
              ]),
          _i17.RouteConfig(CrossRoute.name,
              path: 'cross', parent: DashboardRoute.name),
          _i17.RouteConfig(EarnRoute.name,
              path: 'earn', parent: DashboardRoute.name),
          _i17.RouteConfig(SettingRoute.name,
              path: 'setting', parent: DashboardRoute.name)
        ])
      ];
}

/// generated route for [_i1.SplashScreen]
class SplashRoute extends _i17.PageRouteInfo<void> {
  const SplashRoute() : super(name, path: '/splash');

  static const String name = 'SplashRoute';
}

/// generated route for [_i2.OnBoardScreen]
class OnBoardRoute extends _i17.PageRouteInfo<void> {
  const OnBoardRoute() : super(name, path: '/onboard');

  static const String name = 'OnBoardRoute';
}

/// generated route for [_i3.AccessWalletOptionsScreen]
class AccessWalletOptionsRoute extends _i17.PageRouteInfo<void> {
  const AccessWalletOptionsRoute()
      : super(name, path: '/access-wallet-options-screen');

  static const String name = 'AccessWalletOptionsRoute';
}

/// generated route for [_i4.CreateWalletScreen]
class CreateWalletRoute extends _i17.PageRouteInfo<void> {
  const CreateWalletRoute() : super(name, path: '/create-wallet-screen');

  static const String name = 'CreateWalletRoute';
}

/// generated route for [_i5.CreateWalletConfirmScreen]
class CreateWalletConfirmRoute extends _i17.PageRouteInfo<void> {
  const CreateWalletConfirmRoute()
      : super(name, path: '/create-wallet-confirm-screen');

  static const String name = 'CreateWalletConfirmRoute';
}

/// generated route for [_i6.AccessPrivateKeyScreen]
class AccessPrivateKeyRoute extends _i17.PageRouteInfo<void> {
  const AccessPrivateKeyRoute()
      : super(name, path: '/access-private-key-screen');

  static const String name = 'AccessPrivateKeyRoute';
}

/// generated route for [_i7.AccessMnemonicKeyScreen]
class AccessMnemonicKeyRoute extends _i17.PageRouteInfo<void> {
  const AccessMnemonicKeyRoute()
      : super(name, path: '/access-mnemonic-key-screen');

  static const String name = 'AccessMnemonicKeyRoute';
}

/// generated route for [_i8.PinCodeSetupScreen]
class PinCodeSetupRoute extends _i17.PageRouteInfo<void> {
  const PinCodeSetupRoute() : super(name, path: '/pin-code-setup-screen');

  static const String name = 'PinCodeSetupRoute';
}

/// generated route for [_i9.PinCodeConfirmScreen]
class PinCodeConfirmRoute extends _i17.PageRouteInfo<PinCodeConfirmRouteArgs> {
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
class DashboardRoute extends _i17.PageRouteInfo<void> {
  const DashboardRoute({List<_i17.PageRouteInfo>? children})
      : super(name, path: '/dashboard', initialChildren: children);

  static const String name = 'DashboardRoute';
}

/// generated route for [_i11.WalletScreen]
class WalletRoute extends _i17.PageRouteInfo<void> {
  const WalletRoute({List<_i17.PageRouteInfo>? children})
      : super(name, path: 'wallet', initialChildren: children);

  static const String name = 'WalletRoute';
}

/// generated route for [_i12.CrossScreen]
class CrossRoute extends _i17.PageRouteInfo<void> {
  const CrossRoute() : super(name, path: 'cross');

  static const String name = 'CrossRoute';
}

/// generated route for [_i13.EarnScreen]
class EarnRoute extends _i17.PageRouteInfo<void> {
  const EarnRoute() : super(name, path: 'earn');

  static const String name = 'EarnRoute';
}

/// generated route for [_i14.SettingScreen]
class SettingRoute extends _i17.PageRouteInfo<void> {
  const SettingRoute() : super(name, path: 'setting');

  static const String name = 'SettingRoute';
}

/// generated route for [_i15.WalletROIChainScreen]
class WalletROIChainRoute extends _i17.PageRouteInfo<void> {
  const WalletROIChainRoute() : super(name, path: 'roi');

  static const String name = 'WalletROIChainRoute';
}

/// generated route for [_i16.WalletTokenScreen]
class WalletTokenRoute extends _i17.PageRouteInfo<void> {
  const WalletTokenRoute() : super(name, path: 'token');

  static const String name = 'WalletTokenRoute';
}

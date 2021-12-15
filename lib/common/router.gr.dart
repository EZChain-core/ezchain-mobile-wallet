// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i18;
import 'package:flutter/material.dart' as _i19;
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
import 'package:wallet/features/cross/cross.dart' as _i15;
import 'package:wallet/features/dashboard/dashboard.dart' as _i13;
import 'package:wallet/features/earn/earn.dart' as _i16;
import 'package:wallet/features/onboard/on_board.dart' as _i2;
import 'package:wallet/features/setting/setting.dart' as _i17;
import 'package:wallet/features/splash/screen/splash.dart' as _i1;
import 'package:wallet/features/wallet/receive/wallet_receive.dart' as _i10;
import 'package:wallet/features/wallet/send/x_chain/wallet_send_x_chain.dart'
    as _i11;
import 'package:wallet/features/wallet/send/x_chain/wallet_send_x_chain_confirm.dart'
    as _i12;
import 'package:wallet/features/wallet/wallet.dart' as _i14;

class AppRouter extends _i18.RootStackRouter {
  AppRouter([_i19.GlobalKey<_i19.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i18.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i1.SplashScreen());
    },
    OnBoardRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i2.OnBoardScreen());
    },
    AccessWalletOptionsRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.AccessWalletOptionsScreen());
    },
    CreateWalletRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.CreateWalletScreen());
    },
    CreateWalletConfirmRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i5.CreateWalletConfirmScreen());
    },
    AccessPrivateKeyRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i6.AccessPrivateKeyScreen());
    },
    AccessMnemonicKeyRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i7.AccessMnemonicKeyScreen());
    },
    PinCodeSetupRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i8.PinCodeSetupScreen());
    },
    PinCodeConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<PinCodeConfirmRouteArgs>();
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: _i9.PinCodeConfirmScreen(pin: args.pin));
    },
    WalletReceiveRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i10.WalletReceiveScreen());
    },
    WalletSendXChainRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i11.WalletSendXChainScreen());
    },
    WalletSendXChainConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendXChainConfirmRouteArgs>();
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i12.WalletSendXChainConfirmScreen(
              key: args.key, walletViewData: args.walletViewData));
    },
    DashboardRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i13.DashboardScreen());
    },
    WalletRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i14.WalletScreen());
    },
    CrossRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i15.CrossScreen());
    },
    EarnRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i16.EarnScreen());
    },
    SettingRoute.name: (routeData) {
      return _i18.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i17.SettingScreen());
    }
  };

  @override
  List<_i18.RouteConfig> get routes => [
        _i18.RouteConfig('/#redirect',
            path: '/', redirectTo: '/splash', fullMatch: true),
        _i18.RouteConfig(SplashRoute.name, path: '/splash'),
        _i18.RouteConfig(OnBoardRoute.name, path: '/onboard'),
        _i18.RouteConfig(AccessWalletOptionsRoute.name,
            path: '/access-wallet-options-screen'),
        _i18.RouteConfig(CreateWalletRoute.name, path: '/create-wallet-screen'),
        _i18.RouteConfig(CreateWalletConfirmRoute.name,
            path: '/create-wallet-confirm-screen'),
        _i18.RouteConfig(AccessPrivateKeyRoute.name,
            path: '/access-private-key-screen'),
        _i18.RouteConfig(AccessMnemonicKeyRoute.name,
            path: '/access-mnemonic-key-screen'),
        _i18.RouteConfig(PinCodeSetupRoute.name,
            path: '/pin-code-setup-screen'),
        _i18.RouteConfig(PinCodeConfirmRoute.name,
            path: '/pin-code-confirm-screen'),
        _i18.RouteConfig(WalletReceiveRoute.name,
            path: '/wallet-receive-screen'),
        _i18.RouteConfig(WalletSendXChainRoute.name,
            path: '/wallet-send-xchain-screen'),
        _i18.RouteConfig(WalletSendXChainConfirmRoute.name,
            path: '/wallet-send-xchain-confirm-screen'),
        _i18.RouteConfig(DashboardRoute.name, path: '/dashboard', children: [
          _i18.RouteConfig(WalletRoute.name,
              path: 'wallet', parent: DashboardRoute.name),
          _i18.RouteConfig(CrossRoute.name,
              path: 'cross', parent: DashboardRoute.name),
          _i18.RouteConfig(EarnRoute.name,
              path: 'earn', parent: DashboardRoute.name),
          _i18.RouteConfig(SettingRoute.name,
              path: 'setting', parent: DashboardRoute.name)
        ])
      ];
}

/// generated route for [_i1.SplashScreen]
class SplashRoute extends _i18.PageRouteInfo<void> {
  const SplashRoute() : super(name, path: '/splash');

  static const String name = 'SplashRoute';
}

/// generated route for [_i2.OnBoardScreen]
class OnBoardRoute extends _i18.PageRouteInfo<void> {
  const OnBoardRoute() : super(name, path: '/onboard');

  static const String name = 'OnBoardRoute';
}

/// generated route for [_i3.AccessWalletOptionsScreen]
class AccessWalletOptionsRoute extends _i18.PageRouteInfo<void> {
  const AccessWalletOptionsRoute()
      : super(name, path: '/access-wallet-options-screen');

  static const String name = 'AccessWalletOptionsRoute';
}

/// generated route for [_i4.CreateWalletScreen]
class CreateWalletRoute extends _i18.PageRouteInfo<void> {
  const CreateWalletRoute() : super(name, path: '/create-wallet-screen');

  static const String name = 'CreateWalletRoute';
}

/// generated route for [_i5.CreateWalletConfirmScreen]
class CreateWalletConfirmRoute extends _i18.PageRouteInfo<void> {
  const CreateWalletConfirmRoute()
      : super(name, path: '/create-wallet-confirm-screen');

  static const String name = 'CreateWalletConfirmRoute';
}

/// generated route for [_i6.AccessPrivateKeyScreen]
class AccessPrivateKeyRoute extends _i18.PageRouteInfo<void> {
  const AccessPrivateKeyRoute()
      : super(name, path: '/access-private-key-screen');

  static const String name = 'AccessPrivateKeyRoute';
}

/// generated route for [_i7.AccessMnemonicKeyScreen]
class AccessMnemonicKeyRoute extends _i18.PageRouteInfo<void> {
  const AccessMnemonicKeyRoute()
      : super(name, path: '/access-mnemonic-key-screen');

  static const String name = 'AccessMnemonicKeyRoute';
}

/// generated route for [_i8.PinCodeSetupScreen]
class PinCodeSetupRoute extends _i18.PageRouteInfo<void> {
  const PinCodeSetupRoute() : super(name, path: '/pin-code-setup-screen');

  static const String name = 'PinCodeSetupRoute';
}

/// generated route for [_i9.PinCodeConfirmScreen]
class PinCodeConfirmRoute extends _i18.PageRouteInfo<PinCodeConfirmRouteArgs> {
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

/// generated route for [_i10.WalletReceiveScreen]
class WalletReceiveRoute extends _i18.PageRouteInfo<void> {
  const WalletReceiveRoute() : super(name, path: '/wallet-receive-screen');

  static const String name = 'WalletReceiveRoute';
}

/// generated route for [_i11.WalletSendXChainScreen]
class WalletSendXChainRoute extends _i18.PageRouteInfo<void> {
  const WalletSendXChainRoute()
      : super(name, path: '/wallet-send-xchain-screen');

  static const String name = 'WalletSendXChainRoute';
}

/// generated route for [_i12.WalletSendXChainConfirmScreen]
class WalletSendXChainConfirmRoute
    extends _i18.PageRouteInfo<WalletSendXChainConfirmRouteArgs> {
  WalletSendXChainConfirmRoute(
      {_i19.Key? key, required _i12.WalletSendXChainViewData walletViewData})
      : super(name,
            path: '/wallet-send-xchain-confirm-screen',
            args: WalletSendXChainConfirmRouteArgs(
                key: key, walletViewData: walletViewData));

  static const String name = 'WalletSendXChainConfirmRoute';
}

class WalletSendXChainConfirmRouteArgs {
  const WalletSendXChainConfirmRouteArgs(
      {this.key, required this.walletViewData});

  final _i19.Key? key;

  final _i12.WalletSendXChainViewData walletViewData;

  @override
  String toString() {
    return 'WalletSendXChainConfirmRouteArgs{key: $key, walletViewData: $walletViewData}';
  }
}

/// generated route for [_i13.DashboardScreen]
class DashboardRoute extends _i18.PageRouteInfo<void> {
  const DashboardRoute({List<_i18.PageRouteInfo>? children})
      : super(name, path: '/dashboard', initialChildren: children);

  static const String name = 'DashboardRoute';
}

/// generated route for [_i14.WalletScreen]
class WalletRoute extends _i18.PageRouteInfo<void> {
  const WalletRoute() : super(name, path: 'wallet');

  static const String name = 'WalletRoute';
}

/// generated route for [_i15.CrossScreen]
class CrossRoute extends _i18.PageRouteInfo<void> {
  const CrossRoute() : super(name, path: 'cross');

  static const String name = 'CrossRoute';
}

/// generated route for [_i16.EarnScreen]
class EarnRoute extends _i18.PageRouteInfo<void> {
  const EarnRoute() : super(name, path: 'earn');

  static const String name = 'EarnRoute';
}

/// generated route for [_i17.SettingScreen]
class SettingRoute extends _i18.PageRouteInfo<void> {
  const SettingRoute() : super(name, path: 'setting');

  static const String name = 'SettingRoute';
}

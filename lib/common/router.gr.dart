// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i25;
import 'package:flutter/material.dart' as _i26;
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
import 'package:wallet/features/cross/cross.dart' as _i22;
import 'package:wallet/features/cross/transfer/cross_transfer.dart' as _i19;
import 'package:wallet/features/dashboard/dashboard.dart' as _i20;
import 'package:wallet/features/earn/earn.dart' as _i23;
import 'package:wallet/features/onboard/on_board.dart' as _i2;
import 'package:wallet/features/setting/about/setting_about.dart' as _i17;
import 'package:wallet/features/setting/change_pin/setting_change_pin.dart'
    as _i15;
import 'package:wallet/features/setting/general/setting_general.dart' as _i16;
import 'package:wallet/features/setting/security/setting_security.dart' as _i18;
import 'package:wallet/features/setting/setting.dart' as _i24;
import 'package:wallet/features/splash/screen/splash.dart' as _i1;
import 'package:wallet/features/wallet/receive/wallet_receive.dart' as _i10;
import 'package:wallet/features/wallet/send/avm/confirm/wallet_send_avm_confirm.dart'
    as _i12;
import 'package:wallet/features/wallet/send/avm/wallet_send_avm.dart' as _i11;
import 'package:wallet/features/wallet/send/evm/confirm/wallet_send_evm_confirm.dart'
    as _i14;
import 'package:wallet/features/wallet/send/evm/wallet_send_evm.dart' as _i13;
import 'package:wallet/features/wallet/wallet.dart' as _i21;

class AppRouter extends _i25.RootStackRouter {
  AppRouter([_i26.GlobalKey<_i26.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i25.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i1.SplashScreen());
    },
    OnBoardRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i2.OnBoardScreen());
    },
    AccessWalletOptionsRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.AccessWalletOptionsScreen());
    },
    CreateWalletRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.CreateWalletScreen());
    },
    CreateWalletConfirmRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i5.CreateWalletConfirmScreen());
    },
    AccessPrivateKeyRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i6.AccessPrivateKeyScreen());
    },
    AccessMnemonicKeyRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i7.AccessMnemonicKeyScreen());
    },
    PinCodeSetupRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i8.PinCodeSetupScreen());
    },
    PinCodeConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<PinCodeConfirmRouteArgs>();
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: _i9.PinCodeConfirmScreen(pin: args.pin));
    },
    WalletReceiveRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i10.WalletReceiveScreen());
    },
    WalletSendAvmRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i11.WalletSendAvmScreen());
    },
    WalletSendAvmConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendAvmConfirmRouteArgs>();
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i12.WalletSendAvmConfirmScreen(
              key: args.key, transactionInfo: args.transactionInfo));
    },
    WalletSendEvmRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i13.WalletSendEvmScreen());
    },
    WalletSendEvmConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendEvmConfirmRouteArgs>();
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i14.WalletSendEvmConfirmScreen(
              key: args.key, transactionInfo: args.transactionInfo));
    },
    SettingChangePinRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i15.SettingChangePinScreen());
    },
    SettingGeneralRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i16.SettingGeneralScreen());
    },
    SettingAboutRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i17.SettingAboutScreen());
    },
    SettingSecurityRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i18.SettingSecurityScreen());
    },
    CrossTransferRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i19.CrossTransferScreen());
    },
    DashboardRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i20.DashboardScreen());
    },
    WalletRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i21.WalletScreen());
    },
    CrossRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i22.CrossScreen());
    },
    EarnRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i23.EarnScreen());
    },
    SettingRoute.name: (routeData) {
      return _i25.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i24.SettingScreen());
    }
  };

  @override
  List<_i25.RouteConfig> get routes => [
        _i25.RouteConfig('/#redirect',
            path: '/', redirectTo: '/splash', fullMatch: true),
        _i25.RouteConfig(SplashRoute.name, path: '/splash'),
        _i25.RouteConfig(OnBoardRoute.name, path: '/onboard'),
        _i25.RouteConfig(AccessWalletOptionsRoute.name,
            path: '/access-wallet-options-screen'),
        _i25.RouteConfig(CreateWalletRoute.name, path: '/create-wallet-screen'),
        _i25.RouteConfig(CreateWalletConfirmRoute.name,
            path: '/create-wallet-confirm-screen'),
        _i25.RouteConfig(AccessPrivateKeyRoute.name,
            path: '/access-private-key-screen'),
        _i25.RouteConfig(AccessMnemonicKeyRoute.name,
            path: '/access-mnemonic-key-screen'),
        _i25.RouteConfig(PinCodeSetupRoute.name,
            path: '/pin-code-setup-screen'),
        _i25.RouteConfig(PinCodeConfirmRoute.name,
            path: '/pin-code-confirm-screen'),
        _i25.RouteConfig(WalletReceiveRoute.name,
            path: '/wallet-receive-screen'),
        _i25.RouteConfig(WalletSendAvmRoute.name,
            path: '/wallet-send-avm-screen'),
        _i25.RouteConfig(WalletSendAvmConfirmRoute.name,
            path: '/wallet-send-avm-confirm-screen'),
        _i25.RouteConfig(WalletSendEvmRoute.name,
            path: '/wallet-send-evm-screen'),
        _i25.RouteConfig(WalletSendEvmConfirmRoute.name,
            path: '/wallet-send-evm-confirm-screen'),
        _i25.RouteConfig(SettingChangePinRoute.name,
            path: '/setting-change-pin-screen'),
        _i25.RouteConfig(SettingGeneralRoute.name,
            path: '/setting-general-screen'),
        _i25.RouteConfig(SettingAboutRoute.name, path: '/setting-about-screen'),
        _i25.RouteConfig(SettingSecurityRoute.name,
            path: '/setting-security-screen'),
        _i25.RouteConfig(CrossTransferRoute.name,
            path: '/cross-transfer-screen'),
        _i25.RouteConfig(DashboardRoute.name, path: '/dashboard', children: [
          _i25.RouteConfig(WalletRoute.name,
              path: 'wallet', parent: DashboardRoute.name),
          _i25.RouteConfig(CrossRoute.name,
              path: 'cross', parent: DashboardRoute.name),
          _i25.RouteConfig(EarnRoute.name,
              path: 'earn', parent: DashboardRoute.name),
          _i25.RouteConfig(SettingRoute.name,
              path: 'setting', parent: DashboardRoute.name)
        ])
      ];
}

/// generated route for [_i1.SplashScreen]
class SplashRoute extends _i25.PageRouteInfo<void> {
  const SplashRoute() : super(name, path: '/splash');

  static const String name = 'SplashRoute';
}

/// generated route for [_i2.OnBoardScreen]
class OnBoardRoute extends _i25.PageRouteInfo<void> {
  const OnBoardRoute() : super(name, path: '/onboard');

  static const String name = 'OnBoardRoute';
}

/// generated route for [_i3.AccessWalletOptionsScreen]
class AccessWalletOptionsRoute extends _i25.PageRouteInfo<void> {
  const AccessWalletOptionsRoute()
      : super(name, path: '/access-wallet-options-screen');

  static const String name = 'AccessWalletOptionsRoute';
}

/// generated route for [_i4.CreateWalletScreen]
class CreateWalletRoute extends _i25.PageRouteInfo<void> {
  const CreateWalletRoute() : super(name, path: '/create-wallet-screen');

  static const String name = 'CreateWalletRoute';
}

/// generated route for [_i5.CreateWalletConfirmScreen]
class CreateWalletConfirmRoute extends _i25.PageRouteInfo<void> {
  const CreateWalletConfirmRoute()
      : super(name, path: '/create-wallet-confirm-screen');

  static const String name = 'CreateWalletConfirmRoute';
}

/// generated route for [_i6.AccessPrivateKeyScreen]
class AccessPrivateKeyRoute extends _i25.PageRouteInfo<void> {
  const AccessPrivateKeyRoute()
      : super(name, path: '/access-private-key-screen');

  static const String name = 'AccessPrivateKeyRoute';
}

/// generated route for [_i7.AccessMnemonicKeyScreen]
class AccessMnemonicKeyRoute extends _i25.PageRouteInfo<void> {
  const AccessMnemonicKeyRoute()
      : super(name, path: '/access-mnemonic-key-screen');

  static const String name = 'AccessMnemonicKeyRoute';
}

/// generated route for [_i8.PinCodeSetupScreen]
class PinCodeSetupRoute extends _i25.PageRouteInfo<void> {
  const PinCodeSetupRoute() : super(name, path: '/pin-code-setup-screen');

  static const String name = 'PinCodeSetupRoute';
}

/// generated route for [_i9.PinCodeConfirmScreen]
class PinCodeConfirmRoute extends _i25.PageRouteInfo<PinCodeConfirmRouteArgs> {
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
class WalletReceiveRoute extends _i25.PageRouteInfo<void> {
  const WalletReceiveRoute() : super(name, path: '/wallet-receive-screen');

  static const String name = 'WalletReceiveRoute';
}

/// generated route for [_i11.WalletSendAvmScreen]
class WalletSendAvmRoute extends _i25.PageRouteInfo<void> {
  const WalletSendAvmRoute() : super(name, path: '/wallet-send-avm-screen');

  static const String name = 'WalletSendAvmRoute';
}

/// generated route for [_i12.WalletSendAvmConfirmScreen]
class WalletSendAvmConfirmRoute
    extends _i25.PageRouteInfo<WalletSendAvmConfirmRouteArgs> {
  WalletSendAvmConfirmRoute(
      {_i26.Key? key,
      required _i12.WalletSendAvmTransactionViewData transactionInfo})
      : super(name,
            path: '/wallet-send-avm-confirm-screen',
            args: WalletSendAvmConfirmRouteArgs(
                key: key, transactionInfo: transactionInfo));

  static const String name = 'WalletSendAvmConfirmRoute';
}

class WalletSendAvmConfirmRouteArgs {
  const WalletSendAvmConfirmRouteArgs(
      {this.key, required this.transactionInfo});

  final _i26.Key? key;

  final _i12.WalletSendAvmTransactionViewData transactionInfo;

  @override
  String toString() {
    return 'WalletSendAvmConfirmRouteArgs{key: $key, transactionInfo: $transactionInfo}';
  }
}

/// generated route for [_i13.WalletSendEvmScreen]
class WalletSendEvmRoute extends _i25.PageRouteInfo<void> {
  const WalletSendEvmRoute() : super(name, path: '/wallet-send-evm-screen');

  static const String name = 'WalletSendEvmRoute';
}

/// generated route for [_i14.WalletSendEvmConfirmScreen]
class WalletSendEvmConfirmRoute
    extends _i25.PageRouteInfo<WalletSendEvmConfirmRouteArgs> {
  WalletSendEvmConfirmRoute(
      {_i26.Key? key,
      required _i14.WalletSendEvmTransactionViewData transactionInfo})
      : super(name,
            path: '/wallet-send-evm-confirm-screen',
            args: WalletSendEvmConfirmRouteArgs(
                key: key, transactionInfo: transactionInfo));

  static const String name = 'WalletSendEvmConfirmRoute';
}

class WalletSendEvmConfirmRouteArgs {
  const WalletSendEvmConfirmRouteArgs(
      {this.key, required this.transactionInfo});

  final _i26.Key? key;

  final _i14.WalletSendEvmTransactionViewData transactionInfo;

  @override
  String toString() {
    return 'WalletSendEvmConfirmRouteArgs{key: $key, transactionInfo: $transactionInfo}';
  }
}

/// generated route for [_i15.SettingChangePinScreen]
class SettingChangePinRoute extends _i25.PageRouteInfo<void> {
  const SettingChangePinRoute()
      : super(name, path: '/setting-change-pin-screen');

  static const String name = 'SettingChangePinRoute';
}

/// generated route for [_i16.SettingGeneralScreen]
class SettingGeneralRoute extends _i25.PageRouteInfo<void> {
  const SettingGeneralRoute() : super(name, path: '/setting-general-screen');

  static const String name = 'SettingGeneralRoute';
}

/// generated route for [_i17.SettingAboutScreen]
class SettingAboutRoute extends _i25.PageRouteInfo<void> {
  const SettingAboutRoute() : super(name, path: '/setting-about-screen');

  static const String name = 'SettingAboutRoute';
}

/// generated route for [_i18.SettingSecurityScreen]
class SettingSecurityRoute extends _i25.PageRouteInfo<void> {
  const SettingSecurityRoute() : super(name, path: '/setting-security-screen');

  static const String name = 'SettingSecurityRoute';
}

/// generated route for [_i19.CrossTransferScreen]
class CrossTransferRoute extends _i25.PageRouteInfo<void> {
  const CrossTransferRoute() : super(name, path: '/cross-transfer-screen');

  static const String name = 'CrossTransferRoute';
}

/// generated route for [_i20.DashboardScreen]
class DashboardRoute extends _i25.PageRouteInfo<void> {
  const DashboardRoute({List<_i25.PageRouteInfo>? children})
      : super(name, path: '/dashboard', initialChildren: children);

  static const String name = 'DashboardRoute';
}

/// generated route for [_i21.WalletScreen]
class WalletRoute extends _i25.PageRouteInfo<void> {
  const WalletRoute() : super(name, path: 'wallet');

  static const String name = 'WalletRoute';
}

/// generated route for [_i22.CrossScreen]
class CrossRoute extends _i25.PageRouteInfo<void> {
  const CrossRoute() : super(name, path: 'cross');

  static const String name = 'CrossRoute';
}

/// generated route for [_i23.EarnScreen]
class EarnRoute extends _i25.PageRouteInfo<void> {
  const EarnRoute() : super(name, path: 'earn');

  static const String name = 'EarnRoute';
}

/// generated route for [_i24.SettingScreen]
class SettingRoute extends _i25.PageRouteInfo<void> {
  const SettingRoute() : super(name, path: 'setting');

  static const String name = 'SettingRoute';
}

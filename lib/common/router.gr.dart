// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i26;
import 'package:flutter/material.dart' as _i27;
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
import 'package:wallet/features/cross/cross.dart' as _i23;
import 'package:wallet/features/cross/cross_store.dart' as _i28;
import 'package:wallet/features/cross/transfer/cross_transfer.dart' as _i19;
import 'package:wallet/features/dashboard/dashboard.dart' as _i21;
import 'package:wallet/features/earn/earn.dart' as _i24;
import 'package:wallet/features/onboard/on_board.dart' as _i2;
import 'package:wallet/features/qrcode/qr_code.dart' as _i20;
import 'package:wallet/features/setting/about/setting_about.dart' as _i17;
import 'package:wallet/features/setting/change_pin/setting_change_pin.dart'
    as _i15;
import 'package:wallet/features/setting/general/setting_general.dart' as _i16;
import 'package:wallet/features/setting/security/setting_security.dart' as _i18;
import 'package:wallet/features/setting/setting.dart' as _i25;
import 'package:wallet/features/splash/screen/splash.dart' as _i1;
import 'package:wallet/features/wallet/receive/wallet_receive.dart' as _i10;
import 'package:wallet/features/wallet/send/avm/confirm/wallet_send_avm_confirm.dart'
    as _i12;
import 'package:wallet/features/wallet/send/avm/wallet_send_avm.dart' as _i11;
import 'package:wallet/features/wallet/send/evm/confirm/wallet_send_evm_confirm.dart'
    as _i14;
import 'package:wallet/features/wallet/send/evm/wallet_send_evm.dart' as _i13;
import 'package:wallet/features/wallet/wallet.dart' as _i22;

class AppRouter extends _i26.RootStackRouter {
  AppRouter([_i27.GlobalKey<_i27.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i26.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i26.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i1.SplashScreen(),
          transitionsBuilder: _i26.TransitionsBuilders.noTransition,
          opaque: true,
          barrierDismissible: false);
    },
    OnBoardRoute.name: (routeData) {
      return _i26.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i2.OnBoardScreen(),
          transitionsBuilder: _i26.TransitionsBuilders.noTransition,
          opaque: true,
          barrierDismissible: false);
    },
    AccessWalletOptionsRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.AccessWalletOptionsScreen());
    },
    CreateWalletRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i4.CreateWalletScreen());
    },
    CreateWalletConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<CreateWalletConfirmRouteArgs>();
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i5.CreateWalletConfirmScreen(
              key: args.key, mnemonic: args.mnemonic));
    },
    AccessPrivateKeyRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i6.AccessPrivateKeyScreen());
    },
    AccessMnemonicKeyRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i7.AccessMnemonicKeyScreen());
    },
    PinCodeSetupRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i8.PinCodeSetupScreen());
    },
    PinCodeConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<PinCodeConfirmRouteArgs>();
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: _i9.PinCodeConfirmScreen(pin: args.pin));
    },
    WalletReceiveRoute.name: (routeData) {
      final args = routeData.argsAs<WalletReceiveRouteArgs>();
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i10.WalletReceiveScreen(
              key: args.key, walletReceiveInfo: args.walletReceiveInfo));
    },
    WalletSendAvmRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i11.WalletSendAvmScreen());
    },
    WalletSendAvmConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendAvmConfirmRouteArgs>();
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i12.WalletSendAvmConfirmScreen(
              key: args.key, transactionInfo: args.transactionInfo));
    },
    WalletSendEvmRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i13.WalletSendEvmScreen());
    },
    WalletSendEvmConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendEvmConfirmRouteArgs>();
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i14.WalletSendEvmConfirmScreen(
              key: args.key, transactionInfo: args.transactionInfo));
    },
    SettingChangePinRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i15.SettingChangePinScreen());
    },
    SettingGeneralRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i16.SettingGeneralScreen());
    },
    SettingAboutRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i17.SettingAboutScreen());
    },
    SettingSecurityRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i18.SettingSecurityScreen());
    },
    CrossTransferRoute.name: (routeData) {
      final args = routeData.argsAs<CrossTransferRouteArgs>();
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i19.CrossTransferScreen(
              key: args.key, crossStore: args.crossStore));
    },
    QrCodeRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i20.QrCodeScreen());
    },
    DashboardRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i21.DashboardScreen());
    },
    WalletRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i22.WalletScreen());
    },
    CrossRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i23.CrossScreen());
    },
    EarnRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i24.EarnScreen());
    },
    SettingRoute.name: (routeData) {
      return _i26.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i25.SettingScreen());
    }
  };

  @override
  List<_i26.RouteConfig> get routes => [
        _i26.RouteConfig('/#redirect',
            path: '/', redirectTo: '/splash', fullMatch: true),
        _i26.RouteConfig(SplashRoute.name, path: '/splash'),
        _i26.RouteConfig(OnBoardRoute.name, path: '/onboard'),
        _i26.RouteConfig(AccessWalletOptionsRoute.name,
            path: '/access-wallet-options-screen'),
        _i26.RouteConfig(CreateWalletRoute.name, path: '/create-wallet-screen'),
        _i26.RouteConfig(CreateWalletConfirmRoute.name,
            path: '/create-wallet-confirm-screen'),
        _i26.RouteConfig(AccessPrivateKeyRoute.name,
            path: '/access-private-key-screen'),
        _i26.RouteConfig(AccessMnemonicKeyRoute.name,
            path: '/access-mnemonic-key-screen'),
        _i26.RouteConfig(PinCodeSetupRoute.name,
            path: '/pin-code-setup-screen'),
        _i26.RouteConfig(PinCodeConfirmRoute.name,
            path: '/pin-code-confirm-screen'),
        _i26.RouteConfig(WalletReceiveRoute.name,
            path: '/wallet-receive-screen'),
        _i26.RouteConfig(WalletSendAvmRoute.name,
            path: '/wallet-send-avm-screen'),
        _i26.RouteConfig(WalletSendAvmConfirmRoute.name,
            path: '/wallet-send-avm-confirm-screen'),
        _i26.RouteConfig(WalletSendEvmRoute.name,
            path: '/wallet-send-evm-screen'),
        _i26.RouteConfig(WalletSendEvmConfirmRoute.name,
            path: '/wallet-send-evm-confirm-screen'),
        _i26.RouteConfig(SettingChangePinRoute.name,
            path: '/setting-change-pin-screen'),
        _i26.RouteConfig(SettingGeneralRoute.name,
            path: '/setting-general-screen'),
        _i26.RouteConfig(SettingAboutRoute.name, path: '/setting-about-screen'),
        _i26.RouteConfig(SettingSecurityRoute.name,
            path: '/setting-security-screen'),
        _i26.RouteConfig(CrossTransferRoute.name,
            path: '/cross-transfer-screen'),
        _i26.RouteConfig(QrCodeRoute.name, path: '/qr-code-screen'),
        _i26.RouteConfig(DashboardRoute.name, path: '/dashboard', children: [
          _i26.RouteConfig(WalletRoute.name,
              path: 'wallet', parent: DashboardRoute.name),
          _i26.RouteConfig(CrossRoute.name,
              path: 'cross', parent: DashboardRoute.name),
          _i26.RouteConfig(EarnRoute.name,
              path: 'earn', parent: DashboardRoute.name),
          _i26.RouteConfig(SettingRoute.name,
              path: 'setting', parent: DashboardRoute.name)
        ])
      ];
}

/// generated route for [_i1.SplashScreen]
class SplashRoute extends _i26.PageRouteInfo<void> {
  const SplashRoute() : super(name, path: '/splash');

  static const String name = 'SplashRoute';
}

/// generated route for [_i2.OnBoardScreen]
class OnBoardRoute extends _i26.PageRouteInfo<void> {
  const OnBoardRoute() : super(name, path: '/onboard');

  static const String name = 'OnBoardRoute';
}

/// generated route for [_i3.AccessWalletOptionsScreen]
class AccessWalletOptionsRoute extends _i26.PageRouteInfo<void> {
  const AccessWalletOptionsRoute()
      : super(name, path: '/access-wallet-options-screen');

  static const String name = 'AccessWalletOptionsRoute';
}

/// generated route for [_i4.CreateWalletScreen]
class CreateWalletRoute extends _i26.PageRouteInfo<void> {
  const CreateWalletRoute() : super(name, path: '/create-wallet-screen');

  static const String name = 'CreateWalletRoute';
}

/// generated route for [_i5.CreateWalletConfirmScreen]
class CreateWalletConfirmRoute
    extends _i26.PageRouteInfo<CreateWalletConfirmRouteArgs> {
  CreateWalletConfirmRoute({_i27.Key? key, required String mnemonic})
      : super(name,
            path: '/create-wallet-confirm-screen',
            args: CreateWalletConfirmRouteArgs(key: key, mnemonic: mnemonic));

  static const String name = 'CreateWalletConfirmRoute';
}

class CreateWalletConfirmRouteArgs {
  const CreateWalletConfirmRouteArgs({this.key, required this.mnemonic});

  final _i27.Key? key;

  final String mnemonic;

  @override
  String toString() {
    return 'CreateWalletConfirmRouteArgs{key: $key, mnemonic: $mnemonic}';
  }
}

/// generated route for [_i6.AccessPrivateKeyScreen]
class AccessPrivateKeyRoute extends _i26.PageRouteInfo<void> {
  const AccessPrivateKeyRoute()
      : super(name, path: '/access-private-key-screen');

  static const String name = 'AccessPrivateKeyRoute';
}

/// generated route for [_i7.AccessMnemonicKeyScreen]
class AccessMnemonicKeyRoute extends _i26.PageRouteInfo<void> {
  const AccessMnemonicKeyRoute()
      : super(name, path: '/access-mnemonic-key-screen');

  static const String name = 'AccessMnemonicKeyRoute';
}

/// generated route for [_i8.PinCodeSetupScreen]
class PinCodeSetupRoute extends _i26.PageRouteInfo<void> {
  const PinCodeSetupRoute() : super(name, path: '/pin-code-setup-screen');

  static const String name = 'PinCodeSetupRoute';
}

/// generated route for [_i9.PinCodeConfirmScreen]
class PinCodeConfirmRoute extends _i26.PageRouteInfo<PinCodeConfirmRouteArgs> {
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
class WalletReceiveRoute extends _i26.PageRouteInfo<WalletReceiveRouteArgs> {
  WalletReceiveRoute(
      {_i27.Key? key, required _i10.WalletReceiveInfo walletReceiveInfo})
      : super(name,
            path: '/wallet-receive-screen',
            args: WalletReceiveRouteArgs(
                key: key, walletReceiveInfo: walletReceiveInfo));

  static const String name = 'WalletReceiveRoute';
}

class WalletReceiveRouteArgs {
  const WalletReceiveRouteArgs({this.key, required this.walletReceiveInfo});

  final _i27.Key? key;

  final _i10.WalletReceiveInfo walletReceiveInfo;

  @override
  String toString() {
    return 'WalletReceiveRouteArgs{key: $key, walletReceiveInfo: $walletReceiveInfo}';
  }
}

/// generated route for [_i11.WalletSendAvmScreen]
class WalletSendAvmRoute extends _i26.PageRouteInfo<void> {
  const WalletSendAvmRoute() : super(name, path: '/wallet-send-avm-screen');

  static const String name = 'WalletSendAvmRoute';
}

/// generated route for [_i12.WalletSendAvmConfirmScreen]
class WalletSendAvmConfirmRoute
    extends _i26.PageRouteInfo<WalletSendAvmConfirmRouteArgs> {
  WalletSendAvmConfirmRoute(
      {_i27.Key? key,
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

  final _i27.Key? key;

  final _i12.WalletSendAvmTransactionViewData transactionInfo;

  @override
  String toString() {
    return 'WalletSendAvmConfirmRouteArgs{key: $key, transactionInfo: $transactionInfo}';
  }
}

/// generated route for [_i13.WalletSendEvmScreen]
class WalletSendEvmRoute extends _i26.PageRouteInfo<void> {
  const WalletSendEvmRoute() : super(name, path: '/wallet-send-evm-screen');

  static const String name = 'WalletSendEvmRoute';
}

/// generated route for [_i14.WalletSendEvmConfirmScreen]
class WalletSendEvmConfirmRoute
    extends _i26.PageRouteInfo<WalletSendEvmConfirmRouteArgs> {
  WalletSendEvmConfirmRoute(
      {_i27.Key? key,
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

  final _i27.Key? key;

  final _i14.WalletSendEvmTransactionViewData transactionInfo;

  @override
  String toString() {
    return 'WalletSendEvmConfirmRouteArgs{key: $key, transactionInfo: $transactionInfo}';
  }
}

/// generated route for [_i15.SettingChangePinScreen]
class SettingChangePinRoute extends _i26.PageRouteInfo<void> {
  const SettingChangePinRoute()
      : super(name, path: '/setting-change-pin-screen');

  static const String name = 'SettingChangePinRoute';
}

/// generated route for [_i16.SettingGeneralScreen]
class SettingGeneralRoute extends _i26.PageRouteInfo<void> {
  const SettingGeneralRoute() : super(name, path: '/setting-general-screen');

  static const String name = 'SettingGeneralRoute';
}

/// generated route for [_i17.SettingAboutScreen]
class SettingAboutRoute extends _i26.PageRouteInfo<void> {
  const SettingAboutRoute() : super(name, path: '/setting-about-screen');

  static const String name = 'SettingAboutRoute';
}

/// generated route for [_i18.SettingSecurityScreen]
class SettingSecurityRoute extends _i26.PageRouteInfo<void> {
  const SettingSecurityRoute() : super(name, path: '/setting-security-screen');

  static const String name = 'SettingSecurityRoute';
}

/// generated route for [_i19.CrossTransferScreen]
class CrossTransferRoute extends _i26.PageRouteInfo<CrossTransferRouteArgs> {
  CrossTransferRoute({_i27.Key? key, required _i28.CrossStore crossStore})
      : super(name,
            path: '/cross-transfer-screen',
            args: CrossTransferRouteArgs(key: key, crossStore: crossStore));

  static const String name = 'CrossTransferRoute';
}

class CrossTransferRouteArgs {
  const CrossTransferRouteArgs({this.key, required this.crossStore});

  final _i27.Key? key;

  final _i28.CrossStore crossStore;

  @override
  String toString() {
    return 'CrossTransferRouteArgs{key: $key, crossStore: $crossStore}';
  }
}

/// generated route for [_i20.QrCodeScreen]
class QrCodeRoute extends _i26.PageRouteInfo<void> {
  const QrCodeRoute() : super(name, path: '/qr-code-screen');

  static const String name = 'QrCodeRoute';
}

/// generated route for [_i21.DashboardScreen]
class DashboardRoute extends _i26.PageRouteInfo<void> {
  const DashboardRoute({List<_i26.PageRouteInfo>? children})
      : super(name, path: '/dashboard', initialChildren: children);

  static const String name = 'DashboardRoute';
}

/// generated route for [_i22.WalletScreen]
class WalletRoute extends _i26.PageRouteInfo<void> {
  const WalletRoute() : super(name, path: 'wallet');

  static const String name = 'WalletRoute';
}

/// generated route for [_i23.CrossScreen]
class CrossRoute extends _i26.PageRouteInfo<void> {
  const CrossRoute() : super(name, path: 'cross');

  static const String name = 'CrossRoute';
}

/// generated route for [_i24.EarnScreen]
class EarnRoute extends _i26.PageRouteInfo<void> {
  const EarnRoute() : super(name, path: 'earn');

  static const String name = 'EarnRoute';
}

/// generated route for [_i25.SettingScreen]
class SettingRoute extends _i26.PageRouteInfo<void> {
  const SettingRoute() : super(name, path: 'setting');

  static const String name = 'SettingRoute';
}

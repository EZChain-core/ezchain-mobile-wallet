// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i33;
import 'package:flutter/material.dart' as _i34;
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
import 'package:wallet/features/common/chain_type/ezc_type.dart' as _i35;
import 'package:wallet/features/cross/cross.dart' as _i30;
import 'package:wallet/features/cross/transfer/cross_transfer.dart' as _i19;
import 'package:wallet/features/dashboard/dashboard.dart' as _i28;
import 'package:wallet/features/earn/delegate/confirm/earn_delegate_confirm.dart'
    as _i26;
import 'package:wallet/features/earn/delegate/input/earn_delegate_input.dart'
    as _i25;
import 'package:wallet/features/earn/delegate/nodes/earn_delegate_nodes.dart'
    as _i24;
import 'package:wallet/features/earn/earn.dart' as _i31;
import 'package:wallet/features/earn/estimate_rewards/earn_estimate_rewards.dart'
    as _i27;
import 'package:wallet/features/onboard/on_board.dart' as _i2;
import 'package:wallet/features/qrcode/qr_code.dart' as _i20;
import 'package:wallet/features/setting/about/setting_about.dart' as _i17;
import 'package:wallet/features/setting/change_pin/setting_change_pin.dart'
    as _i15;
import 'package:wallet/features/setting/general/setting_general.dart' as _i16;
import 'package:wallet/features/setting/security/setting_security.dart' as _i18;
import 'package:wallet/features/setting/setting.dart' as _i32;
import 'package:wallet/features/splash/screen/splash.dart' as _i1;
import 'package:wallet/features/transaction/detail/transaction_detail.dart'
    as _i22;
import 'package:wallet/features/transaction/detail_c/transaction_c_detail.dart'
    as _i23;
import 'package:wallet/features/transaction/transactions.dart' as _i21;
import 'package:wallet/features/wallet/receive/wallet_receive.dart' as _i10;
import 'package:wallet/features/wallet/send/avm/confirm/wallet_send_avm_confirm.dart'
    as _i12;
import 'package:wallet/features/wallet/send/avm/wallet_send_avm.dart' as _i11;
import 'package:wallet/features/wallet/send/evm/confirm/wallet_send_evm_confirm.dart'
    as _i14;
import 'package:wallet/features/wallet/send/evm/wallet_send_evm.dart' as _i13;
import 'package:wallet/features/wallet/wallet.dart' as _i29;
import 'package:wallet/roi/wallet/explorer/cchain/types.dart' as _i36;

class AppRouter extends _i33.RootStackRouter {
  AppRouter([_i34.GlobalKey<_i34.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i33.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i33.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i1.SplashScreen(),
          transitionsBuilder: _i33.TransitionsBuilders.noTransition,
          opaque: true,
          barrierDismissible: false);
    },
    OnBoardRoute.name: (routeData) {
      return _i33.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i2.OnBoardScreen(),
          transitionsBuilder: _i33.TransitionsBuilders.noTransition,
          opaque: true,
          barrierDismissible: false);
    },
    AccessWalletOptionsRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.AccessWalletOptionsScreen());
    },
    CreateWalletRoute.name: (routeData) {
      final args = routeData.argsAs<CreateWalletRouteArgs>(
          orElse: () => const CreateWalletRouteArgs());
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: _i4.CreateWalletScreen(key: args.key));
    },
    CreateWalletConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<CreateWalletConfirmRouteArgs>();
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i5.CreateWalletConfirmScreen(
              key: args.key,
              mnemonic: args.mnemonic,
              randomIndex: args.randomIndex));
    },
    AccessPrivateKeyRoute.name: (routeData) {
      final args = routeData.argsAs<AccessPrivateKeyRouteArgs>(
          orElse: () => const AccessPrivateKeyRouteArgs());
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i6.AccessPrivateKeyScreen(key: args.key));
    },
    AccessMnemonicKeyRoute.name: (routeData) {
      final args = routeData.argsAs<AccessMnemonicKeyRouteArgs>(
          orElse: () => const AccessMnemonicKeyRouteArgs());
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i7.AccessMnemonicKeyScreen(key: args.key));
    },
    PinCodeSetupRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i8.PinCodeSetupScreen());
    },
    PinCodeConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<PinCodeConfirmRouteArgs>();
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i9.PinCodeConfirmScreen(key: args.key, pin: args.pin));
    },
    WalletReceiveRoute.name: (routeData) {
      final args = routeData.argsAs<WalletReceiveRouteArgs>();
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i10.WalletReceiveScreen(
              key: args.key, walletReceiveInfo: args.walletReceiveInfo));
    },
    WalletSendAvmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendAvmRouteArgs>(
          orElse: () => const WalletSendAvmRouteArgs());
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: _i11.WalletSendAvmScreen(key: args.key));
    },
    WalletSendAvmConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendAvmConfirmRouteArgs>();
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i12.WalletSendAvmConfirmScreen(
              key: args.key, transactionInfo: args.transactionInfo));
    },
    WalletSendEvmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendEvmRouteArgs>(
          orElse: () => const WalletSendEvmRouteArgs());
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: _i13.WalletSendEvmScreen(key: args.key));
    },
    WalletSendEvmConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendEvmConfirmRouteArgs>();
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i14.WalletSendEvmConfirmScreen(
              key: args.key, transactionInfo: args.transactionInfo));
    },
    SettingChangePinRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i15.SettingChangePinScreen());
    },
    SettingGeneralRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i16.SettingGeneralScreen());
    },
    SettingAboutRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i17.SettingAboutScreen());
    },
    SettingSecurityRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i18.SettingSecurityScreen());
    },
    CrossTransferRoute.name: (routeData) {
      final args = routeData.argsAs<CrossTransferRouteArgs>();
      return _i33.AdaptivePage<bool>(
          routeData: routeData,
          child: _i19.CrossTransferScreen(
              key: args.key, crossTransferInfo: args.crossTransferInfo));
    },
    QrCodeRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i20.QrCodeScreen());
    },
    TransactionsRoute.name: (routeData) {
      final args = routeData.argsAs<TransactionsRouteArgs>();
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i21.TransactionsScreen(key: args.key, ezcType: args.ezcType));
    },
    TransactionDetailRoute.name: (routeData) {
      final args = routeData.argsAs<TransactionDetailRouteArgs>();
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i22.TransactionDetailScreen(key: args.key, txId: args.txId));
    },
    TransactionCDetailRoute.name: (routeData) {
      final args = routeData.argsAs<TransactionCDetailRouteArgs>();
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i23.TransactionCDetailScreen(
              key: args.key, cChainExplorerTx: args.cChainExplorerTx));
    },
    EarnDelegateNodesRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i24.EarnDelegateNodesScreen());
    },
    EarnDelegateInputRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i25.EarnDelegateInputScreen());
    },
    EarnDelegateConfirmRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i26.EarnDelegateConfirmScreen());
    },
    EarnEstimateRewardsRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i27.EarnEstimateRewardsScreen());
    },
    DashboardRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i28.DashboardScreen());
    },
    WalletRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i29.WalletScreen());
    },
    CrossRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i30.CrossScreen());
    },
    EarnRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i31.EarnScreen());
    },
    SettingRoute.name: (routeData) {
      return _i33.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i32.SettingScreen());
    }
  };

  @override
  List<_i33.RouteConfig> get routes => [
        _i33.RouteConfig('/#redirect',
            path: '/', redirectTo: '/splash', fullMatch: true),
        _i33.RouteConfig(SplashRoute.name, path: '/splash'),
        _i33.RouteConfig(OnBoardRoute.name, path: '/onboard'),
        _i33.RouteConfig(AccessWalletOptionsRoute.name,
            path: '/access-wallet-options-screen'),
        _i33.RouteConfig(CreateWalletRoute.name, path: '/create-wallet-screen'),
        _i33.RouteConfig(CreateWalletConfirmRoute.name,
            path: '/create-wallet-confirm-screen'),
        _i33.RouteConfig(AccessPrivateKeyRoute.name,
            path: '/access-private-key-screen'),
        _i33.RouteConfig(AccessMnemonicKeyRoute.name,
            path: '/access-mnemonic-key-screen'),
        _i33.RouteConfig(PinCodeSetupRoute.name,
            path: '/pin-code-setup-screen'),
        _i33.RouteConfig(PinCodeConfirmRoute.name,
            path: '/pin-code-confirm-screen'),
        _i33.RouteConfig(WalletReceiveRoute.name,
            path: '/wallet-receive-screen'),
        _i33.RouteConfig(WalletSendAvmRoute.name,
            path: '/wallet-send-avm-screen'),
        _i33.RouteConfig(WalletSendAvmConfirmRoute.name,
            path: '/wallet-send-avm-confirm-screen'),
        _i33.RouteConfig(WalletSendEvmRoute.name,
            path: '/wallet-send-evm-screen'),
        _i33.RouteConfig(WalletSendEvmConfirmRoute.name,
            path: '/wallet-send-evm-confirm-screen'),
        _i33.RouteConfig(SettingChangePinRoute.name,
            path: '/setting-change-pin-screen'),
        _i33.RouteConfig(SettingGeneralRoute.name,
            path: '/setting-general-screen'),
        _i33.RouteConfig(SettingAboutRoute.name, path: '/setting-about-screen'),
        _i33.RouteConfig(SettingSecurityRoute.name,
            path: '/setting-security-screen'),
        _i33.RouteConfig(CrossTransferRoute.name,
            path: '/cross-transfer-screen'),
        _i33.RouteConfig(QrCodeRoute.name, path: '/qr-code-screen'),
        _i33.RouteConfig(TransactionsRoute.name, path: '/transactions-screen'),
        _i33.RouteConfig(TransactionDetailRoute.name,
            path: '/transaction-detail-screen'),
        _i33.RouteConfig(TransactionCDetailRoute.name,
            path: '/transaction-cdetail-screen'),
        _i33.RouteConfig(EarnDelegateNodesRoute.name,
            path: '/earn-delegate-nodes-screen'),
        _i33.RouteConfig(EarnDelegateInputRoute.name,
            path: '/earn-delegate-input-screen'),
        _i33.RouteConfig(EarnDelegateConfirmRoute.name,
            path: '/earn-delegate-confirm-screen'),
        _i33.RouteConfig(EarnEstimateRewardsRoute.name,
            path: '/earn-estimate-rewards-screen'),
        _i33.RouteConfig(DashboardRoute.name, path: '/dashboard', children: [
          _i33.RouteConfig(WalletRoute.name,
              path: 'wallet', parent: DashboardRoute.name),
          _i33.RouteConfig(CrossRoute.name,
              path: 'cross', parent: DashboardRoute.name),
          _i33.RouteConfig(EarnRoute.name,
              path: 'earn', parent: DashboardRoute.name),
          _i33.RouteConfig(SettingRoute.name,
              path: 'setting', parent: DashboardRoute.name)
        ])
      ];
}

/// generated route for [_i1.SplashScreen]
class SplashRoute extends _i33.PageRouteInfo<void> {
  const SplashRoute() : super(name, path: '/splash');

  static const String name = 'SplashRoute';
}

/// generated route for [_i2.OnBoardScreen]
class OnBoardRoute extends _i33.PageRouteInfo<void> {
  const OnBoardRoute() : super(name, path: '/onboard');

  static const String name = 'OnBoardRoute';
}

/// generated route for [_i3.AccessWalletOptionsScreen]
class AccessWalletOptionsRoute extends _i33.PageRouteInfo<void> {
  const AccessWalletOptionsRoute()
      : super(name, path: '/access-wallet-options-screen');

  static const String name = 'AccessWalletOptionsRoute';
}

/// generated route for [_i4.CreateWalletScreen]
class CreateWalletRoute extends _i33.PageRouteInfo<CreateWalletRouteArgs> {
  CreateWalletRoute({_i34.Key? key})
      : super(name,
            path: '/create-wallet-screen',
            args: CreateWalletRouteArgs(key: key));

  static const String name = 'CreateWalletRoute';
}

class CreateWalletRouteArgs {
  const CreateWalletRouteArgs({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return 'CreateWalletRouteArgs{key: $key}';
  }
}

/// generated route for [_i5.CreateWalletConfirmScreen]
class CreateWalletConfirmRoute
    extends _i33.PageRouteInfo<CreateWalletConfirmRouteArgs> {
  CreateWalletConfirmRoute(
      {_i34.Key? key, required String mnemonic, required List<int> randomIndex})
      : super(name,
            path: '/create-wallet-confirm-screen',
            args: CreateWalletConfirmRouteArgs(
                key: key, mnemonic: mnemonic, randomIndex: randomIndex));

  static const String name = 'CreateWalletConfirmRoute';
}

class CreateWalletConfirmRouteArgs {
  const CreateWalletConfirmRouteArgs(
      {this.key, required this.mnemonic, required this.randomIndex});

  final _i34.Key? key;

  final String mnemonic;

  final List<int> randomIndex;

  @override
  String toString() {
    return 'CreateWalletConfirmRouteArgs{key: $key, mnemonic: $mnemonic, randomIndex: $randomIndex}';
  }
}

/// generated route for [_i6.AccessPrivateKeyScreen]
class AccessPrivateKeyRoute
    extends _i33.PageRouteInfo<AccessPrivateKeyRouteArgs> {
  AccessPrivateKeyRoute({_i34.Key? key})
      : super(name,
            path: '/access-private-key-screen',
            args: AccessPrivateKeyRouteArgs(key: key));

  static const String name = 'AccessPrivateKeyRoute';
}

class AccessPrivateKeyRouteArgs {
  const AccessPrivateKeyRouteArgs({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return 'AccessPrivateKeyRouteArgs{key: $key}';
  }
}

/// generated route for [_i7.AccessMnemonicKeyScreen]
class AccessMnemonicKeyRoute
    extends _i33.PageRouteInfo<AccessMnemonicKeyRouteArgs> {
  AccessMnemonicKeyRoute({_i34.Key? key})
      : super(name,
            path: '/access-mnemonic-key-screen',
            args: AccessMnemonicKeyRouteArgs(key: key));

  static const String name = 'AccessMnemonicKeyRoute';
}

class AccessMnemonicKeyRouteArgs {
  const AccessMnemonicKeyRouteArgs({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return 'AccessMnemonicKeyRouteArgs{key: $key}';
  }
}

/// generated route for [_i8.PinCodeSetupScreen]
class PinCodeSetupRoute extends _i33.PageRouteInfo<void> {
  const PinCodeSetupRoute() : super(name, path: '/pin-code-setup-screen');

  static const String name = 'PinCodeSetupRoute';
}

/// generated route for [_i9.PinCodeConfirmScreen]
class PinCodeConfirmRoute extends _i33.PageRouteInfo<PinCodeConfirmRouteArgs> {
  PinCodeConfirmRoute({_i34.Key? key, required String pin})
      : super(name,
            path: '/pin-code-confirm-screen',
            args: PinCodeConfirmRouteArgs(key: key, pin: pin));

  static const String name = 'PinCodeConfirmRoute';
}

class PinCodeConfirmRouteArgs {
  const PinCodeConfirmRouteArgs({this.key, required this.pin});

  final _i34.Key? key;

  final String pin;

  @override
  String toString() {
    return 'PinCodeConfirmRouteArgs{key: $key, pin: $pin}';
  }
}

/// generated route for [_i10.WalletReceiveScreen]
class WalletReceiveRoute extends _i33.PageRouteInfo<WalletReceiveRouteArgs> {
  WalletReceiveRoute(
      {_i34.Key? key, required _i10.WalletReceiveInfo walletReceiveInfo})
      : super(name,
            path: '/wallet-receive-screen',
            args: WalletReceiveRouteArgs(
                key: key, walletReceiveInfo: walletReceiveInfo));

  static const String name = 'WalletReceiveRoute';
}

class WalletReceiveRouteArgs {
  const WalletReceiveRouteArgs({this.key, required this.walletReceiveInfo});

  final _i34.Key? key;

  final _i10.WalletReceiveInfo walletReceiveInfo;

  @override
  String toString() {
    return 'WalletReceiveRouteArgs{key: $key, walletReceiveInfo: $walletReceiveInfo}';
  }
}

/// generated route for [_i11.WalletSendAvmScreen]
class WalletSendAvmRoute extends _i33.PageRouteInfo<WalletSendAvmRouteArgs> {
  WalletSendAvmRoute({_i34.Key? key})
      : super(name,
            path: '/wallet-send-avm-screen',
            args: WalletSendAvmRouteArgs(key: key));

  static const String name = 'WalletSendAvmRoute';
}

class WalletSendAvmRouteArgs {
  const WalletSendAvmRouteArgs({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return 'WalletSendAvmRouteArgs{key: $key}';
  }
}

/// generated route for [_i12.WalletSendAvmConfirmScreen]
class WalletSendAvmConfirmRoute
    extends _i33.PageRouteInfo<WalletSendAvmConfirmRouteArgs> {
  WalletSendAvmConfirmRoute(
      {_i34.Key? key,
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

  final _i34.Key? key;

  final _i12.WalletSendAvmTransactionViewData transactionInfo;

  @override
  String toString() {
    return 'WalletSendAvmConfirmRouteArgs{key: $key, transactionInfo: $transactionInfo}';
  }
}

/// generated route for [_i13.WalletSendEvmScreen]
class WalletSendEvmRoute extends _i33.PageRouteInfo<WalletSendEvmRouteArgs> {
  WalletSendEvmRoute({_i34.Key? key})
      : super(name,
            path: '/wallet-send-evm-screen',
            args: WalletSendEvmRouteArgs(key: key));

  static const String name = 'WalletSendEvmRoute';
}

class WalletSendEvmRouteArgs {
  const WalletSendEvmRouteArgs({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return 'WalletSendEvmRouteArgs{key: $key}';
  }
}

/// generated route for [_i14.WalletSendEvmConfirmScreen]
class WalletSendEvmConfirmRoute
    extends _i33.PageRouteInfo<WalletSendEvmConfirmRouteArgs> {
  WalletSendEvmConfirmRoute(
      {_i34.Key? key,
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

  final _i34.Key? key;

  final _i14.WalletSendEvmTransactionViewData transactionInfo;

  @override
  String toString() {
    return 'WalletSendEvmConfirmRouteArgs{key: $key, transactionInfo: $transactionInfo}';
  }
}

/// generated route for [_i15.SettingChangePinScreen]
class SettingChangePinRoute extends _i33.PageRouteInfo<void> {
  const SettingChangePinRoute()
      : super(name, path: '/setting-change-pin-screen');

  static const String name = 'SettingChangePinRoute';
}

/// generated route for [_i16.SettingGeneralScreen]
class SettingGeneralRoute extends _i33.PageRouteInfo<void> {
  const SettingGeneralRoute() : super(name, path: '/setting-general-screen');

  static const String name = 'SettingGeneralRoute';
}

/// generated route for [_i17.SettingAboutScreen]
class SettingAboutRoute extends _i33.PageRouteInfo<void> {
  const SettingAboutRoute() : super(name, path: '/setting-about-screen');

  static const String name = 'SettingAboutRoute';
}

/// generated route for [_i18.SettingSecurityScreen]
class SettingSecurityRoute extends _i33.PageRouteInfo<void> {
  const SettingSecurityRoute() : super(name, path: '/setting-security-screen');

  static const String name = 'SettingSecurityRoute';
}

/// generated route for [_i19.CrossTransferScreen]
class CrossTransferRoute extends _i33.PageRouteInfo<CrossTransferRouteArgs> {
  CrossTransferRoute(
      {_i34.Key? key, required _i19.CrossTransferInfo crossTransferInfo})
      : super(name,
            path: '/cross-transfer-screen',
            args: CrossTransferRouteArgs(
                key: key, crossTransferInfo: crossTransferInfo));

  static const String name = 'CrossTransferRoute';
}

class CrossTransferRouteArgs {
  const CrossTransferRouteArgs({this.key, required this.crossTransferInfo});

  final _i34.Key? key;

  final _i19.CrossTransferInfo crossTransferInfo;

  @override
  String toString() {
    return 'CrossTransferRouteArgs{key: $key, crossTransferInfo: $crossTransferInfo}';
  }
}

/// generated route for [_i20.QrCodeScreen]
class QrCodeRoute extends _i33.PageRouteInfo<void> {
  const QrCodeRoute() : super(name, path: '/qr-code-screen');

  static const String name = 'QrCodeRoute';
}

/// generated route for [_i21.TransactionsScreen]
class TransactionsRoute extends _i33.PageRouteInfo<TransactionsRouteArgs> {
  TransactionsRoute({_i34.Key? key, required _i35.EZCType ezcType})
      : super(name,
            path: '/transactions-screen',
            args: TransactionsRouteArgs(key: key, ezcType: ezcType));

  static const String name = 'TransactionsRoute';
}

class TransactionsRouteArgs {
  const TransactionsRouteArgs({this.key, required this.ezcType});

  final _i34.Key? key;

  final _i35.EZCType ezcType;

  @override
  String toString() {
    return 'TransactionsRouteArgs{key: $key, ezcType: $ezcType}';
  }
}

/// generated route for [_i22.TransactionDetailScreen]
class TransactionDetailRoute
    extends _i33.PageRouteInfo<TransactionDetailRouteArgs> {
  TransactionDetailRoute({_i34.Key? key, required String txId})
      : super(name,
            path: '/transaction-detail-screen',
            args: TransactionDetailRouteArgs(key: key, txId: txId));

  static const String name = 'TransactionDetailRoute';
}

class TransactionDetailRouteArgs {
  const TransactionDetailRouteArgs({this.key, required this.txId});

  final _i34.Key? key;

  final String txId;

  @override
  String toString() {
    return 'TransactionDetailRouteArgs{key: $key, txId: $txId}';
  }
}

/// generated route for [_i23.TransactionCDetailScreen]
class TransactionCDetailRoute
    extends _i33.PageRouteInfo<TransactionCDetailRouteArgs> {
  TransactionCDetailRoute(
      {_i34.Key? key, required _i36.CChainExplorerTx cChainExplorerTx})
      : super(name,
            path: '/transaction-cdetail-screen',
            args: TransactionCDetailRouteArgs(
                key: key, cChainExplorerTx: cChainExplorerTx));

  static const String name = 'TransactionCDetailRoute';
}

class TransactionCDetailRouteArgs {
  const TransactionCDetailRouteArgs({this.key, required this.cChainExplorerTx});

  final _i34.Key? key;

  final _i36.CChainExplorerTx cChainExplorerTx;

  @override
  String toString() {
    return 'TransactionCDetailRouteArgs{key: $key, cChainExplorerTx: $cChainExplorerTx}';
  }
}

/// generated route for [_i24.EarnDelegateNodesScreen]
class EarnDelegateNodesRoute extends _i33.PageRouteInfo<void> {
  const EarnDelegateNodesRoute()
      : super(name, path: '/earn-delegate-nodes-screen');

  static const String name = 'EarnDelegateNodesRoute';
}

/// generated route for [_i25.EarnDelegateInputScreen]
class EarnDelegateInputRoute extends _i33.PageRouteInfo<void> {
  const EarnDelegateInputRoute()
      : super(name, path: '/earn-delegate-input-screen');

  static const String name = 'EarnDelegateInputRoute';
}

/// generated route for [_i26.EarnDelegateConfirmScreen]
class EarnDelegateConfirmRoute extends _i33.PageRouteInfo<void> {
  const EarnDelegateConfirmRoute()
      : super(name, path: '/earn-delegate-confirm-screen');

  static const String name = 'EarnDelegateConfirmRoute';
}

/// generated route for [_i27.EarnEstimateRewardsScreen]
class EarnEstimateRewardsRoute extends _i33.PageRouteInfo<void> {
  const EarnEstimateRewardsRoute()
      : super(name, path: '/earn-estimate-rewards-screen');

  static const String name = 'EarnEstimateRewardsRoute';
}

/// generated route for [_i28.DashboardScreen]
class DashboardRoute extends _i33.PageRouteInfo<void> {
  const DashboardRoute({List<_i33.PageRouteInfo>? children})
      : super(name, path: '/dashboard', initialChildren: children);

  static const String name = 'DashboardRoute';
}

/// generated route for [_i29.WalletScreen]
class WalletRoute extends _i33.PageRouteInfo<void> {
  const WalletRoute() : super(name, path: 'wallet');

  static const String name = 'WalletRoute';
}

/// generated route for [_i30.CrossScreen]
class CrossRoute extends _i33.PageRouteInfo<void> {
  const CrossRoute() : super(name, path: 'cross');

  static const String name = 'CrossRoute';
}

/// generated route for [_i31.EarnScreen]
class EarnRoute extends _i33.PageRouteInfo<void> {
  const EarnRoute() : super(name, path: 'earn');

  static const String name = 'EarnRoute';
}

/// generated route for [_i32.SettingScreen]
class SettingRoute extends _i33.PageRouteInfo<void> {
  const SettingRoute() : super(name, path: 'setting');

  static const String name = 'SettingRoute';
}

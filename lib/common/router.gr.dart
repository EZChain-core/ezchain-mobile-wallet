// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i41;
import 'package:flutter/material.dart' as _i42;
import 'package:wallet/ezc/wallet/explorer/cchain/types.dart' as _i45;
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
import 'package:wallet/features/auth/pin/verify/pin_code_verify.dart' as _i10;
import 'package:wallet/features/common/chain_type/ezc_type.dart' as _i44;
import 'package:wallet/features/cross/cross.dart' as _i37;
import 'package:wallet/features/cross/transfer/cross_transfer.dart' as _i24;
import 'package:wallet/features/dashboard/dashboard.dart' as _i35;
import 'package:wallet/features/earn/delegate/confirm/earn_delegate_confirm.dart'
    as _i32;
import 'package:wallet/features/earn/delegate/input/earn_delegate_input.dart'
    as _i31;
import 'package:wallet/features/earn/delegate/nodes/earn_delegate_nodes.dart'
    as _i30;
import 'package:wallet/features/earn/earn.dart' as _i38;
import 'package:wallet/features/earn/estimate_rewards/earn_estimate_rewards.dart'
    as _i33;
import 'package:wallet/features/nft/family/create/nft_family_create.dart'
    as _i34;
import 'package:wallet/features/nft/nft.dart' as _i39;
import 'package:wallet/features/onboard/on_board.dart' as _i2;
import 'package:wallet/features/qrcode/qr_code.dart' as _i25;
import 'package:wallet/features/setting/about/setting_about.dart' as _i22;
import 'package:wallet/features/setting/change_pin/setting_change_pin.dart'
    as _i20;
import 'package:wallet/features/setting/general/setting_general.dart' as _i21;
import 'package:wallet/features/setting/security/setting_security.dart' as _i23;
import 'package:wallet/features/setting/setting.dart' as _i40;
import 'package:wallet/features/splash/screen/splash.dart' as _i1;
import 'package:wallet/features/transaction/ant/transactions_ant.dart' as _i27;
import 'package:wallet/features/transaction/detail/transaction_detail.dart'
    as _i28;
import 'package:wallet/features/transaction/detail_c/transaction_c_detail.dart'
    as _i29;
import 'package:wallet/features/transaction/transactions.dart' as _i26;
import 'package:wallet/features/wallet/receive/wallet_receive.dart' as _i11;
import 'package:wallet/features/wallet/send/ant/confirm/wallet_send_ant_confirm.dart'
    as _i15;
import 'package:wallet/features/wallet/send/ant/wallet_send_ant.dart' as _i14;
import 'package:wallet/features/wallet/send/avm/confirm/wallet_send_avm_confirm.dart'
    as _i13;
import 'package:wallet/features/wallet/send/avm/wallet_send_avm.dart' as _i12;
import 'package:wallet/features/wallet/send/evm/confirm/wallet_send_evm_confirm.dart'
    as _i17;
import 'package:wallet/features/wallet/send/evm/wallet_send_evm.dart' as _i16;
import 'package:wallet/features/wallet/token/add/wallet_token_add.dart' as _i18;
import 'package:wallet/features/wallet/token/add_confirm/wallet_token_add_confirm.dart'
    as _i19;
import 'package:wallet/features/wallet/token/wallet_token_item.dart' as _i43;
import 'package:wallet/features/wallet/wallet.dart' as _i36;

class AppRouter extends _i41.RootStackRouter {
  AppRouter([_i42.GlobalKey<_i42.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i41.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i41.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i1.SplashScreen(),
          transitionsBuilder: _i41.TransitionsBuilders.noTransition,
          opaque: true,
          barrierDismissible: false);
    },
    OnBoardRoute.name: (routeData) {
      return _i41.CustomPage<dynamic>(
          routeData: routeData,
          child: const _i2.OnBoardScreen(),
          transitionsBuilder: _i41.TransitionsBuilders.noTransition,
          opaque: true,
          barrierDismissible: false);
    },
    AccessWalletOptionsRoute.name: (routeData) {
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i3.AccessWalletOptionsScreen());
    },
    CreateWalletRoute.name: (routeData) {
      final args = routeData.argsAs<CreateWalletRouteArgs>(
          orElse: () => const CreateWalletRouteArgs());
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData, child: _i4.CreateWalletScreen(key: args.key));
    },
    CreateWalletConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<CreateWalletConfirmRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i5.CreateWalletConfirmScreen(
              key: args.key,
              mnemonic: args.mnemonic,
              randomIndex: args.randomIndex));
    },
    AccessPrivateKeyRoute.name: (routeData) {
      final args = routeData.argsAs<AccessPrivateKeyRouteArgs>(
          orElse: () => const AccessPrivateKeyRouteArgs());
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i6.AccessPrivateKeyScreen(key: args.key));
    },
    AccessMnemonicKeyRoute.name: (routeData) {
      final args = routeData.argsAs<AccessMnemonicKeyRouteArgs>(
          orElse: () => const AccessMnemonicKeyRouteArgs());
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i7.AccessMnemonicKeyScreen(key: args.key));
    },
    PinCodeSetupRoute.name: (routeData) {
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i8.PinCodeSetupScreen());
    },
    PinCodeConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<PinCodeConfirmRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i9.PinCodeConfirmScreen(key: args.key, pin: args.pin));
    },
    PinCodeVerifyRoute.name: (routeData) {
      final args = routeData.argsAs<PinCodeVerifyRouteArgs>(
          orElse: () => const PinCodeVerifyRouteArgs());
      return _i41.AdaptivePage<bool>(
          routeData: routeData, child: _i10.PinCodeVerifyScreen(key: args.key));
    },
    WalletReceiveRoute.name: (routeData) {
      final args = routeData.argsAs<WalletReceiveRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i11.WalletReceiveScreen(key: args.key, args: args.args));
    },
    WalletSendAvmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendAvmRouteArgs>(
          orElse: () => const WalletSendAvmRouteArgs());
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData, child: _i12.WalletSendAvmScreen(key: args.key));
    },
    WalletSendAvmConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendAvmConfirmRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i13.WalletSendAvmConfirmScreen(
              key: args.key, transactionInfo: args.transactionInfo));
    },
    WalletSendAntRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendAntRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i14.WalletSendAntScreen(key: args.key, token: args.token));
    },
    WalletSendAntConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendAntConfirmRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child:
              _i15.WalletSendAntConfirmScreen(key: args.key, args: args.args));
    },
    WalletSendEvmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendEvmRouteArgs>(
          orElse: () => const WalletSendEvmRouteArgs());
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i16.WalletSendEvmScreen(
              key: args.key, fromToken: args.fromToken));
    },
    WalletSendEvmConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletSendEvmConfirmRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i17.WalletSendEvmConfirmScreen(
              key: args.key, transactionInfo: args.transactionInfo));
    },
    WalletTokenAddRoute.name: (routeData) {
      final args = routeData.argsAs<WalletTokenAddRouteArgs>(
          orElse: () => const WalletTokenAddRouteArgs());
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i18.WalletTokenAddScreen(key: args.key));
    },
    WalletTokenAddConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<WalletTokenAddConfirmRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child:
              _i19.WalletTokenAddConfirmScreen(key: args.key, args: args.args));
    },
    SettingChangePinRoute.name: (routeData) {
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i20.SettingChangePinScreen());
    },
    SettingGeneralRoute.name: (routeData) {
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i21.SettingGeneralScreen());
    },
    SettingAboutRoute.name: (routeData) {
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i22.SettingAboutScreen());
    },
    SettingSecurityRoute.name: (routeData) {
      final args = routeData.argsAs<SettingSecurityRouteArgs>(
          orElse: () => const SettingSecurityRouteArgs());
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i23.SettingSecurityScreen(key: args.key));
    },
    CrossTransferRoute.name: (routeData) {
      final args = routeData.argsAs<CrossTransferRouteArgs>();
      return _i41.AdaptivePage<bool>(
          routeData: routeData,
          child: _i24.CrossTransferScreen(
              key: args.key, crossTransferInfo: args.crossTransferInfo));
    },
    QrCodeRoute.name: (routeData) {
      return _i41.AdaptivePage<String>(
          routeData: routeData, child: const _i25.QrCodeScreen());
    },
    TransactionsRoute.name: (routeData) {
      final args = routeData.argsAs<TransactionsRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i26.TransactionsScreen(key: args.key, ezcType: args.ezcType));
    },
    TransactionsAntRoute.name: (routeData) {
      final args = routeData.argsAs<TransactionsAntRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i27.TransactionsAntScreen(key: args.key, token: args.token));
    },
    TransactionDetailRoute.name: (routeData) {
      final args = routeData.argsAs<TransactionDetailRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i28.TransactionDetailScreen(key: args.key, txId: args.txId));
    },
    TransactionCDetailRoute.name: (routeData) {
      final args = routeData.argsAs<TransactionCDetailRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i29.TransactionCDetailScreen(
              key: args.key,
              txHash: args.txHash,
              nonce: args.nonce,
              receiptStatus: args.receiptStatus));
    },
    EarnDelegateNodesRoute.name: (routeData) {
      final args = routeData.argsAs<EarnDelegateNodesRouteArgs>(
          orElse: () => const EarnDelegateNodesRouteArgs());
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i30.EarnDelegateNodesScreen(key: args.key));
    },
    EarnDelegateInputRoute.name: (routeData) {
      final args = routeData.argsAs<EarnDelegateInputRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i31.EarnDelegateInputScreen(key: args.key, args: args.args));
    },
    EarnDelegateConfirmRoute.name: (routeData) {
      final args = routeData.argsAs<EarnDelegateConfirmRouteArgs>();
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child:
              _i32.EarnDelegateConfirmScreen(key: args.key, args: args.args));
    },
    EarnEstimateRewardsRoute.name: (routeData) {
      final args = routeData.argsAs<EarnEstimateRewardsRouteArgs>(
          orElse: () => const EarnEstimateRewardsRouteArgs());
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i33.EarnEstimateRewardsScreen(key: args.key));
    },
    NftFamilyCreateRoute.name: (routeData) {
      final args = routeData.argsAs<NftFamilyCreateRouteArgs>(
          orElse: () => const NftFamilyCreateRouteArgs());
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData,
          child: _i34.NftFamilyCreateScreen(key: args.key));
    },
    DashboardRoute.name: (routeData) {
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i35.DashboardScreen());
    },
    WalletRoute.name: (routeData) {
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i36.WalletScreen());
    },
    CrossRoute.name: (routeData) {
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i37.CrossScreen());
    },
    EarnRoute.name: (routeData) {
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i38.EarnScreen());
    },
    NftRoute.name: (routeData) {
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData, child: const _i39.NftScreen());
    },
    SettingRoute.name: (routeData) {
      final args = routeData.argsAs<SettingRouteArgs>(
          orElse: () => const SettingRouteArgs());
      return _i41.AdaptivePage<dynamic>(
          routeData: routeData, child: _i40.SettingScreen(key: args.key));
    }
  };

  @override
  List<_i41.RouteConfig> get routes => [
        _i41.RouteConfig('/#redirect',
            path: '/', redirectTo: '/splash', fullMatch: true),
        _i41.RouteConfig(SplashRoute.name, path: '/splash'),
        _i41.RouteConfig(OnBoardRoute.name, path: '/onboard'),
        _i41.RouteConfig(AccessWalletOptionsRoute.name,
            path: '/access-wallet-options-screen'),
        _i41.RouteConfig(CreateWalletRoute.name, path: '/create-wallet-screen'),
        _i41.RouteConfig(CreateWalletConfirmRoute.name,
            path: '/create-wallet-confirm-screen'),
        _i41.RouteConfig(AccessPrivateKeyRoute.name,
            path: '/access-private-key-screen'),
        _i41.RouteConfig(AccessMnemonicKeyRoute.name,
            path: '/access-mnemonic-key-screen'),
        _i41.RouteConfig(PinCodeSetupRoute.name,
            path: '/pin-code-setup-screen'),
        _i41.RouteConfig(PinCodeConfirmRoute.name,
            path: '/pin-code-confirm-screen'),
        _i41.RouteConfig(PinCodeVerifyRoute.name,
            path: '/pin-code-verify-screen'),
        _i41.RouteConfig(WalletReceiveRoute.name,
            path: '/wallet-receive-screen'),
        _i41.RouteConfig(WalletSendAvmRoute.name,
            path: '/wallet-send-avm-screen'),
        _i41.RouteConfig(WalletSendAvmConfirmRoute.name,
            path: '/wallet-send-avm-confirm-screen'),
        _i41.RouteConfig(WalletSendAntRoute.name,
            path: '/wallet-send-ant-screen'),
        _i41.RouteConfig(WalletSendAntConfirmRoute.name,
            path: '/wallet-send-ant-confirm-screen'),
        _i41.RouteConfig(WalletSendEvmRoute.name,
            path: '/wallet-send-evm-screen'),
        _i41.RouteConfig(WalletSendEvmRoute.name,
            path: '/wallet-send-evm-screen'),
        _i41.RouteConfig(WalletSendEvmConfirmRoute.name,
            path: '/wallet-send-evm-confirm-screen'),
        _i41.RouteConfig(WalletTokenAddRoute.name,
            path: '/wallet-token-add-screen'),
        _i41.RouteConfig(WalletTokenAddConfirmRoute.name,
            path: '/wallet-token-add-confirm-screen'),
        _i41.RouteConfig(SettingChangePinRoute.name,
            path: '/setting-change-pin-screen'),
        _i41.RouteConfig(SettingGeneralRoute.name,
            path: '/setting-general-screen'),
        _i41.RouteConfig(SettingAboutRoute.name, path: '/setting-about-screen'),
        _i41.RouteConfig(SettingSecurityRoute.name,
            path: '/setting-security-screen'),
        _i41.RouteConfig(CrossTransferRoute.name,
            path: '/cross-transfer-screen'),
        _i41.RouteConfig(QrCodeRoute.name, path: '/qr-code-screen'),
        _i41.RouteConfig(TransactionsRoute.name, path: '/transactions-screen'),
        _i41.RouteConfig(TransactionsAntRoute.name,
            path: '/transactions-ant-screen'),
        _i41.RouteConfig(TransactionDetailRoute.name,
            path: '/transaction-detail-screen'),
        _i41.RouteConfig(TransactionCDetailRoute.name,
            path: '/transaction-cdetail-screen'),
        _i41.RouteConfig(EarnDelegateNodesRoute.name,
            path: '/earn-delegate-nodes-screen'),
        _i41.RouteConfig(EarnDelegateInputRoute.name,
            path: '/earn-delegate-input-screen'),
        _i41.RouteConfig(EarnDelegateConfirmRoute.name,
            path: '/earn-delegate-confirm-screen'),
        _i41.RouteConfig(EarnEstimateRewardsRoute.name,
            path: '/earn-estimate-rewards-screen'),
        _i41.RouteConfig(NftFamilyCreateRoute.name,
            path: '/nft-family-create-screen'),
        _i41.RouteConfig(DashboardRoute.name, path: '/dashboard', children: [
          _i41.RouteConfig(WalletRoute.name,
              path: 'wallet', parent: DashboardRoute.name),
          _i41.RouteConfig(CrossRoute.name,
              path: 'cross', parent: DashboardRoute.name),
          _i41.RouteConfig(EarnRoute.name,
              path: 'earn', parent: DashboardRoute.name),
          _i41.RouteConfig(NftRoute.name,
              path: 'nft', parent: DashboardRoute.name),
          _i41.RouteConfig(SettingRoute.name,
              path: 'setting', parent: DashboardRoute.name)
        ])
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashRoute extends _i41.PageRouteInfo<void> {
  const SplashRoute() : super(SplashRoute.name, path: '/splash');

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.OnBoardScreen]
class OnBoardRoute extends _i41.PageRouteInfo<void> {
  const OnBoardRoute() : super(OnBoardRoute.name, path: '/onboard');

  static const String name = 'OnBoardRoute';
}

/// generated route for
/// [_i3.AccessWalletOptionsScreen]
class AccessWalletOptionsRoute extends _i41.PageRouteInfo<void> {
  const AccessWalletOptionsRoute()
      : super(AccessWalletOptionsRoute.name,
            path: '/access-wallet-options-screen');

  static const String name = 'AccessWalletOptionsRoute';
}

/// generated route for
/// [_i4.CreateWalletScreen]
class CreateWalletRoute extends _i41.PageRouteInfo<CreateWalletRouteArgs> {
  CreateWalletRoute({_i42.Key? key})
      : super(CreateWalletRoute.name,
            path: '/create-wallet-screen',
            args: CreateWalletRouteArgs(key: key));

  static const String name = 'CreateWalletRoute';
}

class CreateWalletRouteArgs {
  const CreateWalletRouteArgs({this.key});

  final _i42.Key? key;

  @override
  String toString() {
    return 'CreateWalletRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.CreateWalletConfirmScreen]
class CreateWalletConfirmRoute
    extends _i41.PageRouteInfo<CreateWalletConfirmRouteArgs> {
  CreateWalletConfirmRoute(
      {_i42.Key? key, required String mnemonic, required List<int> randomIndex})
      : super(CreateWalletConfirmRoute.name,
            path: '/create-wallet-confirm-screen',
            args: CreateWalletConfirmRouteArgs(
                key: key, mnemonic: mnemonic, randomIndex: randomIndex));

  static const String name = 'CreateWalletConfirmRoute';
}

class CreateWalletConfirmRouteArgs {
  const CreateWalletConfirmRouteArgs(
      {this.key, required this.mnemonic, required this.randomIndex});

  final _i42.Key? key;

  final String mnemonic;

  final List<int> randomIndex;

  @override
  String toString() {
    return 'CreateWalletConfirmRouteArgs{key: $key, mnemonic: $mnemonic, randomIndex: $randomIndex}';
  }
}

/// generated route for
/// [_i6.AccessPrivateKeyScreen]
class AccessPrivateKeyRoute
    extends _i41.PageRouteInfo<AccessPrivateKeyRouteArgs> {
  AccessPrivateKeyRoute({_i42.Key? key})
      : super(AccessPrivateKeyRoute.name,
            path: '/access-private-key-screen',
            args: AccessPrivateKeyRouteArgs(key: key));

  static const String name = 'AccessPrivateKeyRoute';
}

class AccessPrivateKeyRouteArgs {
  const AccessPrivateKeyRouteArgs({this.key});

  final _i42.Key? key;

  @override
  String toString() {
    return 'AccessPrivateKeyRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i7.AccessMnemonicKeyScreen]
class AccessMnemonicKeyRoute
    extends _i41.PageRouteInfo<AccessMnemonicKeyRouteArgs> {
  AccessMnemonicKeyRoute({_i42.Key? key})
      : super(AccessMnemonicKeyRoute.name,
            path: '/access-mnemonic-key-screen',
            args: AccessMnemonicKeyRouteArgs(key: key));

  static const String name = 'AccessMnemonicKeyRoute';
}

class AccessMnemonicKeyRouteArgs {
  const AccessMnemonicKeyRouteArgs({this.key});

  final _i42.Key? key;

  @override
  String toString() {
    return 'AccessMnemonicKeyRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i8.PinCodeSetupScreen]
class PinCodeSetupRoute extends _i41.PageRouteInfo<void> {
  const PinCodeSetupRoute()
      : super(PinCodeSetupRoute.name, path: '/pin-code-setup-screen');

  static const String name = 'PinCodeSetupRoute';
}

/// generated route for
/// [_i9.PinCodeConfirmScreen]
class PinCodeConfirmRoute extends _i41.PageRouteInfo<PinCodeConfirmRouteArgs> {
  PinCodeConfirmRoute({_i42.Key? key, required String pin})
      : super(PinCodeConfirmRoute.name,
            path: '/pin-code-confirm-screen',
            args: PinCodeConfirmRouteArgs(key: key, pin: pin));

  static const String name = 'PinCodeConfirmRoute';
}

class PinCodeConfirmRouteArgs {
  const PinCodeConfirmRouteArgs({this.key, required this.pin});

  final _i42.Key? key;

  final String pin;

  @override
  String toString() {
    return 'PinCodeConfirmRouteArgs{key: $key, pin: $pin}';
  }
}

/// generated route for
/// [_i10.PinCodeVerifyScreen]
class PinCodeVerifyRoute extends _i41.PageRouteInfo<PinCodeVerifyRouteArgs> {
  PinCodeVerifyRoute({_i42.Key? key})
      : super(PinCodeVerifyRoute.name,
            path: '/pin-code-verify-screen',
            args: PinCodeVerifyRouteArgs(key: key));

  static const String name = 'PinCodeVerifyRoute';
}

class PinCodeVerifyRouteArgs {
  const PinCodeVerifyRouteArgs({this.key});

  final _i42.Key? key;

  @override
  String toString() {
    return 'PinCodeVerifyRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i11.WalletReceiveScreen]
class WalletReceiveRoute extends _i41.PageRouteInfo<WalletReceiveRouteArgs> {
  WalletReceiveRoute({_i42.Key? key, required _i11.WalletReceiveArgs args})
      : super(WalletReceiveRoute.name,
            path: '/wallet-receive-screen',
            args: WalletReceiveRouteArgs(key: key, args: args));

  static const String name = 'WalletReceiveRoute';
}

class WalletReceiveRouteArgs {
  const WalletReceiveRouteArgs({this.key, required this.args});

  final _i42.Key? key;

  final _i11.WalletReceiveArgs args;

  @override
  String toString() {
    return 'WalletReceiveRouteArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i12.WalletSendAvmScreen]
class WalletSendAvmRoute extends _i41.PageRouteInfo<WalletSendAvmRouteArgs> {
  WalletSendAvmRoute({_i42.Key? key})
      : super(WalletSendAvmRoute.name,
            path: '/wallet-send-avm-screen',
            args: WalletSendAvmRouteArgs(key: key));

  static const String name = 'WalletSendAvmRoute';
}

class WalletSendAvmRouteArgs {
  const WalletSendAvmRouteArgs({this.key});

  final _i42.Key? key;

  @override
  String toString() {
    return 'WalletSendAvmRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i13.WalletSendAvmConfirmScreen]
class WalletSendAvmConfirmRoute
    extends _i41.PageRouteInfo<WalletSendAvmConfirmRouteArgs> {
  WalletSendAvmConfirmRoute(
      {_i42.Key? key,
      required _i13.WalletSendAvmTransactionViewData transactionInfo})
      : super(WalletSendAvmConfirmRoute.name,
            path: '/wallet-send-avm-confirm-screen',
            args: WalletSendAvmConfirmRouteArgs(
                key: key, transactionInfo: transactionInfo));

  static const String name = 'WalletSendAvmConfirmRoute';
}

class WalletSendAvmConfirmRouteArgs {
  const WalletSendAvmConfirmRouteArgs(
      {this.key, required this.transactionInfo});

  final _i42.Key? key;

  final _i13.WalletSendAvmTransactionViewData transactionInfo;

  @override
  String toString() {
    return 'WalletSendAvmConfirmRouteArgs{key: $key, transactionInfo: $transactionInfo}';
  }
}

/// generated route for
/// [_i14.WalletSendAntScreen]
class WalletSendAntRoute extends _i41.PageRouteInfo<WalletSendAntRouteArgs> {
  WalletSendAntRoute({_i42.Key? key, required _i43.WalletTokenItem token})
      : super(WalletSendAntRoute.name,
            path: '/wallet-send-ant-screen',
            args: WalletSendAntRouteArgs(key: key, token: token));

  static const String name = 'WalletSendAntRoute';
}

class WalletSendAntRouteArgs {
  const WalletSendAntRouteArgs({this.key, required this.token});

  final _i42.Key? key;

  final _i43.WalletTokenItem token;

  @override
  String toString() {
    return 'WalletSendAntRouteArgs{key: $key, token: $token}';
  }
}

/// generated route for
/// [_i15.WalletSendAntConfirmScreen]
class WalletSendAntConfirmRoute
    extends _i41.PageRouteInfo<WalletSendAntConfirmRouteArgs> {
  WalletSendAntConfirmRoute(
      {_i42.Key? key, required _i15.WalletSendAntConfirmArgs args})
      : super(WalletSendAntConfirmRoute.name,
            path: '/wallet-send-ant-confirm-screen',
            args: WalletSendAntConfirmRouteArgs(key: key, args: args));

  static const String name = 'WalletSendAntConfirmRoute';
}

class WalletSendAntConfirmRouteArgs {
  const WalletSendAntConfirmRouteArgs({this.key, required this.args});

  final _i42.Key? key;

  final _i15.WalletSendAntConfirmArgs args;

  @override
  String toString() {
    return 'WalletSendAntConfirmRouteArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i16.WalletSendEvmScreen]
class WalletSendEvmRoute extends _i41.PageRouteInfo<WalletSendEvmRouteArgs> {
  WalletSendEvmRoute({_i42.Key? key, _i43.WalletTokenItem? fromToken})
      : super(WalletSendEvmRoute.name,
            path: '/wallet-send-evm-screen',
            args: WalletSendEvmRouteArgs(key: key, fromToken: fromToken));

  static const String name = 'WalletSendEvmRoute';
}

class WalletSendEvmRouteArgs {
  const WalletSendEvmRouteArgs({this.key, this.fromToken});

  final _i42.Key? key;

  final _i43.WalletTokenItem? fromToken;

  @override
  String toString() {
    return 'WalletSendEvmRouteArgs{key: $key, fromToken: $fromToken}';
  }
}

/// generated route for
/// [_i17.WalletSendEvmConfirmScreen]
class WalletSendEvmConfirmRoute
    extends _i41.PageRouteInfo<WalletSendEvmConfirmRouteArgs> {
  WalletSendEvmConfirmRoute(
      {_i42.Key? key,
      required _i17.WalletSendEvmTransactionViewData transactionInfo})
      : super(WalletSendEvmConfirmRoute.name,
            path: '/wallet-send-evm-confirm-screen',
            args: WalletSendEvmConfirmRouteArgs(
                key: key, transactionInfo: transactionInfo));

  static const String name = 'WalletSendEvmConfirmRoute';
}

class WalletSendEvmConfirmRouteArgs {
  const WalletSendEvmConfirmRouteArgs(
      {this.key, required this.transactionInfo});

  final _i42.Key? key;

  final _i17.WalletSendEvmTransactionViewData transactionInfo;

  @override
  String toString() {
    return 'WalletSendEvmConfirmRouteArgs{key: $key, transactionInfo: $transactionInfo}';
  }
}

/// generated route for
/// [_i18.WalletTokenAddScreen]
class WalletTokenAddRoute extends _i41.PageRouteInfo<WalletTokenAddRouteArgs> {
  WalletTokenAddRoute({_i42.Key? key})
      : super(WalletTokenAddRoute.name,
            path: '/wallet-token-add-screen',
            args: WalletTokenAddRouteArgs(key: key));

  static const String name = 'WalletTokenAddRoute';
}

class WalletTokenAddRouteArgs {
  const WalletTokenAddRouteArgs({this.key});

  final _i42.Key? key;

  @override
  String toString() {
    return 'WalletTokenAddRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i19.WalletTokenAddConfirmScreen]
class WalletTokenAddConfirmRoute
    extends _i41.PageRouteInfo<WalletTokenAddConfirmRouteArgs> {
  WalletTokenAddConfirmRoute(
      {_i42.Key? key, required _i19.WalletTokenAddConfirmArgs args})
      : super(WalletTokenAddConfirmRoute.name,
            path: '/wallet-token-add-confirm-screen',
            args: WalletTokenAddConfirmRouteArgs(key: key, args: args));

  static const String name = 'WalletTokenAddConfirmRoute';
}

class WalletTokenAddConfirmRouteArgs {
  const WalletTokenAddConfirmRouteArgs({this.key, required this.args});

  final _i42.Key? key;

  final _i19.WalletTokenAddConfirmArgs args;

  @override
  String toString() {
    return 'WalletTokenAddConfirmRouteArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i20.SettingChangePinScreen]
class SettingChangePinRoute extends _i41.PageRouteInfo<void> {
  const SettingChangePinRoute()
      : super(SettingChangePinRoute.name, path: '/setting-change-pin-screen');

  static const String name = 'SettingChangePinRoute';
}

/// generated route for
/// [_i21.SettingGeneralScreen]
class SettingGeneralRoute extends _i41.PageRouteInfo<void> {
  const SettingGeneralRoute()
      : super(SettingGeneralRoute.name, path: '/setting-general-screen');

  static const String name = 'SettingGeneralRoute';
}

/// generated route for
/// [_i22.SettingAboutScreen]
class SettingAboutRoute extends _i41.PageRouteInfo<void> {
  const SettingAboutRoute()
      : super(SettingAboutRoute.name, path: '/setting-about-screen');

  static const String name = 'SettingAboutRoute';
}

/// generated route for
/// [_i23.SettingSecurityScreen]
class SettingSecurityRoute
    extends _i41.PageRouteInfo<SettingSecurityRouteArgs> {
  SettingSecurityRoute({_i42.Key? key})
      : super(SettingSecurityRoute.name,
            path: '/setting-security-screen',
            args: SettingSecurityRouteArgs(key: key));

  static const String name = 'SettingSecurityRoute';
}

class SettingSecurityRouteArgs {
  const SettingSecurityRouteArgs({this.key});

  final _i42.Key? key;

  @override
  String toString() {
    return 'SettingSecurityRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i24.CrossTransferScreen]
class CrossTransferRoute extends _i41.PageRouteInfo<CrossTransferRouteArgs> {
  CrossTransferRoute(
      {_i42.Key? key, required _i24.CrossTransferInfo crossTransferInfo})
      : super(CrossTransferRoute.name,
            path: '/cross-transfer-screen',
            args: CrossTransferRouteArgs(
                key: key, crossTransferInfo: crossTransferInfo));

  static const String name = 'CrossTransferRoute';
}

class CrossTransferRouteArgs {
  const CrossTransferRouteArgs({this.key, required this.crossTransferInfo});

  final _i42.Key? key;

  final _i24.CrossTransferInfo crossTransferInfo;

  @override
  String toString() {
    return 'CrossTransferRouteArgs{key: $key, crossTransferInfo: $crossTransferInfo}';
  }
}

/// generated route for
/// [_i25.QrCodeScreen]
class QrCodeRoute extends _i41.PageRouteInfo<void> {
  const QrCodeRoute() : super(QrCodeRoute.name, path: '/qr-code-screen');

  static const String name = 'QrCodeRoute';
}

/// generated route for
/// [_i26.TransactionsScreen]
class TransactionsRoute extends _i41.PageRouteInfo<TransactionsRouteArgs> {
  TransactionsRoute({_i42.Key? key, required _i44.EZCType ezcType})
      : super(TransactionsRoute.name,
            path: '/transactions-screen',
            args: TransactionsRouteArgs(key: key, ezcType: ezcType));

  static const String name = 'TransactionsRoute';
}

class TransactionsRouteArgs {
  const TransactionsRouteArgs({this.key, required this.ezcType});

  final _i42.Key? key;

  final _i44.EZCType ezcType;

  @override
  String toString() {
    return 'TransactionsRouteArgs{key: $key, ezcType: $ezcType}';
  }
}

/// generated route for
/// [_i27.TransactionsAntScreen]
class TransactionsAntRoute
    extends _i41.PageRouteInfo<TransactionsAntRouteArgs> {
  TransactionsAntRoute({_i42.Key? key, required _i43.WalletTokenItem token})
      : super(TransactionsAntRoute.name,
            path: '/transactions-ant-screen',
            args: TransactionsAntRouteArgs(key: key, token: token));

  static const String name = 'TransactionsAntRoute';
}

class TransactionsAntRouteArgs {
  const TransactionsAntRouteArgs({this.key, required this.token});

  final _i42.Key? key;

  final _i43.WalletTokenItem token;

  @override
  String toString() {
    return 'TransactionsAntRouteArgs{key: $key, token: $token}';
  }
}

/// generated route for
/// [_i28.TransactionDetailScreen]
class TransactionDetailRoute
    extends _i41.PageRouteInfo<TransactionDetailRouteArgs> {
  TransactionDetailRoute({_i42.Key? key, required String txId})
      : super(TransactionDetailRoute.name,
            path: '/transaction-detail-screen',
            args: TransactionDetailRouteArgs(key: key, txId: txId));

  static const String name = 'TransactionDetailRoute';
}

class TransactionDetailRouteArgs {
  const TransactionDetailRouteArgs({this.key, required this.txId});

  final _i42.Key? key;

  final String txId;

  @override
  String toString() {
    return 'TransactionDetailRouteArgs{key: $key, txId: $txId}';
  }
}

/// generated route for
/// [_i29.TransactionCDetailScreen]
class TransactionCDetailRoute
    extends _i41.PageRouteInfo<TransactionCDetailRouteArgs> {
  TransactionCDetailRoute(
      {_i42.Key? key,
      required String txHash,
      required String nonce,
      _i45.CChainExplorerTxReceiptStatus? receiptStatus})
      : super(TransactionCDetailRoute.name,
            path: '/transaction-cdetail-screen',
            args: TransactionCDetailRouteArgs(
                key: key,
                txHash: txHash,
                nonce: nonce,
                receiptStatus: receiptStatus));

  static const String name = 'TransactionCDetailRoute';
}

class TransactionCDetailRouteArgs {
  const TransactionCDetailRouteArgs(
      {this.key,
      required this.txHash,
      required this.nonce,
      this.receiptStatus});

  final _i42.Key? key;

  final String txHash;

  final String nonce;

  final _i45.CChainExplorerTxReceiptStatus? receiptStatus;

  @override
  String toString() {
    return 'TransactionCDetailRouteArgs{key: $key, txHash: $txHash, nonce: $nonce, receiptStatus: $receiptStatus}';
  }
}

/// generated route for
/// [_i30.EarnDelegateNodesScreen]
class EarnDelegateNodesRoute
    extends _i41.PageRouteInfo<EarnDelegateNodesRouteArgs> {
  EarnDelegateNodesRoute({_i42.Key? key})
      : super(EarnDelegateNodesRoute.name,
            path: '/earn-delegate-nodes-screen',
            args: EarnDelegateNodesRouteArgs(key: key));

  static const String name = 'EarnDelegateNodesRoute';
}

class EarnDelegateNodesRouteArgs {
  const EarnDelegateNodesRouteArgs({this.key});

  final _i42.Key? key;

  @override
  String toString() {
    return 'EarnDelegateNodesRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i31.EarnDelegateInputScreen]
class EarnDelegateInputRoute
    extends _i41.PageRouteInfo<EarnDelegateInputRouteArgs> {
  EarnDelegateInputRoute(
      {_i42.Key? key, required _i31.EarnDelegateInputArgs args})
      : super(EarnDelegateInputRoute.name,
            path: '/earn-delegate-input-screen',
            args: EarnDelegateInputRouteArgs(key: key, args: args));

  static const String name = 'EarnDelegateInputRoute';
}

class EarnDelegateInputRouteArgs {
  const EarnDelegateInputRouteArgs({this.key, required this.args});

  final _i42.Key? key;

  final _i31.EarnDelegateInputArgs args;

  @override
  String toString() {
    return 'EarnDelegateInputRouteArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i32.EarnDelegateConfirmScreen]
class EarnDelegateConfirmRoute
    extends _i41.PageRouteInfo<EarnDelegateConfirmRouteArgs> {
  EarnDelegateConfirmRoute(
      {_i42.Key? key, required _i32.EarnDelegateConfirmArgs args})
      : super(EarnDelegateConfirmRoute.name,
            path: '/earn-delegate-confirm-screen',
            args: EarnDelegateConfirmRouteArgs(key: key, args: args));

  static const String name = 'EarnDelegateConfirmRoute';
}

class EarnDelegateConfirmRouteArgs {
  const EarnDelegateConfirmRouteArgs({this.key, required this.args});

  final _i42.Key? key;

  final _i32.EarnDelegateConfirmArgs args;

  @override
  String toString() {
    return 'EarnDelegateConfirmRouteArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i33.EarnEstimateRewardsScreen]
class EarnEstimateRewardsRoute
    extends _i41.PageRouteInfo<EarnEstimateRewardsRouteArgs> {
  EarnEstimateRewardsRoute({_i42.Key? key})
      : super(EarnEstimateRewardsRoute.name,
            path: '/earn-estimate-rewards-screen',
            args: EarnEstimateRewardsRouteArgs(key: key));

  static const String name = 'EarnEstimateRewardsRoute';
}

class EarnEstimateRewardsRouteArgs {
  const EarnEstimateRewardsRouteArgs({this.key});

  final _i42.Key? key;

  @override
  String toString() {
    return 'EarnEstimateRewardsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i34.NftFamilyCreateScreen]
class NftFamilyCreateRoute
    extends _i41.PageRouteInfo<NftFamilyCreateRouteArgs> {
  NftFamilyCreateRoute({_i42.Key? key})
      : super(NftFamilyCreateRoute.name,
            path: '/nft-family-create-screen',
            args: NftFamilyCreateRouteArgs(key: key));

  static const String name = 'NftFamilyCreateRoute';
}

class NftFamilyCreateRouteArgs {
  const NftFamilyCreateRouteArgs({this.key});

  final _i42.Key? key;

  @override
  String toString() {
    return 'NftFamilyCreateRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i35.DashboardScreen]
class DashboardRoute extends _i41.PageRouteInfo<void> {
  const DashboardRoute({List<_i41.PageRouteInfo>? children})
      : super(DashboardRoute.name,
            path: '/dashboard', initialChildren: children);

  static const String name = 'DashboardRoute';
}

/// generated route for
/// [_i36.WalletScreen]
class WalletRoute extends _i41.PageRouteInfo<void> {
  const WalletRoute() : super(WalletRoute.name, path: 'wallet');

  static const String name = 'WalletRoute';
}

/// generated route for
/// [_i37.CrossScreen]
class CrossRoute extends _i41.PageRouteInfo<void> {
  const CrossRoute() : super(CrossRoute.name, path: 'cross');

  static const String name = 'CrossRoute';
}

/// generated route for
/// [_i38.EarnScreen]
class EarnRoute extends _i41.PageRouteInfo<void> {
  const EarnRoute() : super(EarnRoute.name, path: 'earn');

  static const String name = 'EarnRoute';
}

/// generated route for
/// [_i39.NftScreen]
class NftRoute extends _i41.PageRouteInfo<void> {
  const NftRoute() : super(NftRoute.name, path: 'nft');

  static const String name = 'NftRoute';
}

/// generated route for
/// [_i40.SettingScreen]
class SettingRoute extends _i41.PageRouteInfo<SettingRouteArgs> {
  SettingRoute({_i42.Key? key})
      : super(SettingRoute.name,
            path: 'setting', args: SettingRouteArgs(key: key));

  static const String name = 'SettingRoute';
}

class SettingRouteArgs {
  const SettingRouteArgs({this.key});

  final _i42.Key? key;

  @override
  String toString() {
    return 'SettingRouteArgs{key: $key}';
  }
}

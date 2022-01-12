import 'package:auto_route/auto_route.dart';
import 'package:wallet/features/auth/access/mnemonic/access_mnemonic_key.dart';
import 'package:wallet/features/auth/access/options/access_wallet_options.dart';
import 'package:wallet/features/auth/access/private_key/access_private_key.dart';
import 'package:wallet/features/auth/create/confirm/create_wallet_confirm.dart';
import 'package:wallet/features/auth/create/create_wallet.dart';
import 'package:wallet/features/auth/pin/pin_code_confirm.dart';
import 'package:wallet/features/auth/pin/pin_code_setup.dart';
import 'package:wallet/features/cross/transfer/cross_transfer.dart';
import 'package:wallet/features/dashboard/routes.dart';
import 'package:wallet/features/onboard/on_board.dart';
import 'package:wallet/features/qrcode/qr_code.dart';
import 'package:wallet/features/setting/about/setting_about.dart';
import 'package:wallet/features/setting/change_pin/setting_change_pin.dart';
import 'package:wallet/features/setting/general/setting_general.dart';
import 'package:wallet/features/setting/security/setting_security.dart';
import 'package:wallet/features/splash/screen/splash.dart';
import 'package:wallet/features/wallet/receive/wallet_receive.dart';
import 'package:wallet/features/wallet/send/avm/wallet_send_avm.dart';
import 'package:wallet/features/wallet/send/avm/confirm/wallet_send_avm_confirm.dart';
import 'package:wallet/features/wallet/send/evm/wallet_send_evm.dart';
import 'package:wallet/features/wallet/send/evm/confirm/wallet_send_evm_confirm.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    CustomRoute(path: '/splash', page: SplashScreen, initial: true, transitionsBuilder: TransitionsBuilders.noTransition),
    CustomRoute(path: '/onboard', page: OnBoardScreen, transitionsBuilder: TransitionsBuilders.noTransition),
    AutoRoute(page: AccessWalletOptionsScreen),
    AutoRoute(page: CreateWalletScreen),
    AutoRoute(page: CreateWalletConfirmScreen),
    AutoRoute(page: AccessPrivateKeyScreen),
    AutoRoute(page: AccessMnemonicKeyScreen),
    AutoRoute(page: PinCodeSetupScreen),
    AutoRoute(page: PinCodeConfirmScreen),
    AutoRoute(page: WalletReceiveScreen),
    AutoRoute(page: WalletSendAvmScreen),
    AutoRoute(page: WalletSendAvmConfirmScreen),
    AutoRoute(page: WalletSendEvmScreen),
    AutoRoute(page: WalletSendEvmConfirmScreen),
    AutoRoute(page: SettingChangePinScreen),
    AutoRoute(page: SettingGeneralScreen),
    AutoRoute(page: SettingAboutScreen),
    AutoRoute(page: SettingSecurityScreen),
    AutoRoute<bool>(page: CrossTransferScreen),
    AutoRoute(page: QrCodeScreen),
    dashboardRoutes,
  ],
)
class $AppRouter {}

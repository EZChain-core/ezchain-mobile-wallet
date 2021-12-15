import 'package:auto_route/auto_route.dart';
import 'package:wallet/features/auth/access/mnemonic/access_mnemonic_key.dart';
import 'package:wallet/features/auth/access/options/access_wallet_options.dart';
import 'package:wallet/features/auth/access/private_key/access_private_key.dart';
import 'package:wallet/features/auth/create/confirm/create_wallet_confirm.dart';
import 'package:wallet/features/auth/create/create_wallet.dart';
import 'package:wallet/features/auth/pin/pin_code_confirm.dart';
import 'package:wallet/features/auth/pin/pin_code_setup.dart';
import 'package:wallet/features/dashboard/routes.dart';
import 'package:wallet/features/onboard/on_board.dart';
import 'package:wallet/features/splash/screen/splash.dart';
import 'package:wallet/features/wallet/receive/wallet_receive.dart';
import 'package:wallet/features/wallet/send/c_chain/wallet_send_c_chain.dart';
import 'package:wallet/features/wallet/send/x_chain/wallet_send_x_chain.dart';
import 'package:wallet/features/wallet/send/x_chain/wallet_send_x_chain_confirm.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/splash', page: SplashScreen, initial: true),
    AutoRoute(path: '/onboard', page: OnBoardScreen),
    AutoRoute(page: AccessWalletOptionsScreen),
    AutoRoute(page: CreateWalletScreen),
    AutoRoute(page: CreateWalletConfirmScreen),
    AutoRoute(page: AccessPrivateKeyScreen),
    AutoRoute(page: AccessMnemonicKeyScreen),
    AutoRoute(page: PinCodeSetupScreen),
    AutoRoute(page: PinCodeConfirmScreen),
    AutoRoute(page: WalletReceiveScreen),
    AutoRoute(page: WalletSendXChainScreen),
    AutoRoute(page: WalletSendXChainConfirmScreen),
    AutoRoute(page: WalletSendCChainScreen),
    dashboardRoutes,
  ],
)
class $AppRouter {}

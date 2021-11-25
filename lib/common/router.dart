import 'package:auto_route/auto_route.dart';
import 'package:wallet/features/auth/access/mnemonic/access_mnemonic_key.dart';
import 'package:wallet/features/auth/access/options/access_wallet_options.dart';
import 'package:wallet/features/auth/access/private_key/access_private_key.dart';
import 'package:wallet/features/auth/create/create_wallet.dart';
import 'package:wallet/features/dashboard/routes.dart';
import 'package:wallet/features/onboard/on_board.dart';
import 'package:wallet/features/splash/screen/splash.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/splash', page: SplashScreen, initial: true),
    AutoRoute(path: '/onboard', page: OnBoardScreen),
    AutoRoute(page: AccessWalletOptionsScreen),
    AutoRoute(page: CreateWalletScreen),
    AutoRoute(page: AccessPrivateKeyScreen),
    AutoRoute(page: AccessMnemonicKeyScreen),
    dashboardRoutes,
  ],
)
class $AppRouter {}

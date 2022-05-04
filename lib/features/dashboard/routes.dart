import 'package:auto_route/auto_route.dart';
import 'package:wallet/features/cross/cross.dart';
import 'package:wallet/features/dashboard/dashboard.dart';
import 'package:wallet/features/earn/earn.dart';
import 'package:wallet/features/nft/nft.dart';
import 'package:wallet/features/setting/setting.dart';
import 'package:wallet/features/wallet/wallet.dart';

const dashboardRoutes =
    AutoRoute(path: '/dashboard', page: DashboardScreen, children: [
  AutoRoute(path: 'wallet', page: WalletScreen),
  AutoRoute(path: 'cross', page: CrossScreen),
  AutoRoute(path: 'earn', page: EarnScreen),
  AutoRoute(path: 'nft', page: NftScreen),
  AutoRoute(path: 'setting', page: SettingScreen),
]);

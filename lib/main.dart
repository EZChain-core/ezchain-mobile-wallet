import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:wallet/app.dart';
import 'package:wallet/features/common/connectivity/connectivity.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/features/common/setting/wallet_setting.dart';
import 'package:wallet/features/common/type/network_config_type.dart';
import 'package:wallet/generated/l10n.dart';

Future<void> main() async {
  await configureDependencies();
  try {
    await dotenv.load(fileName: "assets/env/dev.env");
  } catch (e) {
    logger.e(e);
  }
  WidgetsFlutterBinding.ensureInitialized();
  await _setNetworkConfig();
  await Firebase.initializeApp();
  await Strings.load(const Locale("en"));
  runZonedGuarded(() {
    runApp(WalletApp());
    observerConnectivityChanged();
  }, FirebaseCrashlytics.instance.recordError);
}

_setNetworkConfig() async {
  final _walletSetting = getIt<WalletSetting>();
  final networkType = await _walletSetting.getNetworkConfig();
  setRpcNetwork(networkType.config);
}

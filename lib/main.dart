import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'package:wallet/app.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/generated/l10n.dart';

Future<void> main() async {
  await configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Strings.load(const Locale("en"));
  runZonedGuarded(() {
    runApp(WalletApp());
  }, FirebaseCrashlytics.instance.recordError);
}

import 'package:flutter/material.dart';

import 'package:wallet/app.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/generated/l10n.dart';

Future<void> main() async {
  await configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await Strings.load(const Locale("en"));
  runApp(WalletApp());
}

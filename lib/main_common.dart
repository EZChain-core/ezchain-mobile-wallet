import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:wallet/app.dart';
import 'package:wallet/generated/l10n.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  final baseUrl = dotenv.env['BASE_URL'];
  await Strings.load(const Locale("en"));
  runApp(WalletApp());
}

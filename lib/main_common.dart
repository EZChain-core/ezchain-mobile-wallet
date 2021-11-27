import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:wallet/app.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  final baseUrl = dotenv.env['BASE_URL'];
  runApp(WalletApp());
}

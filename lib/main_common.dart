import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:wallet/app.dart';
import 'package:wallet/avalanche/avalanche.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  final baseUrl = dotenv.env['BASE_URL'];
  // final Avalanche avalanche =
  //     AvalancheCore(host: "localhost", port: 9650, networkId: 12345);

  runApp(const WalletApp());
}

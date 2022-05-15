import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/auth/pin/verify/pin_code_verify.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final WalletFactory _walletFactory = getIt<WalletFactory>();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Assets.images.imgSplash.image(fit: BoxFit.cover),
      ),
    );
  }

  _startTimer() {
    return Timer(const Duration(milliseconds: 2000), _navigate);
  }

  _navigate() async {
    final result = await _walletFactory.initWallet();

    if (result) {
      final verify = await verifyPinCode();
      if (verify) {
        context.router.replaceAll([const DashboardRoute()]);
      }
    } else {
      context.router.replaceAll([OnBoardRoute()]);
    }
  }
}

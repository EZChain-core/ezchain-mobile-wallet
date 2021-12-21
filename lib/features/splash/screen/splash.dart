import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    // getBalanceX();

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Assets.images.imgSplash.image(fit: BoxFit.cover),
      ),
    );
  }

  startTimer() {
    return Timer(const Duration(milliseconds: 2000), navigate);
  }

  navigate() {
    context.router.replaceAll([const OnBoardRoute()]);
  }

  getBalanceX() async {
    final wallet = SingletonWallet(
        privateKey:
            "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");
    // "PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb");
    final utxos = await wallet.updateUtxosX();
    final balanceX = wallet.getBalanceX();
    balanceX.forEach((k, v) => print(
        "asset_id = $k, locked = ${v.lockedDecimal}, unlocked = ${v.unlockedDecimal}"));

    // PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb
    // final txId = await wallet.sendAvaxX(
    //     "X-fuji129sdwasyyvdlqqsg8d9pguvzlqvup6cmtd8jad",
    //     bnToDecimalAvaxX(BigInt.from(3333)).toBigInt());
    // // final txId = await wallet.sendAvaxX(
    // //     "X-fuji1vag7ck7uagf3h7y784sa8ujxu5z8ct5hr9d4ud", BigInt.from(100));
    // print("txId = $txId");
  }
}

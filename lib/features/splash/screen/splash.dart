import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/types.dart';
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
    // interactAvaxX();
    // interactAvaxP
    // interactAvaxC();

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

  interactAvaxX() async {
    final wallet = SingletonWallet(
        privateKey:
            "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

    wallet.on(WalletEventType.balanceChangedX, (event, context) {
      final eventName = event.eventName;
      final eventData = event.eventData;
      if (eventName == WalletEventType.balanceChangedX.type &&
          eventData is WalletBalanceX) {
        eventData.forEach((k, v) => print(
            "asset_id = $k, locked = ${v.lockedDecimal}, unlocked = ${v.unlockedDecimal}"));
      }
    });

    // dont delete: to Address of PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb

    try {
      await wallet.updateUtxosX();

      final txId = await wallet.sendAvaxX(
          "X-fuji129sdwasyyvdlqqsg8d9pguvzlqvup6cmtd8jad", numberToBNAvaxX(10));
      print("txId = $txId");
    } catch (e) {
      print(e);
    }
  }

  interactAvaxP() async {

  }

  interactAvaxC() async {
    final wallet = SingletonWallet(
        privateKey:
            "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

    wallet.on(WalletEventType.balanceChangedC, (event, context) {
      final eventName = event.eventName;
      final eventData = event.eventData;
      if (eventName == WalletEventType.balanceChangedC.type &&
          eventData is WalletBalanceC) {
        print("balance C: balance = ${eventData.balance}, balanceDecimal = ${eventData.balanceDecimal}");
      }
    });

    try {
      await wallet.updateAvaxBalanceC();

      final txId =  await  wallet.sendAvaxC("0xd30a9f6645a73f67b7850b9304b6a3172dda75bf", numberToBNAvaxC(11), BigInt.from(31), 21032);
      print("txId = $txId");
    } catch(e){
      print(e);
    }
  }
}

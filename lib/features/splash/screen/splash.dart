import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/roi/wallet/helpers/address_helper.dart';
import 'package:wallet/roi/wallet/helpers/gas_helper.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/types.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';
import 'package:wallet/roi/wallet/utils/price_utils.dart';
import 'package:web3dart/web3dart.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SingletonWallet wallet;

  @override
  void initState() {
    super.initState();
    wallet = SingletonWallet(
        privateKey:
            "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");
    wallet.on(WalletEventType.balanceChangedX, _handleCallback);
    wallet.on(WalletEventType.balanceChangedP, _handleCallback);
    wallet.on(WalletEventType.balanceChangedC, _handleCallback);
    updateX();
    updateP();
    updateC();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
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

  void _handleCallback(Event event, Object? context) async {
    final eventName = event.eventName;
    final eventData = event.eventData;
    if (eventName == WalletEventType.balanceChangedX.type &&
        eventData is WalletBalanceX) {
      final balanceX = eventData[activeNetwork.avaxId];
      if (balanceX != null) {
        print(
            "balanceX: locked = ${balanceX.lockedDecimal}, unlocked = ${balanceX.unlockedDecimal}");
      }
    }
    if (eventName == WalletEventType.balanceChangedP.type &&
        eventData is AssetBalanceP) {
      print(
          "balanceP: locked = ${eventData.lockedDecimal}, unlocked = ${eventData.unlockedDecimal}, lockedStakeable = ${eventData.lockedStakeableDecimal}");
    }
    if (eventName == WalletEventType.balanceChangedC.type &&
        eventData is WalletBalanceC) {
      print(
          "balanceC: balance = ${eventData.balance}, balanceDecimal = ${eventData.balanceDecimal}");
    }
    final avaxBalance = wallet.getAvaxBalance();
    final totalAvaxBalanceDecimal = avaxBalance.totalDecimal;

    final staked = await wallet.getStake();
    final stakedDecimal = bnToDecimalAvaxP(staked.stakedBI);

    final totalDecimal = totalAvaxBalanceDecimal + stakedDecimal;
    final totalString = decimalToLocaleString(totalDecimal);
    print("total ROI = $totalString");

    final avaxPrice = await getAvaxPriceDecimal();
    print("1 ROI = ${decimalToLocaleString(avaxPrice, decimals: 2)}");

    final totalUsd = totalDecimal * avaxPrice;
    final totalUsdString = decimalToLocaleString(totalUsd, decimals: 2);
    print("totalUsd = $totalUsdString");
  }

  /// don't delete: to Address of PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb
  updateX() async {
    try {
      // Lấy balance X
      await wallet.updateUtxosX();
    } catch (e) {
      print(e);
    }
  }

  sendX() async {
    try {
      const to = "X-fuji129sdwasyyvdlqqsg8d9pguvzlqvup6cmtd8jad";

      assert(validateAddressX(to));

      // Gửi AvaxX
      // phải dùng numberToBNAvaxX để convert
      final txId = await wallet.sendAvaxX(to, numberToBNAvaxX(10));
      print("txId = $txId");
    } catch (e) {
      print(e);
    }
  }

  updateP() async {
    try {
      await wallet.updateUtxosP();
    } catch (e) {
      print(e);
    }
  }

  getStakeP() async {
    try {
      final response = await wallet.getStake();
      print("getStakeP = ${bnToAvaxP(response.stakedBI)}");
    } catch (e) {
      print(e);
    }
  }

  updateC() async {
    // Lấy balance C
    try {
      await wallet.updateAvaxBalanceC();
    } catch (e) {
      print(e);
      return;
    }
  }

  sendC() async {
    try {
      // Gửi AvaxC
      // Bước 1 lấy Gas Price (là con số 31 ở web wallet)
      final adjustGasPrice = await getAdjustedGasPrice();
      final gasPrice =
          EtherAmount.fromUnitAndValue(EtherUnit.wei, adjustGasPrice)
              .getValueInUnitBI(EtherUnit.gwei);
      print("gasPrice = $gasPrice");

      const to = "0xd30a9f6645a73f67b7850b9304b6a3172dda75bf";

      assert(validateAddressEvm(to));

      // phải dùng numberToBNAvaxC để convert
      final amount = numberToBNAvaxC(1);

      // Ở web wallet sau khi fill amount và address sẽ chuyển sang confirm
      // Confirm sẽ get Gas Limit
      final gasLimit = await wallet.estimateAvaxGasLimit(to, amount, gasPrice);
      print("gasLimit = $gasLimit");

      // Xác nhận gửi AvaxC
      final txId =
          await wallet.sendAvaxC(to, amount, gasPrice, gasLimit.toInt());
      print("txId = $txId");
    } catch (e) {
      print(e);
    }
  }
}

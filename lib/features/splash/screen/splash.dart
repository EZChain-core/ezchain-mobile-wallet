import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:auto_route/auto_route.dart';
import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/wallet/explorer/ortelius/types.dart';
import 'package:wallet/roi/wallet/helpers/address_helper.dart';
import 'package:wallet/roi/wallet/helpers/gas_helper.dart';
import 'package:wallet/roi/wallet/history/history_helpers.dart';
import 'package:wallet/roi/wallet/network/constants.dart';
import 'package:wallet/roi/wallet/network/helpers/alias_from_network_id.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/network/utils.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/types.dart';
import 'package:wallet/roi/wallet/utils/fee_utils.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';
import 'package:wallet/themes/buttons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SingletonWallet wallet;

  final WalletFactory _walletFactory = getIt<WalletFactory>();

  @override
  void initState() {
    super.initState();
    setRpcNetwork(testNetConfig);
    // wallet = SingletonWallet(
    //     privateKey:
    //         "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");
    // wallet.on(WalletEventType.balanceChangedX, _handleCallback);
    // wallet.on(WalletEventType.balanceChangedP, _handleCallback);
    // wallet.on(WalletEventType.balanceChangedC, _handleCallback);
    // updateX();
    // updateP();
    // updateC();
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
    // return Scaffold(
    //   body: Container(
    //     alignment: Alignment.center,
    //     child: SizedBox(
    //       width: 164,
    //       child: EZCMediumPrimaryButton(
    //         text: "Test",
    //         onPressed: () {
    //           getHistoryTx(
    //               "2XNs8nmfB8HdDeHhf41yTd1KQ5md3PBsnz3mvFevtr3DzBAiib");
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }

  _startTimer() {
    return Timer(const Duration(milliseconds: 2000), _navigate);
  }

  _navigate() async {
    if (await _walletFactory.isExpired()) {
      _walletFactory.clear();
      context.router.replaceAll([const OnBoardRoute()]);
    } else {
      final result = await _walletFactory.initWallet();
      if (result) {
        context.router.replaceAll([const DashboardRoute()]);
      } else {
        context.router.replaceAll([const OnBoardRoute()]);
      }
    }
  }

  void _handleCallback(Event event, Object? context) async {
    final eventName = event.eventName;
    final eventData = event.eventData;
    if (eventName == WalletEventType.balanceChangedX.type &&
        eventData is WalletBalanceX) {
      final balanceX = eventData[getAvaxAssetId()];
      if (balanceX != null) {
        logger.i(
            "balanceX: locked = ${balanceX.lockedDecimal}, unlocked = ${balanceX.unlockedDecimal}");
      }
    }
    if (eventName == WalletEventType.balanceChangedP.type &&
        eventData is AssetBalanceP) {
      logger.i(
          "balanceP: locked = ${eventData.lockedDecimal}, unlocked = ${eventData.unlockedDecimal}, lockedStakeable = ${eventData.lockedStakeableDecimal}");
    }
    if (eventName == WalletEventType.balanceChangedC.type &&
        eventData is WalletBalanceC) {
      logger.i(
          "balanceC: balance = ${eventData.balance}, balanceDecimal = ${eventData.balanceDecimal}");
    }
    // final avaxBalance = wallet.getAvaxBalance();
    // final totalAvaxBalanceDecimal = avaxBalance.totalDecimal;
    //
    // final staked = await wallet.getStake();
    // final stakedDecimal = bnToDecimalAvaxP(staked.stakedBI);
    //
    // final totalDecimal = totalAvaxBalanceDecimal + stakedDecimal;
    // final totalString = decimalToLocaleString(totalDecimal);
    // logger.i("total ROI = $totalString");
    //
    // final avaxPrice = await getAvaxPriceDecimal();
    // logger.i("1 ROI = ${decimalToLocaleString(avaxPrice, decimals: 2)}");
    //
    // final totalUsd = totalDecimal * avaxPrice;
    // final totalUsdString = decimalToLocaleString(totalUsd, decimals: 2);
    // logger.i("totalUsd = $totalUsdString");
  }

  /// don't delete: to Address of PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb
  updateX() async {
    try {
      // Lấy balance X
      await wallet.updateUtxosX();
    } catch (e) {
      logger.e(e);
    }
  }

  sendX() async {
    try {
      const to = "X-fuji129sdwasyyvdlqqsg8d9pguvzlqvup6cmtd8jad";

      assert(validateAddressX(to));
      final fee = getTxFeeX();
      // Gửi AvaxX
      // phải dùng numberToBNAvaxX để convert
      final txId = await wallet.sendAvaxX(to, numberToBNAvaxX(1));
      logger.i("txId = $txId");
    } catch (e) {
      logger.e(e);
    }
  }

  updateP() async {
    try {
      await wallet.updateUtxosP();
    } catch (e) {
      logger.e(e);
    }
  }

  getStakeP() async {
    try {
      final response = await wallet.getStake();
      logger.i("getStakeP = ${bnToAvaxP(response.stakedBI)}");
    } catch (e) {
      logger.e(e);
    }
  }

  updateC() async {
    // Lấy balance C
    try {
      await wallet.updateAvaxBalanceC();
    } catch (e) {
      logger.e(e);
      return;
    }
  }

  sendC() async {
    try {
      // Gửi AvaxC
      // Bước 1 lấy Gas Price (là con số 31 ở web wallet)
      BigInt gasPrice = BigInt.from(225000000000);
      try {
        gasPrice = await getAdjustedGasPrice();
      } catch (e) {
        logger.e(e);
      }
      final gasPriceNumber =
          int.parse(bnToDecimalAvaxX(gasPrice).toStringAsFixed(0));
      logger.i("gasPrice = $gasPriceNumber");

      const to = "0xd30a9f6645a73f67b7850b9304b6a3172dda75bf";

      assert(validateAddressEvm(to));

      // phải dùng numberToBNAvaxC để convert
      final amount = numberToBNAvaxC(1);

      // Ở web wallet sau khi fill amount và address sẽ chuyển sang confirm
      // Confirm sẽ get Gas Limit
      BigInt gasLimit = BigInt.from(21000);
      try {
        gasLimit = await wallet.estimateAvaxGasLimit(to, amount, gasPrice);
      } catch (e) {
        logger.e(e);
      }

      final maxFee = gasPrice * gasLimit;
      final maxFeeText = bnToAvaxC(maxFee);
      logger.i("maxFee = $maxFeeText");

      // Xác nhận gửi AvaxC
      final txId = await wallet.sendAvaxC(
        to,
        amount,
        gasPrice,
        gasLimit.toInt(),
      );
      logger.i("txId = $txId");
    } catch (e) {
      logger.e(e);
    }
  }

  exportXToImportP() async {
    final exportFee = getTxFeeX();
    final importFee = getTxFeeP();
    // amount phải thêm import fee
    // export fee ở đây chỉ để hiển thị vì đã được tự động thêm vào transaction
    final amount = numberToBNAvaxX(1) + importFee;
    String exportTxId = "";
    try {
      exportTxId = await wallet.exportXChain(amount, ExportChainsX.P);
      logger.i("exportTxId = $exportTxId");
    } catch (e) {
      logger.e(e);
    }
    if (exportTxId.isEmpty) return;
    String importTxId = "";

    try {
      importTxId = await wallet.importPChain(ExportChainsP.X);
      logger.i("importTxId = $importTxId");
    } catch (e) {
      logger.e(e);
    }
  }

  exportXToImportC() async {
    final exportFee = getTxFeeX();
    final importFee = await estimateImportGasFee();
    // amount phải thêm import fee
    // export fee ở đây chỉ để hiển thị vì đã được tự động thêm vào transaction
    final amount = numberToBNAvaxX(1) + importFee;

    String exportTxId = "";
    try {
      exportTxId = await wallet.exportXChain(amount, ExportChainsX.C);
      logger.i("exportTxId = $exportTxId");
    } catch (e) {
      logger.e(e);
    }
    if (exportTxId.isEmpty) return;
    String importTxId = "";
    try {
      importTxId = await wallet.importCChain(ExportChainsC.X);
      logger.i("importTxId = $importTxId");
    } catch (e) {
      logger.e(e);
    }
  }

  exportPToImportX() async {
    final exportFee = getTxFeeP();
    final importFee = getTxFeeX();
    // amount phải thêm import fee
    // export fee ở đây chỉ để hiển thị vì đã được tự động thêm vào transaction
    final amount = numberToBNAvaxP(1) + importFee;

    String exportTxId = "";
    try {
      exportTxId = await wallet.exportPChain(amount, ExportChainsP.X);
      logger.i("exportTxId = $exportTxId");
    } catch (e) {
      logger.e(e);
    }
    if (exportTxId.isEmpty) return;
    String importTxId = "";
    try {
      importTxId = await wallet.importXChain(ExportChainsX.P);
      logger.i("importTxId = $importTxId");
    } catch (e) {
      logger.e(e);
    }
  }

  exportPToImportC() async {
    final exportFee = getTxFeeP();
    final importFee = await estimateImportGasFee();
    // amount phải thêm import fee
    // export fee ở đây chỉ để hiển thị vì đã được tự động thêm vào transaction
    final amount = numberToBNAvaxP(1) + importFee;

    String exportTxId = "";
    try {
      exportTxId = await wallet.exportPChain(amount, ExportChainsP.C);
      logger.i("exportTxId = $exportTxId");
    } catch (e) {
      logger.e(e);
    }
    if (exportTxId.isEmpty) return;
    String importTxId = "";
    try {
      importTxId = await wallet.importCChain(ExportChainsC.P);
      logger.i("importTxId = $importTxId");
    } catch (e) {
      logger.e(e);
    }
  }

  exportCToImportX() async {
    String exportTxId = "";
    try {
      final hexAddress = wallet.getAddressC();
      const destinationChain = ExportChainsC.X;
      final destinationAddress = wallet.getAddressX();
      // estimate ban đầu amount = 0
      // khi ấn confirm cần estimate lại với amount được nhập
      final exportFee = await estimateExportGasFee(
        destinationChain,
        BigInt.zero,
        hexAddress,
        destinationAddress,
      );
      final importFee = getTxFeeX();
      // amount phải thêm import fee
      final amount = numberToBNAvaxX(1) + importFee;
      exportTxId = await wallet.exportCChain(
        amount,
        destinationChain,
        exportFee: exportFee,
      );
      logger.i("exportTxId = $exportTxId");
    } catch (e) {
      logger.e(e);
    }
    if (exportTxId.isEmpty) return;
    String importTxId = "";
    try {
      importTxId = await wallet.importXChain(ExportChainsX.C);
      logger.i("importTxId = $importTxId");
    } catch (e) {
      logger.e(e);
    }
  }

  exportCToImportP() async {
    String exportTxId = "";
    try {
      final hexAddress = wallet.getAddressC();
      const destinationChain = ExportChainsC.P;
      final destinationAddress = wallet.getAddressP();
      // estimate ban đầu amount = 0
      // khi ấn confirm cần estimate lại với amount được nhập
      final exportFee = await estimateExportGasFee(
        destinationChain,
        BigInt.zero,
        hexAddress,
        destinationAddress,
      );
      final importFee = getTxFeeP();
      // amount phải thêm import fee
      final amount = numberToBNAvaxP(1) + importFee;
      exportTxId = await wallet.exportCChain(
        amount,
        destinationChain,
        exportFee: exportFee,
      );
      logger.i("exportTxId = $exportTxId");
    } catch (e) {
      logger.e(e);
    }
    if (exportTxId.isEmpty) return;
    String importTxId = "";
    try {
      importTxId = await wallet.importPChain(ExportChainsP.C);
      logger.i("importTxId = $importTxId");
    } catch (e) {
      logger.e(e);
    }
  }

  getHistoryX() async {
    try {
      final transactions = await wallet.getTransactionsX(limit: 20);
      logger.i("getHistoryX = ${transactions.length}");
    } catch (e) {
      logger.e(e);
    }
  }

  getHistoryP() async {
    try {
      final transactions = await wallet.getTransactionsP(limit: 20);
      logger.i("getHistoryP = ${transactions.length}");
    } catch (e) {
      logger.e(e);
    }
  }

  getHistoryC() async {
    try {
      final transactions = await wallet.getTransactionsC(limit: 20);
      logger.i("getHistoryC = ${transactions.length}");
    } catch (e) {
      logger.e(e);
    }
  }

  getHistoryTx(String txId) async {
    try {
      final transaction = await wallet.getTransaction(txId);

      var message = "Transaction Id: ${transaction.id}\n";

      final timestamp = transaction.timestamp;
      if (timestamp != null && timestamp.isNotEmpty) {
        final inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        final inputDate = inputFormat.parse(timestamp, true).toLocal();

        var outputFormat = DateFormat('dd/MM/yyyy, hh:mm:ss');
        var outputDate = outputFormat.format(inputDate);
        message += "Accepted: $outputDate\n";
      }

      final value = transaction.outputTotals.values.fold<BigInt>(
          BigInt.zero,
          (previousValue, element) =>
              previousValue + (BigInt.tryParse(element) ?? BigInt.zero));

      if (value != BigInt.zero) {
        message += "Value: ${bnToLocaleString(value)}\n";
      }

      message +=
          "Burned: ${bnToDecimalAvaxX(BigInt.tryParse(transaction.txFee.toString()) ?? BigInt.zero)}\n";

      message += "Blockchain: ${idToChainAlias(transaction.chainId)}\n";

      final blockId = transaction.txBlockId;
      if (blockId != null && blockId.isNotEmpty) {
        message += "          block = $blockId\n";
      }

      final validatorNodeId = transaction.validatorNodeId;

      if (validatorNodeId.isNotEmpty) {
        message += "Staking: validator = $validatorNodeId\n";
      }

      final validatorStart = transaction.validatorStart * 1000;
      final validatorEnd = transaction.validatorEnd * 1000;

      if (validatorStart != 0 && validatorEnd != 0) {
        final validatorStartDate =
            DateTime.fromMillisecondsSinceEpoch(validatorStart);
        final validatorEndDate =
            DateTime.fromMillisecondsSinceEpoch(validatorEnd);
        final dateFormatter = DateFormat("dd/MM/yyyy");

        final sub = validatorEnd - validatorStart;
        const numOfMillisPerDay = 24 * 60 * 60 * 1000;
        final totalDays = sub / numOfMillisPerDay;
        final validatorUntilNow =
            DateTime.now().millisecondsSinceEpoch - validatorStart;
        final elapsedDay = validatorUntilNow / numOfMillisPerDay;
        final elapsedPercent = (elapsedDay / totalDays) * 100;
        message +=
            "         duration = ${totalDays.toStringAsFixed(0)} days (${elapsedPercent.toStringAsFixed(0)}% elapsed)\n";
        message +=
            "         start = ${dateFormatter.format(validatorStartDate)}, end = ${dateFormatter.format(validatorEndDate)}\n";
      }

      final memo = transaction.memo;
      if (memo != null && memo.isNotEmpty) {
        try {
          message +=
              "Memo: hex = ${hexEncode(base64.decode(memo))}, utf8 = ${parseMemo(memo)}";
        } catch (e) {
          logger.e(e);
        }
      }

      message += "\n\n";

      var prefixInput = "";
      if (transaction.type == OrteliusTxType.import) {
        prefixInput = "Exported ";
      }

      var prefixOutput = "";
      if (transaction.type == OrteliusTxType.export) {
        prefixOutput = "Exported ";
      }

      final ins = transaction.inputs ?? [];
      message += "${prefixInput}Input: ${ins.length}\n";
      for (var i = 0; i < ins.length; i++) {
        final input = ins[i];
        final signatures = input.credentials?.map((e) => e.signature);
        final output = input.output;
        final amount =
            bnToLocaleString(BigInt.tryParse(output.amount) ?? BigInt.zero);
        final addresses = output.addresses;
        message +=
            "#$i: amount = $amount, from = $addresses, signature = $signatures\n";
      }

      final outs = transaction.outputs ?? [];
      message += "\n${prefixOutput}Output: ${outs.length}\n";
      for (var i = 0; i < outs.length; i++) {
        final output = outs[i];
        final amount =
            bnToLocaleString(BigInt.tryParse(output.amount) ?? BigInt.zero);
        final addresses = output.addresses;
        message += "#$i: amount = $amount, to = $addresses\n";
        final stakeLockTime = output.stakeLockTime;
        if (stakeLockTime != null && stakeLockTime != 0) {
          final stakeLockTimeDate =
              DateTime.fromMillisecondsSinceEpoch(stakeLockTime * 1000);
          final dateFormatter = DateFormat("MM/dd/yyyy, HH:mm:ss a");
          message +=
              "Output can be spent in a year (${dateFormatter.format(stakeLockTimeDate)})";
        }
      }
      logger.i(message);
    } catch (e) {
      logger.e(e);
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import 'package:auto_route/auto_route.dart';
import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/roi/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/roi/sdk/utils/bigint.dart';
import 'package:wallet/roi/sdk/utils/bintools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/wallet/explorer/cchain/types.dart';
import 'package:wallet/roi/wallet/explorer/ortelius/types.dart';
import 'package:wallet/roi/wallet/helpers/address_helper.dart';
import 'package:wallet/roi/wallet/helpers/gas_helper.dart';
import 'package:wallet/roi/wallet/history/history_helpers.dart';
import 'package:wallet/roi/wallet/history/types.dart';
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
    setRpcNetwork(testnetConfig);
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
    //           delegate();
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
      logger.i("getStakeP = ${bnToAvaxP(response.stakedBN)}");
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
          int.tryParse(bnToDecimalAvaxX(gasPrice).toStringAsFixed(0)) ?? 0;
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

  getXTransactions() async {
    try {
      final transactions = await wallet.getXTransactions(limit: 20);
      final histories = await Future.wait(
          transactions.map((tx) => wallet.parseOrteliusTx(tx)));
      _parseXPTransactions("X", histories);
    } catch (e) {
      logger.e(e);
    }
  }

  getPTransactions() async {
    try {
      // chỉ P Chain mới cần get validators.
      final validators = await wallet.getPlatformValidators();
      final transactions = await wallet.getPTransactions(limit: 20);
      final histories = await Future.wait(
          transactions.map((tx) => wallet.parseOrteliusTx(tx)));
      _parseXPTransactions("P", histories, validators: validators);
    } catch (e) {
      logger.e(e);
    }
  }

  getXPTransaction(String txId) async {
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

  getCTransactions() async {
    try {
      final transactions = await wallet.getCChainTransactions();
      for (var tx in transactions) {
        final value = bnToAvaxC(BigInt.tryParse(tx.value) ?? BigInt.zero);
        final gasPrice = BigInt.tryParse(tx.gasPrice) ?? BigInt.zero;
        final gasUsed = BigInt.tryParse(tx.gasUsed) ?? BigInt.zero;
        final fee = bnToAvaxC(gasPrice * gasUsed);

        final message =
            "txID = ${tx.hash}\nFrom -> To = ${tx.from} -> ${tx.to}\nBlock = #${tx.blockNumber}, Amount = $value EZC, Fee = $fee EZC";
        logger.i(message);
      }
    } catch (e) {
      logger.e(e);
    }
  }

  getCTransaction(
    String txHash,
    String nonce,
    CChainExplorerTxReceiptStatus receiptStatus,
  ) async {
    try {
      final tx = await wallet.getCChainTransaction(txHash);
      final value = bnToAvaxC(BigInt.tryParse(tx.value) ?? BigInt.zero);
      final gasPrice = BigInt.tryParse(tx.gasPrice) ?? BigInt.zero;
      final gasUsed = BigInt.tryParse(tx.gasUsed) ?? BigInt.zero;
      final fee = bnToAvaxC(gasPrice * gasUsed);
      final message = "Transaction Hash = ${tx.hash}\n"
          "Result = ${tx.success ? "Success" : "Fail"}\n"
          "Status = ${receiptStatus == CChainExplorerTxReceiptStatus.ok ? "Confirmed" : "Not Confirmed"}, Confirmed by ${tx.confirmations}\n"
          "Block = ${tx.blockNumber}\n"
          "From = ${tx.from}\n"
          "To = ${tx.to}\n"
          "Amount = $value EZC\n"
          "Transaction Fee = $fee EZC\n"
          "Gas Price = ${bnToAvaxX(gasPrice)} wEZC\n"
          "Gas Limit = ${tx.gasLimit}\n"
          "Gas Used by Transaction = ${tx.gasUsed} | ${(int.parse(tx.gasUsed) ~/ int.parse(tx.gasLimit)) * 100}%\n"
          "Nonce = $nonce";
      logger.i(message);
    } catch (e) {
      logger.e(e);
    }
  }

  _parseXPTransactions(
    String chainAlias,
    List<HistoryItem> items, {
    List<Validator>? validators, // for only platform chain
  }) {
    final result = items.where((tx) {
      if (tx is HistoryBaseTx) {
        return tx.tokens.isNotEmpty;
      } else if (tx is HistoryStaking) {
        return tx.type == HistoryItemTypeName.addValidator ||
            tx.type == HistoryItemTypeName.addDelegator;
      } else {
        return tx.type != HistoryItemTypeName.notSupported;
      }
    }).toList();
    for (var item in result) {
      if (item is HistoryBaseTx) {
        final token = item.tokens.firstWhereOrNull(
            (token) => token.asset.assetId == getAvaxAssetId());
        if (token == null || token.amount == BigInt.zero) {
          continue;
        }
        var message = "Date = ${item.timestamp}\n";
        if (token.amount < BigInt.zero) {
          final amount = bnToLocaleString(
            token.amount - item.fee,
            decimals: int.tryParse(token.asset.denomination) ?? 0,
          );
          message += "Send = $amount ${token.asset.symbol}, to = ";
        } else {
          message +=
              "Receive = ${token.amountDisplayValue} ${token.asset.symbol}, from = ";
        }
        message += "$chainAlias-${token.addresses.firstOrNull ?? ""}";
        logger.i(message);
      } else if (item is HistoryImportExport) {
        if (item.amount > BigInt.zero) {
          var message = "Date = ${item.timestamp}\n";
          if (item.type == HistoryItemTypeName.import) {
            message +=
                "Import(${item.destination}) = ${item.amountDisplayValue} EZC";
          } else if (item.type == HistoryItemTypeName.export) {
            final amount =
                bnToAvaxX((item.amount + item.fee) * BigInt.from(-1));
            message += "Export(${item.source}) = $amount EZC";
          }
          logger.i(message);
        }
      } else if (item is HistoryStaking && validators != null) {
        var message = "Date = ${item.timestamp}\n";

        final stakeEndDate = DateTime.fromMillisecondsSinceEpoch(item.stakeEnd);
        final dateFormatter = DateFormat("MM/dd/yyyy, HH:mm:ss a");
        message += "Stake End Date = ${dateFormatter.format(stakeEndDate)}\n";
        String? potentialReward;
        final validator = validators.firstWhereOrNull((validator) {
          final nodeId = validator.nodeId.split("-")[1];
          return nodeId == item.nodeId;
        });
        if (validator != null) {
          if (item.type == HistoryItemTypeName.addValidator) {
            potentialReward = validator.potentialReward;
            message += "Add Validator = ${item.amountDisplayValue}\n";
          } else {
            final delegators = validator.delegators;
            if (delegators != null) {
              final delegator = delegators
                  .firstWhere((delegator) => delegator.txId == item.id);
              potentialReward = delegator.potentialReward;
              message += "Add Delegator = ${item.amountDisplayValue}\n";
            }
          }
          if (potentialReward != null) {
            final reward =
                bnToAvaxP(BigInt.tryParse(potentialReward) ?? BigInt.zero);
            message += "Reward Pending = $reward";
          } else {
            message += "Reward Pending = ?";
          }
        }
        logger.i(message);
      }
    }
  }

  getNodeIds() async {
    try {
      // tạo ra 1 shared store để share validators với case getPTransactions
      final validators = await wallet.getPlatformValidators();
      validators.sort((a, b) {
        final amtA = a.stakeAmountBN;
        final amtB = b.stakeAmountBN;

        if (amtA > amtB) {
          return -1;
        } else if (amtA < amtB) {
          return 1;
        } else {
          return 0;
        }
      });
      final pendingValidators = await wallet.getPlatformPendingValidators();
      final pendingDelegators = pendingValidators.delegators;
      final minStake = await wallet.getMinStake();
      final minStakeDelegation = minStake.minDelegatorStakeBN;
      for (var validator in validators) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final endTime = (int.tryParse(validator.endTime) ?? 0) * 1000;
        final diff = endTime - now;

        const MINUTE_MS = 60000;
        const HOUR_MS = MINUTE_MS * 60;
        const DAY_MS = HOUR_MS * 24;

        /// If End time is less than 2 weeks + 1 hour, remove from list they are no use
        if (diff <= ((14 * DAY_MS) + (10 * MINUTE_MS))) {
          continue;
        }

        final validatorStakeAmountBN = validator.stakeAmountBN;
        final stakeAmountDecimal = bnToDecimalAvaxP(validatorStakeAmountBN);
        final stakeAmount =
            decimalToLocaleString(stakeAmountDecimal, decimals: 0);
        final fee = decimalToLocaleString(
            Decimal.tryParse(validator.delegationFee) ?? Decimal.zero,
            decimals: 2);

        // max token validator là 3tr
        final absMaxStake = ONEAVAX * BigInt.parse("3000000");
        final relativeMaxStake = validatorStakeAmountBN * BigInt.from(4);

        var remainingStakeBN =
            min(absMaxStake - validatorStakeAmountBN, relativeMaxStake);

        final delegators = validator.delegators;
        if (delegators != null) {
          final sumOfStakeAmountDelegators = delegators.fold<BigInt>(
              BigInt.zero, (amt, delegator) => amt + delegator.stakeAmountBN);

          remainingStakeBN -= sumOfStakeAmountDelegators;
        }

        final sumOfStakeAmountPendingDelegators = pendingDelegators
            .where((delegator) => delegator.nodeId == validator.nodeId)
            .fold<BigInt>(
                BigInt.zero, (amt, delegator) => amt + delegator.stakeAmountBN);

        remainingStakeBN -= sumOfStakeAmountPendingDelegators;

        if (remainingStakeBN < minStakeDelegation) continue;

        final remainingStakeDecimal = bnToDecimalAvaxP(remainingStakeBN);
        final remainingStake =
            decimalToLocaleString(remainingStakeDecimal, decimals: 0);

        final message = "Node ID = ${validator.nodeId}\n"
            "Validator Stake = $stakeAmount\n"
            "Available = $remainingStake\n"
            "Number of Delegators = ${validator.delegators?.length ?? 0}\n"
            "End Time = ${validator.endTime}\n"
            "Fee = $fee%";
        logger.i(message);
      }
    } catch (e) {
      logger.e(e);
    }
  }

  delegate() async {
    try {
      const nodeId = "NodeID-LkiLFbmocMydnZ45jJgfoeLVTMN4nn83h";
      final amount = numberToBNAvaxX(100);
      final start = DateTime(2022, 3, 15, 12, 00).millisecondsSinceEpoch;
      final end = DateTime(2023, 1, 15, 12, 00).millisecondsSinceEpoch;
      final txId = await wallet.delegate(nodeId, amount, start, end);
      logger.i("txId = $txId");
    } catch (e) {
      logger.e(e);
    }
  }
}

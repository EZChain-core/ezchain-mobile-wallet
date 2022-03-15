import 'dart:async';
import 'dart:convert';
import 'dart:math' as dart_math;
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/common/storage.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_current_validators.dart';
import 'package:wallet/ezc/sdk/common/output.dart';
import 'package:wallet/ezc/sdk/utils/bigint.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/payload.dart';
import 'package:wallet/ezc/wallet/asset/assets.dart';
import 'package:wallet/ezc/wallet/asset/erc20/erc20.dart';
import 'package:wallet/ezc/wallet/asset/erc20/types.dart';
import 'package:wallet/ezc/wallet/asset/types.dart';
import 'package:wallet/ezc/wallet/explorer/cchain/types.dart';
import 'package:wallet/ezc/wallet/explorer/ortelius/types.dart';
import 'package:wallet/ezc/wallet/helpers/address_helper.dart';
import 'package:wallet/ezc/wallet/helpers/gas_helper.dart';
import 'package:wallet/ezc/wallet/helpers/staking_helper.dart';
import 'package:wallet/ezc/wallet/history/history_helpers.dart';
import 'package:wallet/ezc/wallet/history/types.dart';
import 'package:wallet/ezc/wallet/network/constants.dart';
import 'package:wallet/ezc/wallet/network/helpers/alias_from_network_id.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/network/utils.dart';
import 'package:wallet/ezc/wallet/nft/types.dart';
import 'package:wallet/ezc/wallet/singleton_wallet.dart';
import 'package:wallet/ezc/wallet/types.dart';
import 'package:wallet/ezc/wallet/utils/fee_utils.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/ezc/wallet/utils/utils.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/common/setting/wallet_setting.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/themes/buttons.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/web3dart.dart';

import '../../auth/pin/verify/pin_code_verify.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final WalletFactory _walletFactory = getIt<WalletFactory>();

  WalletProvider get wallet => _walletFactory.activeWallet;

  @override
  void initState() {
    super.initState();
    // initWallet();
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
    //           getERC20Tokens();
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
    final result = await _walletFactory.initWallet();

    if (result) {
      final verify = await verifyPinCode();
      if (verify) {
        context.router.replaceAll([const DashboardRoute()]);
      }
    } else {
      context.router.replaceAll([const OnBoardRoute()]);
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
    // logger.i("total EZC = $totalString");
    //
    // final avaxPrice = await getAvaxPriceDecimal();
    // logger.i("1 EZC = ${decimalToLocaleString(avaxPrice, decimals: 2)}");
    //
    // final totalUsd = totalDecimal * avaxPrice;
    // final totalUsdString = decimalToLocaleString(totalUsd, decimals: 2);
    // logger.i("totalUsd = $totalUsdString");
  }

  initWallet() {
    final wallet = SingletonWallet(
        privateKey:
            "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");
    wallet.on(WalletEventType.balanceChangedX, _handleCallback);
    wallet.on(WalletEventType.balanceChangedP, _handleCallback);
    wallet.on(WalletEventType.balanceChangedC, _handleCallback);
    _walletFactory.addWallet(wallet);
    updateX();
    updateP();
    updateC();
  }

  changeNetwork() {
    // đừng quên xoá callback
    wallet.off(WalletEventType.balanceChangedX, _handleCallback);
    wallet.off(WalletEventType.balanceChangedP, _handleCallback);
    wallet.off(WalletEventType.balanceChangedC, _handleCallback);
    _walletFactory.clear();
    setRpcNetwork(mainnetConfig);
    initWallet();
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

  sendANT() async {
    try {
      const to = "X-fuji129sdwasyyvdlqqsg8d9pguvzlqvup6cmtd8jad";

      assert(validateAddressX(to));
      final fee = getTxFeeX();
      // từ list asset tokens chọn 1 asset có asset id
      const assetId = "2iMEUfDkiVPPHfQYQxPgT6eV7gqa6pbn6G1K1QTDLBtmS6fjuL";
      // Send Avalanche Native Tokens on X chain
      final txId = await wallet.sendANT(assetId, to, numberToBNAvaxX(69));
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
      final addresses = [
        ...await wallet.getAllAddressesX(),
        wallet.getEvmAddressBech()
      ];
      final addressesC = wallet.getAddressC();
      final histories = await Future.wait(transactions
          .map((tx) => wallet.parseOrteliusTx(tx, addresses, addressesC)));
      _parseXPTransactions("X", histories);
    } catch (e) {
      logger.e(e);
    }
  }

  getXTransactionsV2() async {
    try {
      final transactions = await wallet.getXTransactions(limit: 20);
      _parseXPTransactionsV2(transactions);
    } catch (e) {
      logger.e(e);
    }
  }

  getPTransactions() async {
    try {
      // chỉ P Chain mới cần get validators.
      final validators = await wallet.getPlatformValidators();
      final transactions = await wallet.getPTransactions(limit: 20);
      final addresses = [
        ...await wallet.getAllAddressesX(),
        wallet.getEvmAddressBech()
      ];
      final addressesC = wallet.getAddressC();
      final histories = await Future.wait(transactions
          .map((tx) => wallet.parseOrteliusTx(tx, addresses, addressesC)));
      _parseXPTransactions("P", histories, validators: validators);
    } catch (e) {
      logger.e(e);
    }
  }

  getPTransactionsV2() async {
    try {
      final transactions = await wallet.getPTransactions(limit: 20);
      _parseXPTransactionsV2(transactions);
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
              "Output can be spent in a year (${dateFormatter.format(stakeLockTimeDate)})\n";
        }
        final payload = parseNFTPayload(output.payload);
        if (payload != null && payload.isNotEmpty) {
          message += "Payload = $payload\n";
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
    final result = items
        .where((tx) => tx.type != HistoryItemTypeName.notSupported)
        .toList();
    for (var item in result) {
      if (item is HistoryBaseTx) {
        final collectibles = item.collectibles;
        final sentTokens = item.sentTokens;
        final receivedTokens = item.receivedTokens;
        final hasSent =
            sentTokens.isNotEmpty || collectibles.sent.assets.isNotEmpty;

        final hasReceived = receivedTokens.isNotEmpty ||
            collectibles.received.assets.isNotEmpty;

        var message = "Date = ${item.timestamp}\n";

        if (hasSent) {
          message = _parserXBaseTX(
            item.id,
            sentTokens,
            collectibles.sent.assets,
            message,
          );
        }
        message += "\n";
        if (hasReceived) {
          message = _parserXBaseTX(
            item.id,
            receivedTokens,
            collectibles.received.assets,
            message,
          );
        }
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
        BigInt? potentialReward;
        final validator = validators.firstWhereOrNull((validator) {
          final nodeId = validator.nodeId.split("-")[1];
          return nodeId == item.nodeId;
        });
        if (validator != null) {
          if (item.type == HistoryItemTypeName.addValidator) {
            potentialReward = validator.potentialRewardBN;
            message += "Add Validator = ${item.amountDisplayValue} EZC\n";
          } else {
            final delegators = validator.delegators;
            if (delegators != null) {
              final delegator = delegators
                  .firstWhereOrNull((delegator) => delegator.txId == item.id);
              potentialReward = delegator?.potentialRewardBN;
              message += "Add Delegator = ${item.amountDisplayValue} EZC\n";
            }
          }
          if (potentialReward != null) {
            message += "Reward Pending = ${bnToAvaxP(potentialReward)} EZC";
          } else {
            message += "Reward Pending = ?";
          }
        }
        logger.i(message);
      }
    }
  }

  String _parserXBaseTX(
    String txId,
    List<HistoryBaseTxToken> tokens,
    Map<String, List<OrteliusTxOutput>> assets,
    String message,
  ) {
    for (var token in tokens) {
      if (token.isProfit) {
        message += "Received ";
      } else {
        message += "Send ";
      }
      for (var address in token.addresses) {
        if (token.isProfit) {
          message += "From: X-";
        } else {
          message += "To: X-";
        }
        message += "$address ";
      }
      message += "Amount: ${token.amountDisplayValue}";
    }
    final groupDict = <int, List<OrteliusTxOutput>>{};
    final utxos = assets.values.expand((list) => list);
    for (var utxo in utxos) {
      final groupId = utxo.groupId;
      final exists = groupDict[groupId];
      if (exists != null) {
        exists.add(utxo);
      } else {
        groupDict[groupId] = [utxo];
      }
    }
    for (var utxos in groupDict.values) {
      final firstUtxo = utxos.firstOrNull;
      if (firstUtxo != null) {
        final payload = firstUtxo.payload;
        if (payload != null) {
          try {
            var payloadBuff = base64Decode(payload);
            final lengthBuff = Uint8List(4)
              ..buffer.asByteData().setUint8(0, payloadBuff.length);
            payloadBuff = Uint8List.fromList([...lengthBuff, ...payloadBuff]);
            final typeId = PayloadTypes.instance.getTypeId(payloadBuff);
            final content = PayloadTypes.instance.getContent(payloadBuff);
            final payloadBase = PayloadTypes.instance.select(typeId, content);
            final text = utf8.decode(payloadBase.getContent());
            if (payloadBase is JSONPayload) {
              GenericNft? genericNft;
              try {
                genericNft =
                    GenericFormType.fromJson(jsonDecode(text)).avalanche;
              } catch (e) {
                logger.e(e);
              }
              if (genericNft != null) {
                message +=
                    "\nPayload: title = ${genericNft.title}, desc = ${genericNft.desc}, img = ${genericNft.img}\n";
              }
            } else if (payloadBase is URLPayload) {
              final url = text;
              message += "\nPayload: url = $url\n";
            } else {
              message += "\nPayload: text = $text\n";
            }
          } catch (e) {
            logger.e("txId = $txId", e);
          }
        }
      }
    }
    return message;
  }

  _parseXPTransactionsV2(List<OrteliusTx> transactions) async {
    for (final transaction in transactions) {
      var message = "";
      final id = transaction.id;
      message += "Id = $id\n";
      final timestamp = transaction.timestamp;
      message += "Time = $timestamp\n";
      final type = transaction.type.toTypeString();
      message += "Type = $type\n";
      final inputs = transaction.inputs;
      if (inputs == null || inputs.isEmpty) {
        message +=
            "No input UTXOs found for this transaction on the EZChain Explorer\n"; // chuyển vào strings.xml
      } else {
        inputs.sort((input1, input2) =>
            input1.output.outputIndex.compareTo(input2.output.outputIndex));
        for (final input in inputs) {
          final output = input.output;
          final chain = idToChainAlias(output.chainId);
          final addresses =
              output.addresses?.map((address) => "$chain-$address") ?? [];
          message += "From = ${addresses.join("\n")}\n";
          final amountBN = output.amountBN;
          if (amountBN != BigInt.zero) {
            final asset = await getAssetDescription(output.assetId);
            final denomination = int.tryParse(asset.denomination) ?? 0;
            final amount =
                bnToLocaleString(amountBN, denomination: denomination);
            message += "Amount = $amount ${asset.symbol}\n";
          }
        }
      }

      final outputs = transaction.outputs;
      if (outputs == null || outputs.isEmpty) {
        message +=
            "No output UTXOs found for this transaction on the EZChain Explorer\n"; // chuyển vào strings.xml
      } else {
        outputs.sort((output1, output2) =>
            output1.outputIndex.compareTo(output2.outputIndex));
        for (final output in outputs) {
          final chain = idToChainAlias(output.chainId);
          final addresses =
              output.addresses?.map((address) => "$chain-$address") ?? [];
          message += "To = ${addresses.join("\n")}\n";
          final amountBN = output.amountBN;
          if (amountBN != BigInt.zero) {
            final asset = await getAssetDescription(output.assetId);
            final denomination = int.tryParse(asset.denomination) ?? 0;
            final amount =
                bnToLocaleString(amountBN, denomination: denomination);
            message += "Amount = $amount ${asset.symbol}\n";
          }
        }
      }
      logger.i(message);
    }
  }

  getHistoryERC20() async {
    try {
      final transactions = await wallet.getHistoryERC2(
        contractAddress: "0x2f5b4CC31b736456dd331e40B202ED70100508F7",
      );
      for (final transaction in transactions) {
        var message = "";
        message += "Id = ${transaction.hash}\n";
        message += "Time = ${transaction.timeStamp}\n";
        message += "Type = Transfer\n";
        message += "From = ${transaction.from}\n";
        message += "To = ${transaction.to}\n";
        final amountBN = BigInt.tryParse(transaction.value) ?? BigInt.zero;
        final denomination = int.tryParse(transaction.tokenDecimal) ?? 0;
        message +=
            "Amount = ${bnToLocaleString(amountBN, denomination: denomination)} ${transaction.tokenSymbol}\n";
        logger.i(message);
      }
    } catch (e) {
      logger.e(e);
    }
  }

  getHistoryANT() async {
    try {
      // từ list asset tokens chọn 1 asset có asset id
      const assetId = "2iMEUfDkiVPPHfQYQxPgT6eV7gqa6pbn6G1K1QTDLBtmS6fjuL";
      final transactions = await wallet.getXTransactions(limit: 20);
      final filteredTransactions = transactions
          .where((element) =>
              element.inputTotals.keys.contains(assetId) ||
              element.outputTotals.keys.contains(assetId))
          .toList();
      _parseXPTransactionsV2(filteredTransactions);
    } catch (e) {
      logger.e(e);
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
      const nodeId = "NodeID-FRouddSdqsz9SqFddmcpX3kMcTUuczYWW";
      const amount = 100;

      // ONLY FOR EXAMPLE: fetch to get selected node
      final validators = await wallet.getPlatformValidators();
      final selectedNode =
          validators.where((element) => element.nodeId == nodeId).first;

      final start = DateTime.now().millisecondsSinceEpoch + 5 * 60000;
      final end = DateTime(2022, 6, 6, 12, 00).millisecondsSinceEpoch;

      final duration = end - start;

      // store lại current supply tránh việc mỗi khi thay đổi amount phải gọi lại
      final currentSupply = await wallet.getCurrentSupply();
      final estimation = await calculateStakingReward(
        numberToBN(amount, 18),
        duration ~/ 1000,
        currentSupply * BigInt.from(10).pow(9),
      );
      final estimatedReward = bnToDecimal(estimation, denomination: 18);
      logger.i("estimatedReward = ${estimatedReward.toStringAsFixed(2)}");
      final delegationFee =
          Decimal.tryParse(selectedNode.delegationFee) ?? Decimal.zero;
      final cut =
          estimatedReward * (delegationFee / Decimal.fromInt(100)).toDecimal();
      final totalFee = getTxFeeP() * BigInt.from(10).pow(9) +
          decimalToBn(cut, denomination: 18);
      logger.i(
          "totalFee = ${bnToDecimal(totalFee, denomination: 18).toStringAsFixed(2)}");

      /// Start delegation in 5 minutes
      final txId =
          await wallet.delegate(nodeId, numberToBNAvaxP(amount), start, end);
      logger.i("txId = $txId");
    } catch (e) {
      logger.e(e);
    }
  }

  estimateRewards() async {
    // tạo ra 1 shared store để share validators với case estimateRewards
    final validators = await wallet.getPlatformValidators();
    final delegators = validators
        .where((element) =>
            element.delegators != null && element.delegators!.isNotEmpty)
        .map((e) => e.delegators!)
        .expand((element) => element)
        .toList();

    final userAddresses = await wallet.getAllAddressesP();

    final resV = cleanList(userAddresses, validators) as List<Validator>;
    final resD = cleanList(userAddresses, delegators) as List<Delegator>;

    final validatorsReward = resV.fold<BigInt>(BigInt.zero,
        (previousValue, element) => previousValue + element.potentialRewardBN);
    final delegatorsReward = resD.fold<BigInt>(BigInt.zero,
        (previousValue, element) => previousValue + element.potentialRewardBN);

    final totalReward = bnToAvaxP(validatorsReward + delegatorsReward);

    logger.i("totalReward = $totalReward EZC");

    for (var element in resV) {
      final startTime = (int.tryParse(element.startTime) ?? 0) * 1000;
      final endTime = (int.tryParse(element.endTime) ?? 0) * 1000;
      final now = DateTime.now().millisecondsSinceEpoch;
      final percent =
          dart_math.min((now - startTime) / (endTime - startTime), 1);
      final rewardAmt = bnToAvaxP(element.potentialRewardBN);
      final stakingAmt = bnToAvaxP(element.stakeAmountBN);
      logger.i(
          "Validator: NodeId = ${element.nodeId}, percent = ${percent * 100}%, stakingAmt = $stakingAmt EZC, rewardAmt = $rewardAmt EZC");
    }
    for (var element in resD) {
      final startTime = (int.tryParse(element.startTime) ?? 0) * 1000;
      final endTime = (int.tryParse(element.endTime) ?? 0) * 1000;
      final now = DateTime.now().millisecondsSinceEpoch;
      final percent =
          dart_math.min((now - startTime) / (endTime - startTime), 1);
      final rewardAmt = bnToAvaxP(element.potentialRewardBN);
      final stakingAmt = bnToAvaxP(element.stakeAmountBN);
      logger.i(
          "Delegator: NodeId = ${element.nodeId}, percent = ${percent * 100}%, stakingAmt = $stakingAmt EZC, rewardAmt = $rewardAmt EZC");
    }
  }

  List<dynamic> cleanList(List<String> userAddresses, List<dynamic> list) {
    final res = list.where((element) {
      final rewardAddresses = element.rewardOwner?.addresses;
      if (rewardAddresses == null) return false;
      final filtered =
          rewardAddresses.where((element) => userAddresses.contains(element));
      return filtered.isNotEmpty;
    }).toList();

    res.sort((a, b) {
      final startA = int.tryParse(a.startTime) ?? 0;
      final startB = int.tryParse(b.startTime) ?? 0;

      if (startA < startB) {
        return -1;
      } else if (startA > startB) {
        return 1;
      } else {
        return 0;
      }
    });

    return res;
  }

  fetchAssets() async {
    final avaAssetId = getAvaxAssetId();
    final stake = await wallet
        .getStake(); // <-- cho mục đích ví dụ, impl có thể phải cần thiết kế để shared
    // cần thiết kế để lắng nghe khi update đc utxosX thì mới map data
    final balanceDict = wallet.getBalanceX();
    // cần xử lý lại để shared với hàm mintNFT và mỗi khi update lại utxosX
    final assetUtxoMap = <String, AvmUTXO>{};
    for (final utxo in wallet.utxosX.utxos.values) {
      assetUtxoMap[cb58Encode(utxo.assetId)] = utxo;
    }
    // cần xử lý lại để shared với hàm mintNFT và mỗi khi update lại utxosX
    final assets = wallet.getUnknownAssets().where((element) {
      final output = assetUtxoMap[element.assetId]?.getOutput();
      return output?.getOutputId() == SECPXFEROUTPUTID;
    }).map((asset) {
      final avaAsset = AvaAsset(
        id: asset.assetId,
        name: asset.name,
        symbol: asset.symbol,
        denomination: int.tryParse(asset.denomination) ?? 0,
      );

      final balanceAmt = balanceDict[avaAsset.id];
      if (balanceAmt == null) {
        avaAsset.resetBalance();
      } else {
        avaAsset.resetBalance();
        avaAsset.addBalance(balanceAmt.unlocked);
        avaAsset.addBalanceLocked(balanceAmt.locked);
      }

      // Add extras for AVAX token
      if (avaAsset.id == avaAssetId) {
        final balanceP = wallet.getBalanceP();
        avaAsset.addExtra(stake.stakedBN);
        avaAsset.addExtra(balanceP.unlocked);
        avaAsset.addExtra(balanceP.locked);
        avaAsset.addExtra(balanceP.lockedStakeable);
      }
      return avaAsset;
    }).toList();

    assets.customSort(avaAssetId);

    var stringAssets = "\n";

    for (var element in assets) {
      stringAssets +=
          "isEZC = ${element.id == avaAssetId}, assetId = ${element.id}, name = ${element.name}, symbol = ${element.symbol}, amount = ${element.toString()}\n";
    }

    logger.i(stringAssets);
  }

  createNFTFamily() async {
    const name = "FLUTTER";
    const symbol = "KIEN";
    const groupNum = 23;
    if (symbol.isEmpty) {
      logger.e('You must provide a symbol.');
      return;
    } else if (symbol.length > 4) {
      logger.e('Symbol must be 4 characters max.');
      return;
    } else if (groupNum < 1) {
      logger.e('Number of groups must be at least 1.');
      return;
    }
    final fee = bnToDecimalAvaxX(xChain.getCreationTxFee());
    logger.i("fee = $fee EZC");
    try {
      final txId = await wallet.createNFTFamily(
        name.trim(),
        symbol.trim(),
        groupNum,
      );
      logger.i("createNFTFamily = $txId");
    } catch (e) {
      logger.e(e);
    }
  }

  mintNFT() async {
    try {
      final fee = bnToDecimalAvaxX(xChain.getTxFee());
      logger.i("fee = $fee EZC");

      // cần xử lý lại để shared với hàm fetchAssets và mỗi khi update lại utxosX
      final assetUtxoMap = <String, AvmUTXO>{};
      for (final utxo in wallet.utxosX.utxos.values) {
        assetUtxoMap[cb58Encode(utxo.assetId)] = utxo;
      }

      // cần xử lý lại để shared với hàm fetchAssets và mỗi khi update lại utxosX
      final assets = wallet.getUnknownAssets().where((element) {
        final utxo = assetUtxoMap[element.assetId];
        final outputId = utxo?.output.getOutputId();
        return outputId == NFTMINTOUTPUTID;
      }).toList();

      // Hiển thị màn hình list NFT assets
      for (final asset in assets) {
        logger.i("name = ${asset.name}, symbol = ${asset.symbol}");
      }

      // Chọn 1 asset, ví dụ first
      final firstAsset = assets.firstOrNull;
      if (firstAsset == null) return;

      final utxo = assetUtxoMap[firstAsset.assetId]!;

      final generic = GenericFormType(
        avalanche: GenericNft(
          version: 1,
          type: "generic",
          title: "title",
          img: "imgUrl",
          desc: "description",
        ),
      );

      final genericPayload = JSONPayload(generic.toJson());
      final jsonPayload = JSONPayload("{\"test\": \"1\"}");
      final utf8Payload = UTF8Payload("KIEN MIN NFT");
      final urlPayload = URLPayload("https://wallet.ezchain.com/");
      final txId = await wallet.mintNFT(
        utxo,
        urlPayload,
        1,
      );
      logger.i("mintNFT = $txId");
    } catch (e) {
      logger.e(e);
    }
  }

  addERC20() async {
    const contractAddress = "0x2f5b4CC31b736456dd331e40B202ED70100508F7";
    final erc20TokenData = await Erc20TokenData.getData(
      contractAddress,
      web3,
      activeNetwork.evmChainId,
    );

    if (erc20TokenData == null) {
      logger.e("Invalid contract address.");
      return;
    }

    await erc20TokenData.getBalance(
      wallet.getAddressC(),
      web3,
    );
    logger.i(
        "name = ${erc20TokenData.name}, symbol = ${erc20TokenData.symbol}, decimals = ${erc20TokenData.decimals}, balance = ${erc20TokenData.balance}");
  }

  getERC20Tokens() async {
    final token1 = await Erc20TokenData.getData(
      "0x719191e8849EBFe2821525EBAc669c118ed08C1b",
      web3,
      activeNetwork.evmChainId,
    );

    final token2 = await Erc20TokenData.getData(
      "0x2f5b4CC31b736456dd331e40B202ED70100508F7",
      web3,
      activeNetwork.evmChainId,
    );

    final erc20Tokens = <Erc20TokenData>[token1!, token2!];

    final key = "${wallet.getAddressX()}_${activeNetwork.evmChainId}";

    try {
      String json = jsonEncode(erc20Tokens);
      await storage.write(key: key, value: json);
    } catch (e) {
      logger.e(e);
      return;
    }

    try {
      final json = await storage.read(key: key);
      logger.i("read = $json");
      if (json == null || json.isEmpty) return;
      final map = jsonDecode(json) as List<dynamic>;
      final cachedErc20Tokens =
          List<Erc20TokenData>.from(map.map((i) => Erc20TokenData.fromJson(i)));
      final evmAddress = wallet.getAddressC();
      await Future.wait(
          cachedErc20Tokens.map((erc20) => erc20.getBalance(evmAddress, web3)));
      logger.i(cachedErc20Tokens);
    } catch (e) {
      logger.e(e);
    }
  }
}

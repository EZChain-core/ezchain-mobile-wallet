import 'package:wallet/ezc/wallet/asset/types.dart';
import 'package:wallet/ezc/wallet/explorer/ortelius/types.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

enum HistoryItemTypeName {
  import,
  export,
  transaction,
  transactionEvm,
  addDelegator,
  addValidator,
  delegationFee,
  validationFee,
  notSupported,
}

class HistoryItem {
  final String id;
  final HistoryItemTypeName type;
  final BigInt fee;
  final String? timestamp;
  final String? memo;

  bool get isAvmHistoryItem =>
      this is HistoryBaseTx || this is HistoryImportExport;

  bool get isPvmHistoryItem => this is HistoryStaking;

  HistoryItem({
    required this.id,
    required this.type,
    required this.fee,
    this.timestamp,
    this.memo,
  });
}

/// Parsed interface for Validation, Validation Fee, Delegation and Delegation Fee transactions.
class HistoryStaking extends HistoryItem {
  final String nodeId;
  final int stakeStart;
  final int stakeEnd;
  final BigInt amount;
  final String amountDisplayValue;
  final bool isRewarded;
  final BigInt rewardAmount;
  final String rewardAmountDisplayValue;

  HistoryStaking({
    required String id,
    required HistoryItemTypeName type,
    required BigInt fee,
    String? timestamp,
    String? memo,
    required this.nodeId,
    required this.stakeStart,
    required this.stakeEnd,
    required this.amount,
    required this.amountDisplayValue,
    required this.isRewarded,
    required this.rewardAmount,
    required this.rewardAmountDisplayValue,
  }) : super(
          id: id,
          type: type,
          fee: fee,
          timestamp: timestamp,
          memo: memo,
        );
}

/// Parsed interface for Import and Export transactions.
class HistoryImportExport extends HistoryItem {
  final BigInt amount;
  final String amountDisplayValue;
  final String destination;
  final String source;

  HistoryImportExport({
    required String id,
    required HistoryItemTypeName type,
    required BigInt fee,
    String? timestamp,
    String? memo,
    required this.amount,
    required this.amountDisplayValue,
    required this.destination,
    required this.source,
  }) : super(
          id: id,
          type: type,
          fee: fee,
          timestamp: timestamp,
          memo: memo,
        );
}

/// Interface for parsed X chain base transactions.
class HistoryBaseTx extends HistoryItem {
  final List<HistoryBaseTxToken> tokens;

  final HistoryBaseTxNFT collectibles;

  HistoryBaseTx(
      {required String id,
      required HistoryItemTypeName type,
      required BigInt fee,
      String? timestamp,
      String? memo,
      required this.tokens,
      required this.collectibles})
      : super(
          id: id,
          type: type,
          fee: fee,
          timestamp: timestamp,
          memo: memo,
        );

  List<HistoryBaseTxToken> get sentTokens =>
      tokens.where((token) => token.amount < BigInt.zero).toList();

  List<HistoryBaseTxToken> get receivedTokens =>
      tokens.where((token) => token.amount >= BigInt.zero).toList();
}

class HistoryBaseTxToken {
  BigInt amount;
  final List<String> addresses;
  final AssetDescriptionClean asset;

  HistoryBaseTxToken(
    this.amount,
    this.addresses,
    this.asset,
  );

  bool get isProfit => amount >= BigInt.zero;

  String get amountDisplayValue =>
      bnToLocaleString(
        amount,
        decimals: int.tryParse(asset.denomination) ?? 0,
      ) +
      " " +
      asset.symbol;
}

class HistoryBaseTxTokenLossGain {
  final Map<String, BigInt> result;

  HistoryBaseTxTokenLossGain(this.result);
}

class HistoryBaseTxTokenOwners {
  final Map<String, List<String>> result;

  HistoryBaseTxTokenOwners(this.result);
}

class HistoryBaseTxNFT {
  final HistoryBaseTxNFTSummaryResultDict sent;
  final HistoryBaseTxNFTSummaryResultDict received;

  HistoryBaseTxNFT({required this.sent, required this.received});
}

class HistoryBaseTxNFTSummaryResultDict {
  final Map<String, List<OrteliusTxOutput>> assets;
  final List<String> addresses;

  HistoryBaseTxNFTSummaryResultDict(this.assets, this.addresses);
}

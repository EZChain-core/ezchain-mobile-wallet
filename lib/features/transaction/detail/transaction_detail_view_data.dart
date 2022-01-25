import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:wallet/common/extensions.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/features/common/chain_type/ezc_type.dart';
import 'package:wallet/roi/wallet/explorer/ortelius/types.dart';
import 'package:wallet/roi/wallet/history/history_helpers.dart';
import 'package:wallet/roi/wallet/network/helpers/alias_from_network_id.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

class TransactionDetailViewData {
  final String id;
  final String? accepted;
  final String? value;
  final String? burned;
  final EZCType? blockchain;
  final String? memo;
  final List<TransactionDetailInputViewData>? inputs;
  final List<TransactionDetailOutputViewData>? outputs;

  TransactionDetailViewData(this.id, this.accepted, this.value, this.burned,
      this.blockchain, this.memo, this.inputs, this.outputs);
}

class TransactionDetailInputViewData {
  final String? from;
  final String? signature;

  TransactionDetailInputViewData(this.from, this.signature);
}

class TransactionDetailOutputViewData {
  final String? to;

  TransactionDetailOutputViewData(this.to);
}

extension TransactionDetailExtension on OrteliusTx {
  TransactionDetailViewData? mapToTransactionDetailViewData() {
    try {
      final accepted =
          timestamp?.parseDateTime()?.format('dd/MM/yyyy, hh:mm:ss');

      final valueBigInt = outputTotals.values.fold<BigInt>(
          BigInt.zero,
          (previousValue, element) =>
              previousValue + (BigInt.tryParse(element) ?? BigInt.zero));

      final value = valueBigInt != BigInt.zero
          ? '${bnToLocaleString(valueBigInt)} EZC'
          : null;

      final burned =
          '${bnToDecimalAvaxX(BigInt.tryParse(txFee.toString()) ?? BigInt.zero)} EZC';

      final ezcType = chainAliasToEZCType(idToChainAlias(chainId));

      final blockId = txBlockId;
      if (blockId != null && blockId.isNotEmpty) {
        logger.i("block = $blockId\n");
      }

      final validatorNodeId = this.validatorNodeId;

      if (validatorNodeId.isNotEmpty) {
        logger.i("Staking: validator = $validatorNodeId\n");
      }

      final validatorStart = this.validatorStart * 1000;
      final validatorEnd = this.validatorEnd * 1000;

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
        logger.i(
            "duration = ${totalDays.toStringAsFixed(0)} days (${elapsedPercent.toStringAsFixed(0)}% elapsed)\n");
        logger.i(
            "start = ${dateFormatter.format(validatorStartDate)}, end = ${dateFormatter.format(validatorEndDate)}\n");
      }

      String? memo;
      try {
        memo = parseMemo(this.memo);
      } catch (e) {
        logger.e(e);
      }

      final List<TransactionDetailInputViewData> inputs = [];
      final ins = this.inputs ?? [];
      for (var i = 0; i < ins.length; i++) {
        final input = ins[i];
        final signatures = input.credentials?.map((e) => e.signature);
        final output = input.output;
        final amount =
            bnToLocaleString(BigInt.tryParse(output.amount) ?? BigInt.zero);
        final addresses = output.addresses;
        inputs.add(TransactionDetailInputViewData(
            addresses?.firstOrNull, signatures?.firstOrNull));
      }

      final List<TransactionDetailOutputViewData> outputs = [];
      final outs = this.outputs ?? [];
      for (var i = 0; i < outs.length; i++) {
        final output = outs[i];
        final amount =
            bnToLocaleString(BigInt.tryParse(output.amount) ?? BigInt.zero);
        final addresses = output.addresses;
        outputs.add(TransactionDetailOutputViewData(addresses?.firstOrNull));
        final stakeLockTime = output.stakeLockTime;
        if (stakeLockTime != null && stakeLockTime != 0) {
          final stakeLockTimeDate =
              DateTime.fromMillisecondsSinceEpoch(stakeLockTime * 1000);
          final dateFormatter = DateFormat("MM/dd/yyyy, HH:mm:ss a");
          logger.i(
              "Output can be spent in a year (${dateFormatter.format(stakeLockTimeDate)})");
        }
      }
      return TransactionDetailViewData(
          id, accepted, value, burned, ezcType, memo, inputs, outputs);
    } catch (e) {
      logger.e(e);
      return null;
    }
  }
}

import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/pvm/constants.dart';
import 'package:wallet/roi/sdk/apis/pvm/base_tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/export_tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/import_tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/inputs.dart';
import 'package:wallet/roi/sdk/apis/pvm/outputs.dart';
import 'package:wallet/roi/sdk/apis/pvm/tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/validation_tx.dart';
import 'package:wallet/roi/sdk/common/asset_amount.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/common/utxos.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

class PvmUTXO extends StandardUTXO {
  @override
  String get typeName => "PvmUTXO";

  PvmUTXO(
      {int codecId = 0,
      Uint8List? txId,
      dynamic outputIdx,
      Uint8List? assetId,
      Output? output})
      : super(
            codecId: codecId,
            txId: txId,
            outputIdx: outputIdx,
            assetId: assetId,
            output: output);

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    output = selectOutputClass(fields["output"]["_typeId"]);
    output.deserialize(fields["output"], encoding: encoding);
  }

  @override
  int fromBuffer(Uint8List bytes, {int? offset}) {
    offset ??= 0;
    codecIdBuff = bytes.sublist(offset, offset + 2);
    offset += 2;
    txId = bytes.sublist(offset, offset + 32);
    offset += 32;
    outputIdx = bytes.sublist(offset, offset + 4);
    offset += 4;
    assetId = bytes.sublist(offset, offset + 32);
    offset += 32;
    final outputId =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    output = selectOutputClass(outputId);
    return output.fromBuffer(bytes, offset: offset);
  }

  @override
  int fromString(String serialized) {
    return fromBuffer(cb58Decode(serialized));
  }

  @override
  String toString() {
    return cb58Encode(toBuffer());
  }

  @override
  StandardUTXO clone() {
    return PvmUTXO()..fromBuffer(toBuffer());
  }
}

class PvmAssetAmountDestination extends StandardAssetAmountDestination<
    PvmTransferableOutput, PvmTransferableInput> {
  PvmAssetAmountDestination(
      {List<Uint8List> destinations = const [],
      List<Uint8List> senders = const [],
      List<Uint8List> changeAddresses = const []})
      : super(
            destinations: destinations,
            senders: senders,
            changeAddresses: changeAddresses);
}

class PvmUTXOSet extends StandardUTXOSet<PvmUTXO> {
  @override
  String get typeName => "PvmUTXOSet";

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    final Map<String, PvmUTXO> utxos = {};
    for (final utxoId in (fields["utxos"] as Map<String, dynamic>).keys) {
      final utxoIdCleaned = Serialization.instance.decoder(
          utxoId, encoding, SerializedType.base58, SerializedType.base58);

      utxos["$utxoIdCleaned"] = PvmUTXO();
      (utxos["$utxoIdCleaned"] as PvmUTXO)
          .deserialize(fields["utxos"][utxoId], encoding: encoding);
    }
    final Map<String, Map<String, BigInt>> addressUTXOs = {};
    for (final address
        in (fields["addressUTXOs"] as Map<String, dynamic>).keys) {
      final addressCleaned = Serialization.instance
          .decoder(address, encoding, SerializedType.cb58, SerializedType.hex);
      final Map<String, BigInt> utxoBalance = {};
      for (final utxoId
          in (fields["addressUTXOs"][address] as Map<String, dynamic>).keys) {
        final utxoIdCleaned = Serialization.instance.decoder(
            utxoId, encoding, SerializedType.base58, SerializedType.base58);

        utxoBalance[utxoIdCleaned] = Serialization.instance.decoder(
            fields["addressUTXOs"][address][utxoId],
            encoding,
            SerializedType.decimalString,
            SerializedType.BN);
      }
      addressUTXOs[addressCleaned] = utxoBalance;
    }
    this.utxos = utxos;
    this.addressUTXOs = addressUTXOs;
  }

  @override
  PvmUTXO parseUTXO(dynamic utxo) {
    final pvmUTXO = PvmUTXO();
    if (utxo is String) {
      pvmUTXO.fromBuffer(cb58Decode(utxo));
    } else if (utxo is PvmUTXO) {
      pvmUTXO.fromBuffer(utxo.toBuffer());
    } else {
      throw Exception(
          "Error - UTXO.parseUTXO: utxo parameter is not a UTXO or string");
    }
    return pvmUTXO;
  }

  @override
  StandardUTXOSet<StandardUTXO> create({Map<String, dynamic> args = const {}}) {
    return PvmUTXOSet();
  }

  @override
  StandardUTXOSet<StandardUTXO> clone() {
    final newSet = create();
    final allUTXOs = getAllUTXOs();
    newSet.addArray(allUTXOs);
    return newSet;
  }

  PvmUnsignedTx buildBaseTx(
      int networkId,
      Uint8List blockchainId,
      BigInt amount,
      Uint8List assetId,
      List<Uint8List> toAddresses,
      List<Uint8List> fromAddresses,
      {List<Uint8List>? changeAddresses,
      BigInt? fee,
      Uint8List? feeAssetId,
      Uint8List? memo,
      BigInt? asOf,
      BigInt? lockTime,
      int threshold = 1}) {
    asOf ??= unixNow();
    lockTime ??= BigInt.zero;
    if (threshold > toAddresses.length) {
      throw Exception(
          "Error - UTXOSet.buildBaseTx: threshold is greater than number of addresses");
    }

    assert(amount > BigInt.zero);

    changeAddresses ??= toAddresses;
    feeAssetId ??= assetId;

    final aad = PvmAssetAmountDestination(
        destinations: toAddresses,
        senders: fromAddresses,
        changeAddresses: changeAddresses);

    if (hexEncode(assetId) == hexEncode(feeAssetId)) {
      aad.addAssetAmount(assetId, amount, fee ?? BigInt.zero);
    } else {
      aad.addAssetAmount(assetId, amount, BigInt.zero);
      if (_feeCheck(fee, feeAssetId)) {
        aad.addAssetAmount(feeAssetId, BigInt.zero, fee ?? BigInt.zero);
      }
    }

    _getMinimumSpendable(
      aad,
      asOf: asOf,
      lockTime: lockTime,
      threshold: threshold,
    );

    final baseTx = PvmBaseTx(
        networkId: networkId,
        blockchainId: blockchainId,
        outs: aad.getAllOutputs(),
        ins: aad.getInputs(),
        memo: memo);

    return PvmUnsignedTx(transaction: baseTx);
  }

  PvmUnsignedTx buildImportTx(
      int networkId,
      Uint8List blockchainId,
      List<PvmUTXO> atomics,
      List<Uint8List> toAddresses,
      List<Uint8List> fromAddresses,
      {List<Uint8List>? changeAddresses,
      Uint8List? sourceChain,
      BigInt? fee,
      Uint8List? feeAssetId,
      Uint8List? memo,
      BigInt? asOf,
      BigInt? lockTime,
      int threshold = 1}) {
    var ins = <PvmTransferableInput>[];
    var outs = <PvmTransferableOutput>[];
    fee ??= BigInt.zero;
    final importIns = <PvmTransferableInput>[];
    var feePaid = BigInt.zero;
    final feeAssetStr = feeAssetId == null ? null : hexEncode(feeAssetId);

    for (int i = 0; i < atomics.length; i++) {
      final utxo = atomics[i];
      final assetId = utxo.getAssetId();
      final output = utxo.getOutput() as PvmAmountOutput;
      final amt = output.getAmount();
      var inFeeAmount = amt;
      final assetStr = hexEncode(assetId);
      if (feeAssetId != null &&
          fee > BigInt.zero &&
          feePaid < fee &&
          assetStr == feeAssetStr) {
        feePaid += inFeeAmount;
        if (feePaid >= fee) {
          inFeeAmount = feePaid - fee;
          feePaid = fee;
        } else {
          inFeeAmount = BigInt.zero;
        }
      }
      final txId = utxo.getTxId();
      final outputIdx = utxo.getOutputIdx();
      final input = PvmSECPTransferInput(amount: amt);
      final xFerIn = PvmTransferableInput(
        txId: txId,
        outputIdx: outputIdx,
        assetId: assetId,
        input: input,
      );
      final from = output.getAddresses();
      final spenders = output.getSpenders(from, asOf: asOf);
      for (int j = 0; j < spenders.length; j++) {
        final spender = spenders[j];
        final idx = output.getAddressIdx(spender);
        if (idx == -1) {
          throw Exception(
              "Error - UTXOSet.buildImportTx: no such address in output: $spender");
        }
        xFerIn.getInput().addSignatureIdx(idx, spender);
      }
      importIns.add(xFerIn);
      if (inFeeAmount > BigInt.zero) {
        final spendOut = selectOutputClass(output.getOutputId(),
            args: PvmAmountOutput.createArgs(
                amount: inFeeAmount,
                addresses: toAddresses,
                lockTime: lockTime,
                threshold: threshold)) as PvmAmountOutput;
        final xFerOut = PvmTransferableOutput(
          assetId: assetId,
          output: spendOut,
        );
        outs.add(xFerOut);
      }
    }

    final feeRemaining = fee - feePaid;

    if (feeRemaining > BigInt.zero &&
        feeAssetId != null &&
        _feeCheck(feeRemaining, feeAssetId) &&
        changeAddresses != null) {
      final aad = PvmAssetAmountDestination(
        destinations: toAddresses,
        senders: fromAddresses,
        changeAddresses: changeAddresses,
      );
      aad.addAssetAmount(feeAssetId, BigInt.zero, feeRemaining);
      _getMinimumSpendable(
        aad,
        asOf: asOf,
        lockTime: lockTime,
        threshold: threshold,
      );
      ins = aad.getInputs();
      outs = aad.getOutputs();
    }

    final importTx = PvmImportTx(
        networkId: networkId,
        blockchainId: blockchainId,
        outs: outs,
        ins: ins,
        memo: memo,
        sourceChain: sourceChain,
        importIns: importIns);

    return PvmUnsignedTx(transaction: importTx);
  }

  PvmUnsignedTx buildExportTx(
      int networkId,
      Uint8List blockchainId,
      BigInt amount,
      Uint8List avaxAssetId,
      Uint8List destinationChain,
      List<Uint8List> toAddresses,
      List<Uint8List> fromAddresses,
      {List<Uint8List>? changeAddresses,
      BigInt? fee,
      Uint8List? feeAssetId,
      Uint8List? memo,
      BigInt? asOf,
      BigInt? lockTime,
      int threshold = 1}) {
    asOf ??= unixNow();
    lockTime ??= BigInt.zero;

    changeAddresses ??= toAddresses;

    assert(amount > BigInt.zero);

    feeAssetId ??= avaxAssetId;

    assert(hexEncode(feeAssetId) == hexEncode(avaxAssetId),
        "Error - UTXOSet.buildExportTx: feeAssetID must match avaxAssetID");

    final aad = PvmAssetAmountDestination(
      destinations: toAddresses,
      senders: fromAddresses,
      changeAddresses: changeAddresses,
    );

    if (hexEncode(avaxAssetId) == hexEncode(feeAssetId)) {
      aad.addAssetAmount(avaxAssetId, amount, fee ?? BigInt.zero);
    } else {
      aad.addAssetAmount(avaxAssetId, amount, BigInt.zero);
      if (_feeCheck(fee, feeAssetId)) {
        aad.addAssetAmount(feeAssetId, BigInt.zero, fee ?? BigInt.zero);
      }
    }

    _getMinimumSpendable(
      aad,
      asOf: asOf,
      lockTime: lockTime,
      threshold: threshold,
    );

    final exportTx = PvmExportTx(
      networkId: networkId,
      blockchainId: blockchainId,
      outs: aad.getChangeOutputs(),
      ins: aad.getInputs(),
      memo: memo,
      destinationChain: destinationChain,
      exportOuts: aad.getOutputs(),
    );

    return PvmUnsignedTx(transaction: exportTx);
  }

  PvmUnsignedTx buildAddDelegatorTx(
    int networkId,
    Uint8List blockchainId,
    Uint8List avaxAssetId,
    List<Uint8List> toAddresses,
    List<Uint8List> fromAddresses,
    List<Uint8List> changeAddresses,
    Uint8List nodeId,
    BigInt startTime,
    BigInt endTime,
    BigInt stakeAmount,
    BigInt rewardLockTime,
    int rewardThreshold,
    List<Uint8List> rewardAddresses, {
    BigInt? fee,
    Uint8List? feeAssetId,
    Uint8List? memo,
    BigInt? asOf,
  }) {
    asOf ??= unixNow();
    final ins = <PvmTransferableInput>[];
    final outs = <PvmTransferableOutput>[];
    final stakeOuts = <PvmTransferableOutput>[];
    final now = unixNow();
    if (startTime < now || endTime <= startTime) {
      throw Exception(
          "UTXOSet.buildAddDelegatorTx -- startTime must be in the future and endTime must come after startTime");
    }

    final aad = PvmAssetAmountDestination(
      destinations: toAddresses,
      senders: fromAddresses,
      changeAddresses: changeAddresses,
    );

    if (feeAssetId != null) {
      if (hexEncode(avaxAssetId) == hexEncode(feeAssetId)) {
        aad.addAssetAmount(avaxAssetId, stakeAmount, fee ?? BigInt.zero);
      } else {
        aad.addAssetAmount(avaxAssetId, stakeAmount, BigInt.zero);
        if (_feeCheck(fee, feeAssetId)) {
          aad.addAssetAmount(feeAssetId, BigInt.zero, fee ?? BigInt.zero);
        }
      }
    }

    _getMinimumSpendable(aad, asOf: asOf);

    final rewardOutputOwners = PvmSECPOwnerOutput(
      lockTime: rewardLockTime,
      addresses: rewardAddresses,
      threshold: rewardThreshold,
    );

    final delegatorTx = PvmAddDelegatorTx(
      networkId: networkId,
      blockchainId: blockchainId,
      outs: outs,
      ins: ins,
      memo: memo,
      nodeId: nodeId,
      startTime: startTime,
      endTime: endTime,
      stakeAmount: stakeAmount,
      stakeOuts: stakeOuts,
      rewardOwners: PvmParseableOutput(output: rewardOutputOwners),
    );

    return PvmUnsignedTx(transaction: delegatorTx);
  }

  PvmUnsignedTx buildAddValidatorTx(
    int networkId,
    Uint8List blockchainId,
    Uint8List avaxAssetId,
    List<Uint8List> toAddresses,
    List<Uint8List> fromAddresses,
    List<Uint8List> changeAddresses,
    Uint8List nodeId,
    BigInt startTime,
    BigInt endTime,
    BigInt stakeAmount,
    BigInt rewardLockTime,
    int rewardThreshold,
    List<Uint8List> rewardAddresses,
    num delegationFee, {
    BigInt? fee,
    Uint8List? feeAssetId,
    Uint8List? memo,
    BigInt? asOf,
  }) {
    asOf ??= unixNow();
    final ins = <PvmTransferableInput>[];
    final outs = <PvmTransferableOutput>[];
    final stakeOuts = <PvmTransferableOutput>[];
    final now = unixNow();
    if (startTime < now || endTime <= startTime) {
      throw Exception(
          "UTXOSet.buildAddDelegatorTx -- startTime must be in the future and endTime must come after startTime");
    }
    if (delegationFee > 100 || delegationFee < 0) {
      throw Exception(
          "UTXOSet.buildAddValidatorTx -- startTime must be in the range of 0 to 100, inclusively");
    }

    final aad = PvmAssetAmountDestination(
      destinations: toAddresses,
      senders: fromAddresses,
      changeAddresses: changeAddresses,
    );

    if (feeAssetId != null) {
      if (hexEncode(avaxAssetId) == hexEncode(feeAssetId)) {
        aad.addAssetAmount(avaxAssetId, stakeAmount, fee ?? BigInt.zero);
      } else {
        aad.addAssetAmount(avaxAssetId, stakeAmount, BigInt.zero);
        if (_feeCheck(fee, feeAssetId)) {
          aad.addAssetAmount(feeAssetId, BigInt.zero, fee ?? BigInt.zero);
        }
      }
    }

    _getMinimumSpendable(aad, asOf: asOf);

    final rewardOutputOwners = PvmSECPOwnerOutput(
      lockTime: rewardLockTime,
      addresses: rewardAddresses,
      threshold: rewardThreshold,
    );

    final delegatorTx = PvmAddValidatorTx(
        networkId: networkId,
        blockchainId: blockchainId,
        outs: outs,
        ins: ins,
        memo: memo,
        nodeId: nodeId,
        startTime: startTime,
        endTime: endTime,
        stakeAmount: stakeAmount,
        stakeOuts: stakeOuts,
        rewardOwners: PvmParseableOutput(output: rewardOutputOwners),
        delegationFee: delegationFee);

    return PvmUnsignedTx(transaction: delegatorTx);
  }

  List<PvmUTXO> _getConsumableUXTO({BigInt? asOf, bool stakeable = false}) {
    asOf ??= unixNow();
    return getAllUTXOs().where((utxo) {
      if (stakeable) return true;
      final output = utxo.getOutput();
      if (output is! PvmStakeableLockOut) return true;
      if (output.getStakeableLockTime() < asOf!) return true;
      return false;
    }).toList();
  }

  void _getMinimumSpendable(PvmAssetAmountDestination aad,
      {BigInt? asOf,
      BigInt? lockTime,
      int threshold = 1,
      bool stakeable = false}) {
    asOf ??= unixNow();
    lockTime ??= BigInt.zero;

    var utxoArray = _getConsumableUXTO(asOf: asOf, stakeable: stakeable);
    final tmpUTXOArray = <PvmUTXO>[];

    if (stakeable) {
      for (final utxo in utxoArray) {
        if (utxo.getOutput().getTypeId() == STAKEABLELOCKOUTID) {
          tmpUTXOArray.add(utxo);
        }
      }

      tmpUTXOArray.sort((a, b) {
        final stakeableLockOut1 = a.getOutput() as PvmStakeableLockOut;
        final stakeableLockOut2 = a.getOutput() as PvmStakeableLockOut;
        return stakeableLockOut2.getStakeableLockTime().toInt() -
            stakeableLockOut1.getStakeableLockTime().toInt();
      });

      for (final utxo in utxoArray) {
        if (utxo.getOutput().getTypeId() == SECPXFEROUTPUTID) {
          tmpUTXOArray.add(utxo);
        }
      }
      utxoArray = tmpUTXOArray;
    }

    final outs = <String, Map<String, List<PvmAmountOutput>>>{};

    for (int i = 0; i < utxoArray.length; i++) {
      final utxo = utxoArray[i];
      final assetId = utxo.getAssetId();
      final assetKey = hexEncode(assetId);
      final fromAddresses = aad.getSenders();
      final output = utxo.getOutput();
      if (output is! PvmAmountOutput ||
          !aad.assetExists(assetKey) ||
          !output.meetsThreshold(fromAddresses, asOf: asOf)) {
        return;
      }

      final assetAmount = aad.getAssetAmount(assetKey);
      if (assetAmount.isFinished()) continue;
      if (!outs.keys.contains(assetKey)) {
        outs[assetKey] = {
          "lockedStakeable": <PvmAmountOutput>[],
          "unlocked": <PvmAmountOutput>[]
        };
      }
      final amount = output.getAmount();
      PvmAmountInput input = PvmSECPTransferInput(amount: amount);
      var locked = false;
      if (output is PvmStakeableLockOut) {
        final stakeableLockTime = output.getStakeableLockTime();
        if (stakeableLockTime > asOf) {
          input = PvmStakeableLockIn(
            amount: amount,
            stakeableLockTime: stakeableLockTime,
            transferableInput: PvmParseableInput(input: input),
          );
          locked = true;
        }
      }
      assetAmount.spendAmount(amount, stakeableLocked: locked);

      if (locked) {
        (outs[assetKey]!["lockedStakeable"] as List<PvmAmountOutput>)
            .add(output);
      } else {
        (outs[assetKey]!["unlocked"] as List<PvmAmountOutput>).add(output);
      }

      final spenders = output.getSpenders(fromAddresses, asOf: asOf);
      for (final spender in spenders) {
        final idx = output.getAddressIdx(spender);
        if (idx == -1) {
          throw Exception(
              "Error - UTXOSet.getMinimumSpendable: no such address in output: $spender");
        }
        input.addSignatureIdx(idx, spender);
      }

      final txId = utxo.getTxId();
      final outputIdx = utxo.getOutputIdx();
      final transferInput = PvmTransferableInput(
        input: input,
        txId: txId,
        outputIdx: outputIdx,
        assetId: assetId,
      );
      aad.addInput(transferInput);
    }

    if (!aad.canComplete()) {
      throw Exception(
          "Error - UTXOSet.getMinimumSpendable: insufficient funds to create the transaction");
    }

    final assetAmounts = aad.getAmounts();

    for (final assetAmount in assetAmounts) {
      final change = assetAmount.getChange();
      final isStakeableLockChange = assetAmount.getStakeableLockChange();
      final lockedChange = isStakeableLockChange ? change : BigInt.zero;
      final assetId = assetAmount.getAssetId();
      final assetKey = assetAmount.getAssetIdString();

      final lockedOutputs = outs[assetKey]!["lockedStakeable"] as List<dynamic>;
      for (int i = 0; i < lockedOutputs.length; i++) {
        final lockedOutput = lockedOutputs[i] as PvmStakeableLockOut;
        final stakeableLockTime = lockedOutput.getStakeableLockTime();
        final parseableOutput = lockedOutput.getTransferableOutput();
        final output = parseableOutput.getOutput() as PvmAmountOutput;
        var outputAmountRemaining = output.getAmount();
        if (i == lockedOutputs.length - 1 && lockedChange > BigInt.zero) {
          outputAmountRemaining = outputAmountRemaining - lockedChange;
          final newChangeOutput = selectOutputClass(
            output.getOutputId(),
            args: PvmAmountOutput.createArgs(
                amount: lockedChange,
                addresses: output.getAddresses(),
                lockTime: output.getLockTime(),
                threshold: output.getThreshold()),
          ) as PvmAmountOutput;

          final newLockedChangeOutput = selectOutputClass(
            lockedOutput.getOutputId(),
            args: PvmAmountOutput.createArgs(
                amount: lockedChange,
                addresses: output.getAddresses(),
                lockTime: output.getLockTime(),
                threshold: output.getThreshold(),
                stakeableLockTime: stakeableLockTime,
                transferableOutput:
                    PvmParseableOutput(output: newChangeOutput)),
          );

          final transferOutput = PvmTransferableOutput(
            assetId: assetId,
            output: newLockedChangeOutput,
          );
          aad.addChange(transferOutput);
        }
        final newOutput = selectOutputClass(
          output.getOutputId(),
          args: PvmAmountOutput.createArgs(
              amount: outputAmountRemaining,
              addresses: output.getAddresses(),
              lockTime: output.getLockTime(),
              threshold: output.getThreshold()),
        ) as PvmAmountOutput;
        final newLockedOutput = selectOutputClass(
          lockedOutput.getOutputId(),
          args: PvmAmountOutput.createArgs(
              amount: outputAmountRemaining,
              addresses: output.getAddresses(),
              lockTime: output.getLockTime(),
              threshold: output.getThreshold(),
              stakeableLockTime: stakeableLockTime,
              transferableOutput: PvmParseableOutput(output: newOutput)),
        ) as PvmStakeableLockOut;

        final transferOutput =
            PvmTransferableOutput(assetId: assetId, output: newLockedOutput);
        aad.addOutput(transferOutput);
      }
      final unlockedChange = isStakeableLockChange ? BigInt.zero : change;
      if (unlockedChange > BigInt.zero) {
        final newChangeOutput = PvmSECPTransferOutput(
          amount: unlockedChange,
          addresses: aad.getChangeAddresses(),
          lockTime: BigInt.zero,
          threshold: 1,
        );
        final transferOutput = PvmTransferableOutput(
          assetId: assetId,
          output: newChangeOutput,
        );
        aad.addChange(transferOutput);
      }
      final totalAmountSpent = assetAmount.getSpent();
      final stakeableLockedAmount = assetAmount.getStakeableLockSpent();
      final totalUnlockedSpent = totalAmountSpent - stakeableLockedAmount;
      final amountBurn = assetAmount.getBurn();
      final totalUnlockedAvailable = totalUnlockedSpent - amountBurn;
      final unlockedAmount = totalUnlockedAvailable - unlockedChange;
      if (unlockedAmount > BigInt.zero) {
        final newOutput = PvmSECPTransferOutput(
          amount: unlockedAmount,
          addresses: aad.getDestinations(),
          lockTime: lockTime,
          threshold: threshold,
        );
        final transferOutput = PvmTransferableOutput(
          assetId: assetId,
          output: newOutput,
        );
        aad.addOutput(transferOutput);
      }
    }
  }

  bool _feeCheck(BigInt? fee, Uint8List? feeAssetId) {
    return fee != null && fee > BigInt.zero && feeAssetId is Uint8List;
  }
}

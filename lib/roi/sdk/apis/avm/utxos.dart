import 'dart:typed_data';
import 'package:wallet/roi/sdk/apis/avm/base_tx.dart';
import 'package:wallet/roi/sdk/apis/avm/export_tx.dart';
import 'package:wallet/roi/sdk/apis/avm/import_tx.dart';

import 'package:wallet/roi/sdk/apis/avm/inputs.dart';
import 'package:wallet/roi/sdk/apis/avm/outputs.dart';
import 'package:wallet/roi/sdk/apis/avm/tx.dart';
import 'package:wallet/roi/sdk/common/asset_amount.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/common/utxos.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

class AvmUTXO extends StandardUTXO {
  @override
  String get typeName => "AvmUTXO";

  AvmUTXO(
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
    return AvmUTXO()..fromBuffer(toBuffer());
  }
}

class AvmAssetAmountDestination extends StandardAssetAmountDestination<
    AvmTransferableOutput, AvmTransferableInput> {
  AvmAssetAmountDestination(
      {List<Uint8List> destinations = const [],
      List<Uint8List> senders = const [],
      List<Uint8List> changeAddresses = const []})
      : super(
            destinations: destinations,
            senders: senders,
            changeAddresses: changeAddresses);
}

class AvmUTXOSet extends StandardUTXOSet<AvmUTXO> {
  @override
  String get typeName => "AvmUTXOSet";

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    final Map<String, AvmUTXO> utxos = {};
    for (final utxoId in (fields["utxos"] as Map<String, dynamic>).keys) {
      final utxoIdCleaned = Serialization.instance.decoder(
          utxoId, encoding, SerializedType.base58, SerializedType.base58);

      utxos["$utxoIdCleaned"] = AvmUTXO();
      (utxos["$utxoIdCleaned"] as AvmUTXO)
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
  AvmUTXO parseUTXO(dynamic utxo) {
    final avmUTXO = AvmUTXO();
    if (utxo is String) {
      avmUTXO.fromBuffer(cb58Decode(utxo));
    } else if (utxo is AvmUTXO) {
      avmUTXO.fromBuffer(utxo.toBuffer());
    } else {
      throw Exception(
          "Error - UTXO.parseUTXO: utxo parameter is not a UTXO or string");
    }
    return avmUTXO;
  }

  @override
  StandardUTXOSet<StandardUTXO> create({Map<String, dynamic> args = const {}}) {
    return AvmUTXOSet();
  }

  @override
  StandardUTXOSet<StandardUTXO> clone() {
    final newSet = create();
    final allUTXOs = getAllUTXOs();
    newSet.addArray(allUTXOs);
    return newSet;
  }

  AvmUnsignedTx buildBaseTx(
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

    final aad = AvmAssetAmountDestination(
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

    _getMinimumSpendable(aad,
        asOf: asOf, lockTime: lockTime, threshold: threshold);

    final baseTx = AvmBaseTx(
      networkId: networkId,
      blockchainId: blockchainId,
      outs: aad.getAllOutputs(),
      ins: aad.getInputs(),
      memo: memo,
    );

    return AvmUnsignedTx(transaction: baseTx);
  }

  AvmUnsignedTx buildImportTx(
      int networkId,
      Uint8List blockchainId,
      List<AvmUTXO> atomics,
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
    var ins = <AvmTransferableInput>[];
    var outs = <AvmTransferableOutput>[];
    fee ??= BigInt.zero;
    final importIns = <AvmTransferableInput>[];
    var feePaid = BigInt.zero;
    final feeAssetStr = feeAssetId == null ? null : hexEncode(feeAssetId);

    for (int i = 0; i < atomics.length; i++) {
      final utxo = atomics[i];
      final assetId = utxo.getAssetId();
      final output = utxo.getOutput() as AvmAmountOutput;
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
      final input = AvmSECPTransferInput(amount: amt);
      final xFerIn = AvmTransferableInput(
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
            args: AvmSECPTransferOutput.createArgs(
              amount: inFeeAmount,
              addresses: toAddresses,
              lockTime: lockTime,
              threshold: threshold,
            )) as AvmAmountOutput;
        final xFerOut = AvmTransferableOutput(
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
      final aad = AvmAssetAmountDestination(
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

    final importTx = AvmImportTx(
      networkId: networkId,
      blockchainId: blockchainId,
      outs: outs,
      ins: ins,
      memo: memo,
      sourceChain: sourceChain,
      importIns: importIns,
    );

    return AvmUnsignedTx(transaction: importTx);
  }

  AvmUnsignedTx buildExportTx(
      int networkId,
      Uint8List blockchainId,
      BigInt amount,
      Uint8List assetId,
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

    feeAssetId ??= assetId;

    final aad = AvmAssetAmountDestination(
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

    _getMinimumSpendable(aad,
        asOf: asOf, lockTime: lockTime, threshold: threshold);

    final exportTx = AvmExportTx(
      networkId: networkId,
      blockchainId: blockchainId,
      outs: aad.getChangeOutputs(),
      ins: aad.getInputs(),
      memo: memo,
      destinationChain: destinationChain,
      exportOuts: aad.getOutputs(),
    );

    return AvmUnsignedTx(transaction: exportTx);
  }

  void _getMinimumSpendable(AvmAssetAmountDestination aad,
      {BigInt? asOf, BigInt? lockTime, int threshold = 1}) {
    asOf ??= unixNow();
    lockTime ??= BigInt.zero;

    final utxoArray = getAllUTXOs();
    final outIds = {};

    for (int i = 0; i < utxoArray.length && !aad.canComplete(); i++) {
      final u = utxoArray[i];
      final assetKey = hexEncode(u.getAssetId());
      final fromAddresses = aad.getSenders();
      if (u.getOutput() is AvmAmountOutput &&
          aad.assetExists(assetKey) &&
          u.getOutput().meetsThreshold(fromAddresses, asOf: asOf)) {
        final am = aad.getAssetAmount(assetKey);
        if (!am.isFinished()) {
          final uOut = u.getOutput() as AvmAmountOutput;
          outIds[assetKey] = uOut.getOutputId();
          final amount = uOut.getAmount();
          am.spendAmount(amount);
          final txId = u.getTxId();
          final outputIdx = u.getOutputIdx();
          final input = AvmSECPTransferInput(amount: amount);
          final xFerIn = AvmTransferableInput(
            input: input,
            txId: txId,
            outputIdx: outputIdx,
            assetId: u.getAssetId(),
          );
          final spenders = uOut.getSpenders(fromAddresses, asOf: asOf);
          for (int j = 0; j < spenders.length; j++) {
            final spender = spenders[j];
            final idx = uOut.getAddressIdx(spender);
            if (idx == -1) {
              throw Exception(
                  "Error - UTXOSet.getMinimumSpendable: no such address in output: $spender");
            }
            xFerIn.getInput().addSignatureIdx(idx, spender);
          }
          aad.addInput(xFerIn);
        } else if (aad.assetExists(assetKey) &&
            u.getOutput() is! AvmAmountOutput) {
          continue;
        }
      }
    }
    if (!aad.canComplete()) {
      throw Exception(
          "Error - UTXOSet.getMinimumSpendable: insufficient funds to create the transaction");
    }
    final amounts = aad.getAmounts();
    for (int i = 0; i < amounts.length; i++) {
      final assetAmount = amounts[i];
      final assetKey = assetAmount.getAssetIdString();
      final amount = assetAmount.getAmount();
      if (amount > BigInt.zero) {
        final spendOut = selectOutputClass(
          outIds[assetKey],
          args: AvmSECPTransferOutput.createArgs(
              amount: amount,
              addresses: aad.getDestinations(),
              lockTime: lockTime,
              threshold: threshold),
        ) as AvmAmountOutput;

        final xFerOut = AvmTransferableOutput(
          assetId: assetAmount.getAssetId(),
          output: spendOut,
        );
        aad.addOutput(xFerOut);
      }
      final change = assetAmount.getChange();
      if (change > BigInt.zero) {
        final changeOut = selectOutputClass(
          outIds[assetKey],
          args: AvmSECPTransferOutput.createArgs(
              amount: change, addresses: aad.getChangeAddresses()),
        ) as AvmAmountOutput;
        final chgXFerOut = AvmTransferableOutput(
          assetId: assetAmount.getAssetId(),
          output: changeOut,
        );
        aad.addChange(chgXFerOut);
      }
    }
  }

  bool _feeCheck(BigInt? fee, Uint8List? feeAssetId) {
    return fee != null && fee > BigInt.zero && feeAssetId is Uint8List;
  }
}

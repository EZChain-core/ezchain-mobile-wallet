import 'dart:typed_data';
import 'package:wallet/roi/sdk/apis/evm/export_tx.dart';
import 'package:wallet/roi/sdk/apis/evm/import_tx.dart';

import 'package:wallet/roi/sdk/apis/evm/inputs.dart';
import 'package:wallet/roi/sdk/apis/evm/outputs.dart';
import 'package:wallet/roi/sdk/apis/evm/tx.dart';
import 'package:wallet/roi/sdk/common/asset_amount.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/common/utxos.dart';
import 'package:wallet/roi/sdk/utils/bintools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

class EvmUTXO extends StandardUTXO {
  @override
  String get typeName => "EvmUTXO";

  EvmUTXO(
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
    return EvmUTXO()..fromBuffer(toBuffer());
  }
}

class EvmAssetAmountDestination extends StandardAssetAmountDestination<
    EvmTransferableOutput, EvmTransferableInput> {
  EvmAssetAmountDestination(
      {List<Uint8List> destinations = const [],
      List<Uint8List> senders = const [],
      List<Uint8List> changeAddresses = const []})
      : super(
            destinations: destinations,
            senders: senders,
            changeAddresses: changeAddresses);
}

class EvmUTXOSet extends StandardUTXOSet<EvmUTXO> {
  @override
  String get typeName => "EvmUTXOSet";

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    final Map<String, EvmUTXO> utxos = {};
    for (final utxoId in (fields["utxos"] as Map<String, dynamic>).keys) {
      final utxoIdCleaned = Serialization.instance.decoder(
          utxoId, encoding, SerializedType.base58, SerializedType.base58);

      utxos["$utxoIdCleaned"] = EvmUTXO();
      (utxos["$utxoIdCleaned"] as EvmUTXO)
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
  EvmUTXO parseUTXO(dynamic utxo) {
    final evmUTXO = EvmUTXO();
    if (utxo is String) {
      evmUTXO.fromBuffer(cb58Decode(utxo));
    } else if (utxo is EvmUTXO) {
      evmUTXO.fromBuffer(utxo.toBuffer());
    } else {
      throw Exception(
          "Error - UTXO.parseUTXO: utxo parameter is not a UTXO or string");
    }
    return evmUTXO;
  }

  @override
  StandardUTXOSet<StandardUTXO> create({Map<String, dynamic> args = const {}}) {
    return EvmUTXOSet();
  }

  @override
  StandardUTXOSet<StandardUTXO> clone() {
    final newSet = create();
    final allUTXOs = getAllUTXOs();
    newSet.addArray(allUTXOs);
    return newSet;
  }

  EvmUnsignedTx buildImportTx(
    int networkId,
    Uint8List blockchainId,
    String toAddress,
    List<EvmUTXO> atomics, {
    Uint8List? sourceChain,
    BigInt? fee,
    Uint8List? feeAssetId,
  }) {
    final map = <String, String>{};
    var ins = <EvmTransferableInput>[];
    var outs = <EvmOutput>[];
    fee ??= BigInt.zero;
    var feePaid = BigInt.zero;
    final feeAssetIdHexStr = feeAssetId == null ? null : hexEncode(feeAssetId);
    for (int i = 0; i < atomics.length; i++) {
      final atomic = atomics[i];
      final assetIdBuff = atomic.getAssetId();
      final assetId = cb58Encode(assetIdBuff);
      final output = atomic.getOutput() as EvmAmountOutput;
      final amt = output.getAmount();
      var inFeeAmount = amt;
      final assetIdHexStr = hexEncode(assetIdBuff);
      if (feeAssetId != null &&
          fee > BigInt.zero &&
          feePaid < fee &&
          feeAssetIdHexStr == assetIdHexStr) {
        feePaid += inFeeAmount;
        if (feePaid >= fee) {
          inFeeAmount = feePaid - fee;
          feePaid = fee;
        } else {
          inFeeAmount = BigInt.zero;
        }
      }
      final txId = atomic.getTxId();
      final outputIdx = atomic.getOutputIdx();
      final input = EvmSECPTransferInput(amount: amt);
      final xFerIn = EvmTransferableInput(
        txId: txId,
        outputIdx: outputIdx,
        assetId: assetIdBuff,
        input: input,
      );
      final from = output.getAddresses();
      final spenders = output.getSpenders(from);
      for (int j = 0; j < spenders.length; j++) {
        final spender = spenders[j];
        final idx = output.getAddressIdx(spender);
        if (idx == -1) {
          throw Exception(
              "Error - UTXOSet.buildImportTx: no such address in output: $spender");
        }
        xFerIn.getInput().addSignatureIdx(idx, spender);
      }
      ins.add(xFerIn);
      if (map.containsKey(assetId)) {
        inFeeAmount =
            inFeeAmount + (BigInt.tryParse(map[assetId]!) ?? BigInt.zero);
      }
      map[assetId] = inFeeAmount.toString();
    }

    map.forEach((assetId, amount) {
      final evmOutput = EvmOutput(
        address: toAddress,
        amount: BigInt.parse(amount),
        assetId: cb58Decode(assetId),
      );

      outs.add(evmOutput);
    });

    final importTx = EvmImportTx(
      networkId: networkId,
      blockchainId: blockchainId,
      sourceChain: sourceChain,
      importIns: ins,
      outs: outs,
      fee: fee,
    );

    return EvmUnsignedTx(transaction: importTx);
  }

  EvmUnsignedTx buildExportTx(
    int networkId,
    Uint8List blockchainId,
    BigInt amount,
    Uint8List assetId,
    Uint8List destinationChain,
    List<Uint8List> toAddresses,
    List<Uint8List> fromAddresses, {
    List<Uint8List>? changeAddresses,
    BigInt? fee,
    Uint8List? feeAssetId,
    Uint8List? memo,
    BigInt? asOf,
    BigInt? lockTime,
    int threshold = 1,
  }) {
    asOf ??= unixNow();
    lockTime ??= BigInt.zero;

    changeAddresses ??= toAddresses;

    assert(amount > BigInt.zero);

    if (feeAssetId == null) {
      feeAssetId = assetId;
    } else if (hexEncode(feeAssetId) != hexEncode(assetId)) {
      throw Exception(
          "Error - UTXOSet.buildExportTx: feeAssetID must match avaxAssetID");
    }

    final ins = <EvmInput>[];

    final aad = EvmAssetAmountDestination(
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

    final exportTx = EvmExportTx(
      networkId: networkId,
      blockchainId: blockchainId,
      destinationChain: destinationChain,
      inputs: ins,
      exportedOutputs: aad.getOutputs(),
    );

    return EvmUnsignedTx(transaction: exportTx);
  }

  void _getMinimumSpendable(EvmAssetAmountDestination aad,
      {BigInt? asOf, BigInt? lockTime, int threshold = 1}) {
    asOf ??= unixNow();
    lockTime ??= BigInt.zero;

    final utxoArray = getAllUTXOs();
    final outIds = {};

    for (int i = 0; i < utxoArray.length && !aad.canComplete(); i++) {
      final u = utxoArray[i];
      final assetKey = hexEncode(u.getAssetId());
      final fromAddresses = aad.getSenders();
      if (u.getOutput() is EvmAmountOutput &&
          aad.assetExists(assetKey) &&
          u.getOutput().meetsThreshold(fromAddresses, asOf: asOf)) {
        final am = aad.getAssetAmount(assetKey);
        if (!am.isFinished()) {
          final uOut = u.getOutput() as EvmAmountOutput;
          outIds[assetKey] = uOut.getOutputId();
          final amount = uOut.getAmount();
          am.spendAmount(amount);
          final txId = u.getTxId();
          final outputIdx = u.getOutputIdx();
          final input = EvmSECPTransferInput(amount: amount);
          final xFerIn = EvmTransferableInput(
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
            u.getOutput() is! EvmAmountOutput) {
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
          args: EvmSECPTransferOutput.createArgs(
              amount: amount,
              addresses: aad.getDestinations(),
              lockTime: lockTime,
              threshold: threshold),
        ) as EvmAmountOutput;

        final xFerOut = EvmTransferableOutput(
          assetId: assetAmount.getAssetId(),
          output: spendOut,
        );
        aad.addOutput(xFerOut);
      }
      final change = assetAmount.getChange();
      if (change > BigInt.zero) {
        final changeOut = selectOutputClass(
          outIds[assetKey],
          args: EvmSECPTransferOutput.createArgs(
              amount: change, addresses: aad.getChangeAddresses()),
        ) as EvmAmountOutput;
        final chgXFerOut = EvmTransferableOutput(
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

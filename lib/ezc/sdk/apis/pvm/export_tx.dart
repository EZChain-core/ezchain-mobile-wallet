import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/pvm/base_tx.dart';
import 'package:wallet/ezc/sdk/apis/pvm/constants.dart';
import 'package:wallet/ezc/sdk/apis/pvm/inputs.dart';
import 'package:wallet/ezc/sdk/apis/pvm/outputs.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/common/output.dart';
import 'package:wallet/ezc/sdk/common/tx.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

class PvmExportTx extends PvmBaseTx {
  @override
  String get typeName => "PvmExportTx";

  Uint8List destinationChain = Uint8List(32);
  List<PvmTransferableOutput> exportOuts = [];
  Uint8List exportNumOuts = Uint8List(4);

  PvmExportTx({
    int networkId = defaultNetworkId,
    Uint8List? blockchainId,
    List<PvmTransferableOutput>? outs,
    List<PvmTransferableInput>? ins,
    Uint8List? memo,
    Uint8List? destinationChain,
    List<PvmTransferableOutput>? exportOuts,
  }) : super(
            networkId: networkId,
            blockchainId: blockchainId,
            outs: outs,
            ins: ins,
            memo: memo) {
    setTypeId(EXPORTTX);
    if (destinationChain != null) {
      this.destinationChain = destinationChain;
    }
    if (exportOuts != null) {
      this.exportOuts = exportOuts;
    }
  }

  factory PvmExportTx.fromArgs(Map<String, dynamic> args) {
    return PvmExportTx(
      networkId: args["networkId"] ?? defaultNetworkId,
      blockchainId: args["blockchainId"],
      outs: args["outs"],
      ins: args["ins"],
      memo: args["memo"],
      destinationChain: args["destinationChain"],
      exportOuts: args["exportOuts"],
    );
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "destinationChain": Serialization.instance.encoder(destinationChain,
          encoding, SerializedType.buffer, SerializedType.cb58),
      "exportOuts": exportOuts.map((e) => e.serialize(encoding: encoding))
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    destinationChain = Serialization.instance.decoder(
        fields["destinationChain"],
        encoding,
        SerializedType.cb58,
        SerializedType.buffer,
        args: [32]);
    exportOuts = (fields["exportOuts"] as List<dynamic>)
        .map((e) => PvmTransferableOutput()..deserialize(e, encoding: encoding))
        .toList();
    exportNumOuts.buffer.asByteData().setUint32(0, exportOuts.length);
  }

  @override
  int getTxType() {
    return getTypeId();
  }

  @override
  List<PvmTransferableOutput> getTotalOuts() {
    return [...getOuts(), ...getExportOutputs()];
  }

  List<PvmTransferableOutput> getExportOutputs() => exportOuts;

  BigInt getExportTotal() {
    var value = BigInt.zero;
    for (int i = 0; i < exportOuts.length; i++) {
      value += (exportOuts[i].getOutput() as PvmAmountOutput).getAmount();
    }

    return value;
  }

  Uint8List getDestinationChain() => destinationChain;

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    offset = super.fromBuffer(bytes, offset: offset);
    destinationChain = bytes.sublist(offset, offset + 32);
    offset += 32;
    exportNumOuts = bytes.sublist(offset, offset + 4);
    offset += 4;
    final numOutsNumber = exportNumOuts.buffer.asByteData().getUint32(0);
    for (int i = 0; i < numOutsNumber; i++) {
      final anOut = PvmTransferableOutput();
      offset = anOut.fromBuffer(bytes, offset: offset);
      exportOuts.add(anOut);
    }
    return offset;
  }

  @override
  Uint8List toBuffer() {
    exportNumOuts.buffer.asByteData().setUint32(0, exportOuts.length);
    final barr = [super.toBuffer(), destinationChain, exportNumOuts];
    exportOuts.sort(StandardParseableOutput.comparator());
    for (int i = 0; i < exportOuts.length; i++) {
      barr.add(exportOuts[i].toBuffer());
    }
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  @override
  StandardBaseTx<EZCKeyPair, EZCKeyChain> clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  PvmExportTx create({Map<String, dynamic> args = const {}}) {
    return PvmExportTx.fromArgs(args);
  }
}

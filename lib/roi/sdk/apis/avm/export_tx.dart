import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/avm/base_tx.dart';
import 'package:wallet/roi/sdk/apis/avm/constants.dart';
import 'package:wallet/roi/sdk/apis/avm/inputs.dart';
import 'package:wallet/roi/sdk/apis/avm/outputs.dart';
import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/common/tx.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

class AvmExportTx extends AvmBaseTx {
  @override
  String get typeName => "AvmExportTx";

  Uint8List destinationChain = Uint8List(32);
  List<AvmTransferableOutput> exportOuts = [];
  Uint8List exportNumOuts = Uint8List(4);

  AvmExportTx(
      {int networkId = defaultNetworkId,
      Uint8List? blockchainId,
      List<AvmTransferableOutput>? outs,
      List<AvmTransferableInput>? ins,
      Uint8List? memo,
      Uint8List? destinationChain,
      List<AvmTransferableOutput>? exportOuts})
      : super(
            networkId: networkId,
            blockchainId: blockchainId,
            outs: outs,
            ins: ins,
            memo: memo) {
    setCodecId(LATESTCODEC);
    if (destinationChain != null) {
      this.destinationChain = destinationChain;
    }
    if (exportOuts != null) {
      this.exportOuts = exportOuts;
    }
  }

  factory AvmExportTx.fromArgs(Map<String, dynamic> args) {
    return AvmExportTx(
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
          encoding, SerializedType.Buffer, SerializedType.cb58),
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
        SerializedType.Buffer,
        args: [32]);
    exportOuts = (fields["exportOuts"] as List<dynamic>)
        .map((e) => AvmTransferableOutput()..deserialize(e, encoding: encoding))
        .toList();
    exportNumOuts.buffer.asByteData().setUint32(0, exportOuts.length);
  }

  @override
  int getTypeId() {
    return getCodecId() == LATESTCODEC ? EXPORTTX : EXPORTTX_CODECONE;
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - ExportTx.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    super.setTypeId(codecId == 0 ? EXPORTTX : EXPORTTX_CODECONE);
  }

  @override
  int getTxType() {
    return getTypeId();
  }

  @override
  List<AvmTransferableOutput> getTotalOuts() {
    return [...getOuts(), ...getExportOutputs()];
  }

  List<AvmTransferableOutput> getExportOutputs() => exportOuts;

  BigInt getExportTotal() {
    var value = BigInt.zero;
    for (int i = 0; i < exportOuts.length; i++) {
      value += (exportOuts[i].getOutput() as AvmAmountOutput).getAmount();
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
      final anOut = AvmTransferableOutput();
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
  StandardBaseTx<ROIKeyPair, ROIKeyChain> clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  AvmExportTx create({Map<String, dynamic> args = const {}}) {
    return AvmExportTx.fromArgs(args);
  }
}

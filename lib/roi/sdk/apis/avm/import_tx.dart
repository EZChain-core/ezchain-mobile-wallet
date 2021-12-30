import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/avm/base_tx.dart';
import 'package:wallet/roi/sdk/apis/avm/constants.dart';
import 'package:wallet/roi/sdk/apis/avm/credentials.dart';
import 'package:wallet/roi/sdk/apis/avm/inputs.dart';
import 'package:wallet/roi/sdk/apis/avm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/avm/outputs.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';
import 'package:wallet/roi/sdk/common/input.dart';
import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/common/tx.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

class AvmImportTx extends AvmBaseTx {
  @override
  String get typeName => "AvmImportTx";

  Uint8List sourceChain = Uint8List(32);
  List<AvmTransferableInput> importIns = [];
  Uint8List importNumIns = Uint8List(4);

  AvmImportTx(
      {int networkId = defaultNetworkId,
      Uint8List? blockchainId,
      List<AvmTransferableOutput>? outs,
      List<AvmTransferableInput>? ins,
      Uint8List? memo,
      Uint8List? sourceChain,
      List<AvmTransferableInput>? importIns})
      : super(
            networkId: networkId,
            blockchainId: blockchainId,
            outs: outs,
            ins: ins,
            memo: memo) {
    if (sourceChain != null) {
      this.sourceChain = sourceChain;
    }
    if (importIns != null) {
      this.importIns = importIns;
    }
  }

  factory AvmImportTx.fromArgs(Map<String, dynamic> args) {
    return AvmImportTx(
      networkId: args["networkId"] ?? defaultNetworkId,
      blockchainId: args["blockchainId"],
      outs: args["outs"],
      ins: args["ins"],
      memo: args["memo"],
      sourceChain: args["sourceChain"],
      importIns: args["importIns"],
    );
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "sourceChain": Serialization.instance.encoder(
          sourceChain, encoding, SerializedType.Buffer, SerializedType.cb58),
      "importIns": importIns.map((e) => e.serialize(encoding: encoding))
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    sourceChain = Serialization.instance.decoder(fields["sourceChain"],
        encoding, SerializedType.cb58, SerializedType.Buffer,
        args: [32]);
    importIns = (fields["importIns"] as List<dynamic>)
        .map((e) => AvmTransferableInput()..deserialize(e, encoding: encoding))
        .toList();
    importNumIns.buffer.asByteData().setUint32(0, importIns.length);
  }

  @override
  int getTypeId() {
    return IMPORTTX;
  }

  @override
  int getTxType() {
    return getTypeId();
  }

  List<AvmTransferableInput> getImportInputs() => importIns;

  Uint8List getSourceChain() => sourceChain;

  @override
  List<Credential> sign(Uint8List msg, AvmKeyChain kc) {
    final signs = super.sign(msg, kc);
    for (int i = 0; i < importIns.length; i++) {
      final input = importIns[i].getInput();
      final credential = selectCredentialClass(input.getCredentialId());
      final signIdxs = input.getSigIdxs();
      for (int j = 0; j < signIdxs.length; j++) {
        final keyPair = kc.getKey(signIdxs[j].getSource());
        final signVal = keyPair!.sign(msg);
        final sig = Signature();
        sig.fromBuffer(signVal);
        credential.addSignature(sig);
      }
      signs.add(credential);
    }
    return signs;
  }

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    offset = super.fromBuffer(bytes, offset: offset);
    sourceChain = bytes.sublist(offset, offset + 32);
    offset += 32;
    importNumIns = bytes.sublist(offset, offset + 4);
    offset += 4;
    final numInsNumber = importNumIns.buffer.asByteData().getUint32(0);
    for (int i = 0; i < numInsNumber; i++) {
      final anIn = AvmTransferableInput();
      offset = anIn.fromBuffer(bytes, offset: offset);
      importIns.add(anIn);
    }
    return offset;
  }

  @override
  Uint8List toBuffer() {
    importNumIns.buffer.asByteData().setUint32(0, importIns.length);
    final barr = [super.toBuffer(), sourceChain, importNumIns];
    importIns.sort(StandardParseableInput.comparator());
    for (int i = 0; i < importIns.length; i++) {
      barr.add(importIns[i].toBuffer());
    }
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  @override
  StandardBaseTx<ROIKeyPair, ROIKeyChain> clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  AvmImportTx create({Map<String, dynamic> args = const {}}) {
    return AvmImportTx.fromArgs(args);
  }
}

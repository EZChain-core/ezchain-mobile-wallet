import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/pvm/base_tx.dart';
import 'package:wallet/ezc/sdk/apis/pvm/constants.dart';
import 'package:wallet/ezc/sdk/apis/pvm/credentials.dart';
import 'package:wallet/ezc/sdk/apis/pvm/inputs.dart';
import 'package:wallet/ezc/sdk/apis/pvm/outputs.dart';
import 'package:wallet/ezc/sdk/common/credentials.dart';
import 'package:wallet/ezc/sdk/common/input.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/common/tx.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

class PvmImportTx extends PvmBaseTx {
  @override
  String get typeName => "PvmImportTx";

  Uint8List sourceChain = Uint8List(32);
  List<PvmTransferableInput> importIns = [];
  Uint8List importNumIns = Uint8List(4);

  PvmImportTx({
    int networkId = defaultNetworkId,
    Uint8List? blockchainId,
    List<PvmTransferableOutput>? outs,
    List<PvmTransferableInput>? ins,
    Uint8List? memo,
    Uint8List? sourceChain,
    List<PvmTransferableInput>? importIns,
  }) : super(
            networkId: networkId,
            blockchainId: blockchainId,
            outs: outs,
            ins: ins,
            memo: memo) {
    setTypeId(IMPORTTX);
    if (sourceChain != null) {
      this.sourceChain = sourceChain;
    }
    if (importIns != null) {
      this.importIns = importIns;
    }
  }

  factory PvmImportTx.fromArgs(Map<String, dynamic> args) {
    return PvmImportTx(
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
        sourceChain,
        encoding,
        SerializedType.Buffer,
        SerializedType.cb58,
      ),
      "importIns": importIns.map((e) => e.serialize(encoding: encoding))
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    sourceChain = Serialization.instance.decoder(
      fields["sourceChain"],
      encoding,
      SerializedType.cb58,
      SerializedType.Buffer,
      args: [32],
    );
    importIns = (fields["importIns"] as List<dynamic>)
        .map((e) => PvmTransferableInput()..deserialize(e, encoding: encoding))
        .toList();
    importNumIns.buffer.asByteData().setUint32(0, importIns.length);
  }

  @override
  int getTxType() {
    return getTypeId();
  }

  List<PvmTransferableInput> getImportInputs() => importIns;

  Uint8List getSourceChain() => sourceChain;

  @override
  List<Credential> sign(Uint8List msg, EZCKeyChain kc) {
    final signs = super.sign(msg, kc);
    for (int i = 0; i < importIns.length; i++) {
      final input = importIns[i].getInput();
      final credential = selectCredentialClass(input.getCredentialId());
      final signIdxs = input.getSigIdxs();
      for (int j = 0; j < signIdxs.length; j++) {
        final keyPair = kc.getKey(signIdxs[j].getSource());
        if (keyPair == null) continue;
        final signVal = keyPair.sign(msg);
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
      final anIn = PvmTransferableInput();
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
  StandardBaseTx<EZCKeyPair, EZCKeyChain> clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  PvmImportTx create({Map<String, dynamic> args = const {}}) {
    return PvmImportTx.fromArgs(args);
  }
}

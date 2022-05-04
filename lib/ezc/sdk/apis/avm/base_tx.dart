import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/credentials.dart';
import 'package:wallet/ezc/sdk/apis/avm/inputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/tx.dart';
import 'package:wallet/ezc/sdk/common/credentials.dart';
import 'package:wallet/ezc/sdk/common/input.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/common/output.dart';
import 'package:wallet/ezc/sdk/common/tx.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

class AvmBaseTx extends StandardBaseTx<EZCKeyPair, EZCKeyChain> {
  @override
  String get typeName => "AvmBaseTx";

  AvmBaseTx({
    int networkId = defaultNetworkId,
    Uint8List? blockchainId,
    List<StandardTransferableOutput>? outs,
    List<StandardTransferableInput>? ins,
    Uint8List? memo,
  }) : super(
            networkId: networkId,
            blockchainId: blockchainId,
            outs: outs,
            ins: ins,
            memo: memo) {
    setCodecId(LATESTCODEC);
  }

  factory AvmBaseTx.fromArgs(Map<String, dynamic> args) {
    return AvmBaseTx(
      networkId: args["networkId"] ?? defaultNetworkId,
      blockchainId: args["blockchainId"],
      outs: args["outs"],
      ins: args["ins"],
      memo: args["memo"],
    );
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    outs = (fields["outs"] as List<AvmTransferableOutput>)
        .map((o) => AvmTransferableOutput()..deserialize(o, encoding: encoding))
        .toList();
    ins = (fields["ins"] as List<AvmTransferableInput>)
        .map((i) => AvmTransferableInput()..deserialize(i, encoding: encoding))
        .toList();
    numOuts = Serialization.instance.decoder(
      outs.length.toString(),
      SerializedEncoding.display,
      SerializedType.decimalString,
      SerializedType.buffer,
      args: [4],
    );
    numIns = Serialization.instance.decoder(
      ins.length.toString(),
      SerializedEncoding.display,
      SerializedType.decimalString,
      SerializedType.buffer,
      args: [4],
    );
  }

  @override
  int getTxType() {
    return super.getTypeId();
  }

  @override
  List<AvmTransferableOutput> getOuts() {
    return outs as List<AvmTransferableOutput>;
  }

  @override
  List<AvmTransferableInput> getIns() {
    return ins as List<AvmTransferableInput>;
  }

  @override
  List<AvmTransferableOutput> getTotalOuts() {
    return getOuts();
  }

  @override
  StandardBaseTx<EZCKeyPair, EZCKeyChain> clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  AvmBaseTx create({Map<String, dynamic> args = const {}}) {
    return AvmBaseTx.fromArgs(args);
  }

  @override
  StandardBaseTx<EZCKeyPair, EZCKeyChain> select(int id,
      {Map<String, dynamic> args = const {}}) {
    return selectTxClass(id, args: args);
  }

  @override
  List<Credential> sign(Uint8List msg, EZCKeyChain kc) {
    final signs = <Credential>[];
    for (int i = 0; i < ins.length; i++) {
      final input = ins[i];
      final credential =
          selectCredentialClass(input.getInput().getCredentialId());
      final signIdxs = input.getInput().getSigIdxs();
      for (int j = 0; j < signIdxs.length; j++) {
        final keyPair = kc.getKey(signIdxs[j].getSource());
        if (keyPair == null) continue;
        final signVal = keyPair.sign(msg);
        final signature = Signature()..fromBuffer(signVal);
        credential.addSignature(signature);
      }
      signs.add(credential);
    }
    return signs;
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - AvmBaseTx.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    super.setTypeId(codecId == 0 ? BASETX : BASETX_CODECONE);
  }

  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    networkId = bytes.sublist(offset, offset + 4);
    offset += 4;
    blockchainId = bytes.sublist(offset, offset + 32);
    offset += 32;
    numOuts = bytes.sublist(offset, offset + 4);
    offset += 4;
    final outCount = numOuts.buffer.asByteData().getUint32(0);
    outs.clear();
    for (int i = 0; i < outCount; i++) {
      final xFerOut = AvmTransferableOutput();
      offset = xFerOut.fromBuffer(bytes, offset: offset);
      outs.add(xFerOut);
    }
    numIns = bytes.sublist(offset, offset + 4);
    offset += 4;
    final inCount = numIns.buffer.asByteData().getUint32(0);
    ins.clear();
    for (int i = 0; i < inCount; i++) {
      final xFerIn = AvmTransferableInput();
      offset = xFerIn.fromBuffer(bytes, offset: offset);
      ins.add(xFerIn);
    }
    final memoLength =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    memo = bytes.sublist(offset, offset + memoLength);
    offset += memoLength;
    return offset;
  }
}

import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/pvm/constants.dart';
import 'package:wallet/roi/sdk/apis/pvm/credentials.dart';
import 'package:wallet/roi/sdk/apis/pvm/inputs.dart';
import 'package:wallet/roi/sdk/apis/pvm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/pvm/outputs.dart';
import 'package:wallet/roi/sdk/apis/pvm/tx.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';
import 'package:wallet/roi/sdk/common/input.dart';
import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/common/tx.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

class PvmBaseTx extends StandardBaseTx<PvmKeyPair, PvmKeyChain> {
  @override
  String get typeName => "PvmBaseTx";

  PvmBaseTx({
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
          memo: memo,
        ) {
    setTypeId(CREATESUBNETTX);
  }

  factory PvmBaseTx.fromArgs(Map<String, dynamic> args) {
    return PvmBaseTx(
        networkId: args["networkId"] ?? defaultNetworkId,
        blockchainId: args["blockchainId"],
        outs: args["outs"],
        ins: args["ins"],
        memo: args["memo"]);
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    outs = (fields["outs"] as List<PvmTransferableOutput>)
        .map((o) => PvmTransferableOutput()..deserialize(o, encoding: encoding))
        .toList();
    ins = (fields["ins"] as List<PvmTransferableInput>)
        .map((i) => PvmTransferableInput()..deserialize(i, encoding: encoding))
        .toList();
    numOuts = Uint8List(4);
    numOuts.buffer.asByteData().setUint32(0, outs.length);
    numIns = Uint8List(4);
    numIns.buffer.asByteData().setUint32(0, ins.length);
  }

  @override
  int getTxType() {
    return BASETX;
  }

  @override
  List<PvmTransferableOutput> getOuts() {
    return outs as List<PvmTransferableOutput>;
  }

  @override
  List<PvmTransferableInput> getIns() {
    return ins as List<PvmTransferableInput>;
  }

  @override
  List<PvmTransferableOutput> getTotalOuts() {
    return getOuts();
  }

  @override
  StandardBaseTx<ROIKeyPair, ROIKeyChain> clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  PvmBaseTx create({Map<String, dynamic> args = const {}}) {
    return PvmBaseTx.fromArgs(args);
  }

  @override
  StandardBaseTx<ROIKeyPair, ROIKeyChain> select(int id,
      {Map<String, dynamic> args = const {}}) {
    return selectTxClass(id, args: args);
  }

  @override
  List<Credential> sign(Uint8List msg, PvmKeyChain kc) {
    final signs = <Credential>[];
    for (int i = 0; i < ins.length; i++) {
      final input = ins[i];
      final credential =
          selectCredentialClass(input.getInput().getCredentialId());
      final signIdxs = input.getInput().getSigIdxs();
      for (int j = 0; j < signIdxs.length; j++) {
        final keyPair = kc.getKey(signIdxs[j].getSource());
        final signVal = keyPair!.sign(msg);
        final signature = Signature()..fromBuffer(signVal);
        credential.addSignature(signature);
      }
      signs.add(credential);
    }
    return signs;
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
      final xFerOut = PvmTransferableOutput();
      offset = xFerOut.fromBuffer(bytes, offset: offset);
      outs.add(xFerOut);
    }
    numIns = bytes.sublist(offset, offset + 4);
    offset += 4;
    final inCount = numIns.buffer.asByteData().getUint32(0);
    ins.clear();
    for (int i = 0; i < inCount; i++) {
      final xFerIn = PvmTransferableInput();
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

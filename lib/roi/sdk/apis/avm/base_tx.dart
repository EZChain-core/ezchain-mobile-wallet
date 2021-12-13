import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/avm/constants.dart';
import 'package:wallet/roi/sdk/apis/avm/credentials.dart';
import 'package:wallet/roi/sdk/apis/avm/input.dart';
import 'package:wallet/roi/sdk/apis/avm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/avm/output.dart';
import 'package:wallet/roi/sdk/apis/avm/tx.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';
import 'package:wallet/roi/sdk/common/input.dart';
import 'package:wallet/roi/sdk/common/keychain/base_key_chain.dart';
import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/common/tx.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

class AvmBaseTx extends StandardBaseTx<AvmKeyPair, AvmKeyChain> {
  @override
  String get typeName => "AvmBaseTx";

  @override
  int get codecId => LATESTCODEC;

  @override
  int get typeId => codecId == 0 ? BASETX : BASETX_CODECONE;

  AvmBaseTx(
      {int networkId = defaultNetworkId,
      Uint8List? blockchainId,
      List<StandardTransferableOutput>? outs,
      List<StandardTransferableInput>? ins,
      Uint8List? memo})
      : super(
            networkId: networkId,
            blockchainId: blockchainId,
            outs: outs,
            ins: ins,
            memo: memo);

  @override
  void deserialize(fields, SerializedEncoding encoding) {
    super.deserialize(fields, encoding);
    outs = (fields["outs"] as List<AvmTransferableOutput>)
        .map((o) => AvmTransferableOutput()..deserialize(o, encoding))
        .toList();
    ins = (fields["ins"] as List<AvmTransferableInput>)
        .map((i) => AvmTransferableInput()..deserialize(i, encoding))
        .toList();
    numOuts = Serialization.instance.decoder(
        outs.length.toString(),
        SerializedEncoding.display,
        SerializedType.decimalString,
        SerializedType.Buffer,
        args: [4]);
    numIns = Serialization.instance.decoder(
        ins.length.toString(),
        SerializedEncoding.display,
        SerializedType.decimalString,
        SerializedType.Buffer,
        args: [4]);
  }

  @override
  int getTxType() {
    return typeId;
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
  StandardBaseTx<ROIKeyPair, ROIKeyChain> clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  AvmBaseTx create({List args = const []}) {
    return AvmBaseTx(
      networkId: args.getOrNull(0),
      blockchainId: args.getOrNull(1),
      outs: args.getOrNull(2),
      ins: args.getOrNull(3),
      memo: args.getOrNull(4),
    );
  }

  @override
  StandardBaseTx<ROIKeyPair, ROIKeyChain> select(int id,
      {List args = const []}) {
    return selectTxClass(id, args: args);
  }

  @override
  List<Credential> sign(Uint8List msg, StandardKeyChain<AvmKeyPair> kc) {
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
      final xFerOut = AvmTransferableOutput()
        ..fromBuffer(bytes, offset: offset);
      outs.add(xFerOut);
    }
    numIns = bytes.sublist(offset, offset + 4);
    offset += 4;
    final inCount = numIns.buffer.asByteData().getUint32(0);
    ins.clear();
    for (int i = 0; i < inCount; i++) {
      final xFerIn = AvmTransferableInput()..fromBuffer(bytes, offset: offset);
      ins.add(xFerIn);
    }
    final memoLength =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    memo = bytes.sublist(offset, offset + memoLength);
    offset += memoLength;
    return offset;
  }

  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - BaseTx.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.codecId = codecId;
    super.typeId = codecId == 0 ? BASETX : BASETX_CODECONE;
  }
}

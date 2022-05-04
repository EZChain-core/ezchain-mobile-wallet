import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/avm/base_tx.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/credentials.dart';
import 'package:wallet/ezc/sdk/apis/avm/inputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/ops.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/common/credentials.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/common/tx.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

class AvmOperationTx extends AvmBaseTx {
  @override
  String get typeName => "AvmCreateAssetTx";

  var numOps = Uint8List(4);
  List<AvmTransferableOperation> ops = [];

  AvmOperationTx({
    int networkId = defaultNetworkId,
    Uint8List? blockchainId,
    List<AvmTransferableOutput>? outs,
    List<AvmTransferableInput>? ins,
    Uint8List? memo,
    List<AvmTransferableOperation>? ops,
  }) : super(
            networkId: networkId,
            blockchainId: blockchainId,
            outs: outs,
            ins: ins,
            memo: memo) {
    setCodecId(LATESTCODEC);
    if (ops != null) {
      this.ops = ops;
      numOps.buffer.asByteData().setUint32(0, ops.length);
    }
  }

  factory AvmOperationTx.fromArgs(Map<String, dynamic> args) {
    return AvmOperationTx(
      networkId: args["networkId"] ?? defaultNetworkId,
      blockchainId: args["blockchainId"],
      outs: args["outs"],
      ins: args["ins"],
      memo: args["memo"],
      ops: args["ops"],
    );
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {...fields, "ops": ops.map((e) => e.serialize(encoding: encoding))};
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    ops = (fields["ops"] as List<dynamic>)
        .map((e) =>
            AvmTransferableOperation()..deserialize(e, encoding: encoding))
        .toList();
    numOps.buffer.asByteData().setUint32(0, ops.length);
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - AvmOperationTx.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    setTypeId(codecId == 0 ? OPERATIONTX : OPERATIONTX_CODECONE);
  }

  @override
  int getTxType() {
    return super.getTypeId();
  }

  @override
  List<Credential> sign(Uint8List msg, EZCKeyChain kc) {
    final signs = super.sign(msg, kc);
    for (int i = 0; i < ops.length; i++) {
      final operation = ops[i].getOperation();
      final credential = selectCredentialClass(operation.getCredentialId());
      final signIdxs = operation.getSigIdxs();
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
    this.numOps = bytes.sublist(offset, offset + 4);
    offset += 4;
    final numOps = this.numOps.buffer.asByteData().getUint32(0);
    for (var i = 0; i < numOps; i++) {
      final op = AvmTransferableOperation();
      offset = op.fromBuffer(bytes, offset: offset);
      ops.add(op);
    }
    return offset;
  }

  @override
  Uint8List toBuffer() {
    numOps.buffer.asByteData().setUint32(0, ops.length);
    final barr = [super.toBuffer(), numOps];
    ops.sort(AvmTransferableOperation.comparator());
    for (var i = 0; i < ops.length; i++) {
      barr.add(ops[i].toBuffer());
    }
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  @override
  StandardBaseTx<EZCKeyPair, EZCKeyChain> clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  AvmOperationTx create({Map<String, dynamic> args = const {}}) {
    return AvmOperationTx.fromArgs(args);
  }

  List<AvmTransferableOperation> getOperations() {
    return ops;
  }
}

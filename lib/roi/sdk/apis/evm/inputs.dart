import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/evm/constants.dart';
import 'package:wallet/roi/sdk/apis/evm/outputs.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';
import 'package:wallet/roi/sdk/common/input.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

Input selectInputClass(int inputId, {Map<String, dynamic> args = const {}}) {
  switch (inputId) {
    case SECPINPUTID:
      return EvmSECPTransferInput.fromArgs(args);
    default:
      throw Exception("Error - SelectInputClass: unknown inputId = $inputId");
  }
}

class EvmTransferableInput extends StandardTransferableInput {
  @override
  String get typeName => "EvmTransferableInput";

  EvmTransferableInput(
      {Input? input, Uint8List? txId, Uint8List? outputIdx, Uint8List? assetId})
      : super(input: input, txId: txId, outputIdx: outputIdx, assetId: assetId);

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    input = selectInputClass(fields["input"]["typeId"]);
    input.deserialize(fields["input"], encoding: encoding);
  }

  @override
  int fromBuffer(Uint8List bytes, {int? offset}) {
    offset ??= 0;
    txId = bytes.sublist(offset, offset + 32);
    offset += 32;
    outputIdx = bytes.sublist(offset, offset + 4);
    offset += 4;
    assetId = bytes.sublist(offset, offset + ASSETIDLEN);
    offset += ASSETIDLEN;
    final inputId =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    input = selectInputClass(inputId);
    return input.fromBuffer(bytes, offset: offset);
  }

  int getCost() {
    final numSigs = getInput().getSigIdxs().length;
    return numSigs * (networks[1]!.c.costPerSignature ?? 0);
  }
}

abstract class EvmAmountInput extends StandardAmountInput {
  EvmAmountInput({BigInt? amount}) : super(amount: amount);

  @override
  Input select(int id, {Map<String, dynamic> args = const {}}) {
    return selectInputClass(id, args: args);
  }
}

class EvmSECPTransferInput extends EvmAmountInput {
  @override
  String get typeName => "EvmSECPTransferInput";

  EvmSECPTransferInput({BigInt? amount}) : super(amount: amount) {
    setCodecId(LATESTCODEC);
  }

  factory EvmSECPTransferInput.fromArgs(Map<String, dynamic> args) {
    return EvmSECPTransferInput(amount: args["amount"]);
  }

  @override
  Input clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  Input create({Map<String, dynamic> args = const {}}) {
    return EvmSECPTransferInput.fromArgs(args);
  }

  @override
  int getTypeId() => SECPINPUTID;

  @override
  int getInputId() => SECPINPUTID;

  @override
  int getCredentialId() => SECPCREDENTIAL;
}

class EvmInput extends EvmOutput {
  var nonce = Uint8List(8);
  var nonceValue = BigInt.zero;
  var sigCount = Uint8List(4);
  var sigIdxs = <SigIdx>[];

  EvmInput({dynamic address, dynamic amount, dynamic assetId, dynamic nonce})
      : super(address: address, amount: amount, assetId: assetId) {
    if (nonce != null) {
      if (amount is int) {
        nonceValue = BigInt.from(amount);
      } else {
        nonceValue = amount;
      }
      this.nonce = fromBNToBuffer(nonceValue, length: 8);
    }
  }

  factory EvmInput.fromArgs(Map<String, dynamic> args) {
    return EvmInput(
      address: args["address"],
      amount: args["amount"],
      assetId: args["assetId"],
      nonce: args["nonce"],
    );
  }

  @override
  Uint8List toBuffer() {
    return Uint8List.fromList([...super.toBuffer(), ...nonce]);
  }

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    offset = super.fromBuffer(bytes, offset: offset);
    nonce = bytes.sublist(offset, offset + 8);
    offset += 8;
    return offset;
  }

  @override
  String toString() => bufferToB58(toBuffer());

  @override
  EvmInput create({Map<String, dynamic> args = const {}}) {
    return EvmInput.fromArgs(args);
  }

  @override
  EvmInput clone() {
    return create()..fromBuffer(toBuffer());
  }

  List<SigIdx> getSigIdxs() => sigIdxs;

  void addSignatureIdx(int addressIdx, Uint8List address) {
    final sigIdx = SigIdx();
    final b = Uint8List(4);
    b.buffer.asByteData().setUint32(0, addressIdx);
    sigIdx.fromBuffer(b);
    sigIdx.setSource(address);
    sigIdxs.add(sigIdx);
    sigCount.buffer.asByteData().setUint32(0, sigIdxs.length);
  }

  BigInt getNonce() => nonceValue;

  int getCredentialId() => SECPCREDENTIAL;
}

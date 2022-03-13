import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/common/input.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

Input selectInputClass(int inputId, {Map<String, dynamic> args = const {}}) {
  switch (inputId) {
    case SECPINPUTID:
    case SECPINPUTID_CODECONE:
      return AvmSECPTransferInput.fromArgs(args);
    default:
      throw Exception("Error - SelectInputClass: unknown inputId = $inputId");
  }
}

class AvmTransferableInput extends StandardTransferableInput {
  @override
  String get typeName => "AvmTransferableInput";

  AvmTransferableInput(
      {Input? input, Uint8List? txId, Uint8List? outputIdx, Uint8List? assetId})
      : super(input: input, txId: txId, outputIdx: outputIdx, assetId: assetId);

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    input = selectInputClass(fields["input"]["_typeId"]);
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
}

abstract class AvmAmountInput extends StandardAmountInput {
  AvmAmountInput({BigInt? amount}) : super(amount: amount);

  @override
  Input select(int id, {Map<String, dynamic> args = const {}}) {
    return selectInputClass(id, args: args);
  }
}

class AvmSECPTransferInput extends AvmAmountInput {
  @override
  String get typeName => "AvmSECPTransferInput";

  AvmSECPTransferInput({BigInt? amount}) : super(amount: amount) {
    setCodecId(LATESTCODEC);
  }

  factory AvmSECPTransferInput.fromArgs(Map<String, dynamic> args) {
    return AvmSECPTransferInput(amount: args["amount"]);
  }

  @override
  Input clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  Input create({Map<String, dynamic> args = const {}}) {
    return AvmSECPTransferInput.fromArgs(args);
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - AvmSECPTransferInput.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    super.setTypeId(codecId == 0 ? SECPINPUTID : SECPINPUTID_CODECONE);
  }

  @override
  int getInputId() => super.getTypeId();

  @override
  int getCredentialId() {
    if (super.getCodecId() == 0) {
      return SECPCREDENTIAL;
    } else if (super.getCodecId() == 1) {
      return SECPCREDENTIAL_CODECONE;
    } else {
      throw Exception();
    }
  }
}

import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/avm/constants.dart';
import 'package:wallet/roi/sdk/common/input.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

Input selectInputClass(int inputId, {List<dynamic> args = const []}) {
  switch (inputId) {
    case SECPINPUTID:
    case SECPINPUTID_CODECONE:
      return AvmSECPTransferInput(amount: args.getOrNull(0));
    default:
      throw Exception("Error - SelectOutputClass: unknown inputId = $inputId");
  }
}

class AvmTransferableInput extends StandardTransferableInput {
  @override
  String get typeName => "TransferableInput";

  AvmTransferableInput(
      {Input? input, Uint8List? txId, Uint8List? outputIdx, Uint8List? assetId})
      : super(input: input, txId: txId, outputIdx: outputIdx, assetId: assetId);

  @override
  void deserialize(fields, SerializedEncoding encoding) {
    super.deserialize(fields, encoding);
    input = selectInputClass(fields["input"]["typeId"]);
    input.deserialize(fields["input"], encoding);
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
  Input select(int id, {List<dynamic> args = const []}) {
    return selectInputClass(id, args: args);
  }
}

class AvmSECPTransferInput extends AvmAmountInput {
  @override
  String get typeName => "SECPTransferInput";

  @override
  int get codecId => LATESTCODEC;

  @override
  int get typeId => codecId == 0 ? SECPINPUTID : SECPINPUTID_CODECONE;

  AvmSECPTransferInput({BigInt? amount}) : super(amount: amount);

  @override
  Input clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  Input create({List args = const []}) {
    return AvmSECPTransferInput(amount: args.getOrNull(0));
  }

  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - SECPTransferInput.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.codecId = codecId;
    super.typeId = codecId == 0 ? SECPINPUTID : SECPINPUTID_CODECONE;
  }

  @override
  int getInputId() => typeId;

  @override
  int getCredentialId() {
    if (codecId == 0) {
      return SECPCREDENTIAL;
    } else if (codecId == 1) {
      return SECPCREDENTIAL_CODECONE;
    } else {
      throw Exception();
    }
  }
}

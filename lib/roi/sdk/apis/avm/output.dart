import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/avm/constants.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

Output selectOutputClass(int outputId, {List<dynamic> args = const []}) {
  switch (outputId) {
    case SECPXFEROUTPUTID:
    case SECPXFEROUTPUTID_CODECONE:
      return AvmSECPTransferOutput(
          amount: args.getOrNull(0),
          lockTime: args.getOrNull(1),
          threshold: args.getOrNull(2),
          addresses: args.getOrNull(3));
    default:
      throw Exception(
          "Error - SelectOutputClass: unknown outputId = $outputId");
  }
}

class AvmTransferableOutput extends StandardTransferableOutput {
  AvmTransferableOutput({Uint8List? assetId, Output? output})
      : super(assetId: assetId, output: output);

  @override
  String get typeName => "TransferableOutput";

  @override
  void deserialize(fields, SerializedEncoding encoding) {
    super.deserialize(fields, encoding);
    output = selectOutputClass(fields["output"]["typeId"]);
    output.deserialize(fields["output"], encoding);
  }

  @override
  int fromBuffer(Uint8List bytes, {int? offset}) {
    offset ??= 0;
    assetId = bytes.sublist(offset, offset + ASSETIDLEN);
    offset += ASSETIDLEN;
    final outputId =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    output = selectOutputClass(outputId);
    return output.fromBuffer(bytes, offset: offset);
  }
}

abstract class AvmAmountOutput extends StandardAmountOutput {
  @override
  String get typeName => "AmountOutput";

  AvmAmountOutput(
      {BigInt? amount,
      List<Uint8List>? addresses,
      BigInt? lockTime,
      int? threshold})
      : super(
            amount: amount,
            addresses: addresses,
            lockTime: lockTime,
            threshold: threshold);

  @override
  AvmTransferableOutput makeTransferable(Uint8List assetId) {
    return AvmTransferableOutput(assetId: assetId, output: this);
  }

  @override
  Output select(int id, {List args = const []}) {
    return selectOutputClass(id);
  }
}

class AvmSECPTransferOutput extends AvmAmountOutput {
  @override
  String get typeName => "SECPTransferOutput";

  @override
  int get codecId => LATESTCODEC;

  @override
  int get typeId => codecId == 0 ? SECPXFEROUTPUTID : SECPXFEROUTPUTID_CODECONE;

  AvmSECPTransferOutput(
      {BigInt? amount,
      List<Uint8List>? addresses,
      BigInt? lockTime,
      int? threshold})
      : super(
            amount: amount,
            addresses: addresses,
            lockTime: lockTime,
            threshold: threshold);

  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - SECPTransferOutput.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.codecId = codecId;
    super.typeId = codecId == 0 ? SECPXFEROUTPUTID : SECPXFEROUTPUTID_CODECONE;
  }

  @override
  Output clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  Output create({List<dynamic> args = const []}) {
    return AvmSECPTransferOutput(
        amount: args.getOrNull(0),
        lockTime: args.getOrNull(1),
        threshold: args.getOrNull(2),
        addresses: args.getOrNull(3));
  }

  @override
  int getOutputId() => typeId;
}

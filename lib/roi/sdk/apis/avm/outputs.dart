import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/avm/constants.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

Output selectOutputClass(int outputId, {Map<String, dynamic> args = const {}}) {
  switch (outputId) {
    case SECPXFEROUTPUTID:
    case SECPXFEROUTPUTID_CODECONE:
      return AvmSECPTransferOutput.fromArgs(args);
    default:
      throw Exception(
          "Error - SelectOutputClass: unknown outputId = $outputId");
  }
}

class AvmTransferableOutput extends StandardTransferableOutput {
  AvmTransferableOutput({Uint8List? assetId, Output? output})
      : super(assetId: assetId, output: output);

  @override
  String get typeName => "AvmTransferableOutput";

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    output = selectOutputClass(fields["output"]["typeId"]);
    output.deserialize(fields["output"], encoding: encoding);
  }

  @override
  int fromBuffer(Uint8List bytes, {int? offset}) {
    offset ??= 0;
    assetId = bytes.sublist(offset, offset + ASSETIDLEN);
    offset += ASSETIDLEN;
    final outputId =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    output = selectOutputClass(outputId);
    return output.fromBuffer(bytes, offset: offset);
  }
}

abstract class AvmAmountOutput extends StandardAmountOutput {
  @override
  String get typeName => "AvmAmountOutput";

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
  Output select(int id, {Map<String, dynamic> args = const {}}) {
    return selectOutputClass(id, args: args);
  }
}

class AvmSECPTransferOutput extends AvmAmountOutput {
  @override
  String get typeName => "AvmSECPTransferOutput";

  AvmSECPTransferOutput(
      {BigInt? amount,
      List<Uint8List>? addresses,
      BigInt? lockTime,
      int? threshold})
      : super(
            amount: amount,
            addresses: addresses,
            lockTime: lockTime,
            threshold: threshold) {
    setCodecId(LATESTCODEC);
  }

  factory AvmSECPTransferOutput.fromArgs(Map<String, dynamic> args) {
    return AvmSECPTransferOutput(
        amount: args["amount"],
        lockTime: args["lockTime"],
        threshold: args["threshold"],
        addresses: args["addresses"]);
  }

  static Map<String, dynamic> createArgs(
      {BigInt? amount,
      List<Uint8List>? addresses,
      BigInt? lockTime,
      int? threshold}) {
    return {
      "amount": amount,
      "addresses": addresses,
      "lockTime": lockTime,
      "threshold": threshold
    };
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - SECPTransferOutput.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    super
        .setTypeId(codecId == 0 ? SECPXFEROUTPUTID : SECPXFEROUTPUTID_CODECONE);
  }

  @override
  Output clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  Output create({Map<String, dynamic> args = const {}}) {
    return AvmSECPTransferOutput.fromArgs(args);
  }

  @override
  int getOutputId() => super.getTypeId();
}

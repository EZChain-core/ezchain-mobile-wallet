import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/pvm/constants.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

Output selectOutputClass(int outputId, {Map<String, dynamic> args = const {}}) {
  switch (outputId) {
    case SECPXFEROUTPUTID:
      return PvmSECPTransferOutput.fromArgs(args);
    case STAKEABLELOCKOUTID:
      return PvmStakeableLockOut.fromArgs(args);
    case SECPOWNEROUTPUTID:
      return PvmSECPOwnerOutput.fromArgs(args);
    default:
      throw Exception(
          "Error - SelectOutputClass: unknown outputId = $outputId");
  }
}

class PvmTransferableOutput extends StandardTransferableOutput {
  PvmTransferableOutput({Uint8List? assetId, Output? output})
      : super(assetId: assetId, output: output);

  @override
  String get typeName => "PvmTransferableOutput";

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    output = selectOutputClass(fields["output"]["_typeId"]);
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

class PvmParseableOutput extends StandardParseableOutput {
  @override
  String get typeName => "PvmParseableOutput";

  PvmParseableOutput({Output? output}) : super(output: output);

  @override
  void deserialize(fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    output = selectOutputClass(fields["output"]["_typeId"]);
    output.deserialize(fields["output"], encoding: encoding);
  }

  @override
  int fromBuffer(Uint8List bytes, {int? offset}) {
    offset ??= 0;
    final outputId =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    output = selectOutputClass(outputId);
    return output.fromBuffer(bytes, offset: offset);
  }
}

abstract class PvmAmountOutput extends StandardAmountOutput {
  @override
  String get typeName => "PvmAmountOutput";

  PvmAmountOutput(
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
  PvmTransferableOutput makeTransferable(Uint8List assetId) {
    return PvmTransferableOutput(assetId: assetId, output: this);
  }

  @override
  Output select(int id, {Map<String, dynamic> args = const {}}) {
    return selectOutputClass(id, args: args);
  }

  static Map<String, dynamic> createArgs(
      {BigInt? amount,
      List<Uint8List>? addresses,
      BigInt? lockTime,
      int? threshold,
      BigInt? stakeableLockTime,
      PvmParseableOutput? transferableOutput}) {
    return {
      "amount": amount,
      "addresses": addresses,
      "lockTime": lockTime,
      "threshold": threshold,
      "stakeableLockTime": stakeableLockTime,
      "transferableOutput": transferableOutput
    };
  }
}

class PvmSECPTransferOutput extends PvmAmountOutput {
  @override
  String get typeName => "SECPTransferOutput";

  PvmSECPTransferOutput(
      {BigInt? amount,
      List<Uint8List>? addresses,
      BigInt? lockTime,
      int? threshold})
      : super(
            amount: amount,
            addresses: addresses,
            lockTime: lockTime,
            threshold: threshold) {
    setTypeId(SECPXFEROUTPUTID);
  }

  factory PvmSECPTransferOutput.fromArgs(Map<String, dynamic> args) {
    return PvmSECPTransferOutput(
        amount: args["amount"],
        lockTime: args["lockTime"],
        threshold: args["threshold"],
        addresses: args["addresses"]);
  }

  @override
  Output clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  Output create({Map<String, dynamic> args = const {}}) {
    return PvmSECPTransferOutput.fromArgs(args);
  }

  @override
  int getOutputId() => getTypeId();
}

class PvmStakeableLockOut extends PvmAmountOutput {
  @override
  String get typeName => "PvmStakeableLockOut";

  late Uint8List stakeableLockTime;
  late PvmParseableOutput transferableOutput;

  PvmStakeableLockOut(
      {BigInt? amount,
      List<Uint8List>? addresses,
      BigInt? lockTime,
      int? threshold,
      BigInt? stakeableLockTime,
      PvmParseableOutput? transferableOutput})
      : super(
            amount: amount,
            addresses: addresses,
            lockTime: lockTime,
            threshold: threshold) {
    setTypeId(STAKEABLELOCKOUTID);
    if (stakeableLockTime != null) {
      this.stakeableLockTime = fromBNToBuffer(stakeableLockTime);
    }
    if (transferableOutput != null) {
      this.transferableOutput = transferableOutput;
      _synchronize();
    }
  }

  factory PvmStakeableLockOut.fromArgs(Map<String, dynamic> args) {
    return PvmStakeableLockOut(
        amount: args["amount"],
        lockTime: args["lockTime"],
        threshold: args["threshold"],
        addresses: args["addresses"],
        stakeableLockTime: args["stakeableLockTime"],
        transferableOutput: args["transferableOutput"]);
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    final object = {
      ...fields,
      "stakeableLockTime": Serialization.instance.encoder(stakeableLockTime,
          encoding, SerializedType.Buffer, SerializedType.decimalString,
          args: [8]),
      "transferableOutput": transferableOutput.serialize(encoding: encoding)
    };
    object.remove("addresses");
    object.remove("lockTime");
    object.remove("threshold");
    object.remove("amount");
    return object;
  }

  @override
  void deserialize(fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    fields["addresses"] = [];
    fields["lockTime"] = "0";
    fields["threshold"] = "1";
    fields["amount"] = "99";
    super.deserialize(fields, encoding: encoding);
    stakeableLockTime = Serialization.instance.decoder(
        fields["stakeableLockTime"],
        encoding,
        SerializedType.decimalString,
        SerializedType.Buffer,
        args: [8]);
    transferableOutput = PvmParseableOutput();
    transferableOutput.deserialize(fields["transferableOutput"],
        encoding: encoding);
    _synchronize();
  }

  @override
  Output select(int id, {Map<String, dynamic> args = const {}}) {
    return selectOutputClass(id, args: args);
  }

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    stakeableLockTime = bytes.sublist(offset, offset + 8);
    offset += 8;
    transferableOutput = PvmParseableOutput();
    offset = transferableOutput.fromBuffer(bytes, offset: offset);
    _synchronize();
    return offset;
  }

  @override
  Uint8List toBuffer() {
    final xFerOutBuff = transferableOutput.toBuffer();
    return Uint8List.fromList([...stakeableLockTime, ...xFerOutBuff]);
  }

  @override
  int getOutputId() {
    return getTypeId();
  }

  @override
  Output create({Map<String, dynamic> args = const {}}) {
    return PvmStakeableLockOut.fromArgs(args);
  }

  @override
  Output clone() {
    return create()..fromBuffer(toBuffer());
  }

  void _synchronize() {
    final output = transferableOutput.getOutput() as PvmAmountOutput;
    addresses =
        output.getAddresses().map((a) => Address()..fromBuffer(a)).toList();
    numAddress = Uint8List(4);
    numAddress.buffer.asByteData().setUint32(0, addresses.length);
    lockTime = fromBNToBuffer(output.getLockTime(), length: 8);
    threshold = Uint8List(4);
    threshold.buffer.asByteData().setInt32(0, output.getThreshold());
    amount = fromBNToBuffer(output.getAmount(), length: 8);
    amountValue = output.getAmount();
  }

  BigInt getStakeableLockTime() {
    return fromBufferToBN(stakeableLockTime);
  }

  PvmParseableOutput getTransferableOutput() {
    return transferableOutput;
  }

  @override
  PvmTransferableOutput makeTransferable(Uint8List assetId) {
    return PvmTransferableOutput(assetId: assetId, output: this);
  }
}

class PvmSECPOwnerOutput extends Output {
  @override
  String get typeName => "PvmSECPOwnerOutput";

  PvmSECPOwnerOutput({
    BigInt? lockTime,
    int? threshold,
    List<Uint8List>? addresses,
  }) : super(
          lockTime: lockTime,
          threshold: threshold,
          addresses: addresses,
        ) {
    setTypeId(SECPOWNEROUTPUTID);
  }

  factory PvmSECPOwnerOutput.fromArgs(Map<String, dynamic> args) {
    return PvmSECPOwnerOutput(
      lockTime: args["lockTime"],
      threshold: args["threshold"],
      addresses: args["addresses"],
    );
  }

  @override
  int getOutputId() => getTypeId();

  @override
  PvmTransferableOutput makeTransferable(Uint8List assetId) {
    return PvmTransferableOutput(assetId: assetId, output: this);
  }

  @override
  Output create({Map<String, dynamic> args = const {}}) {
    return PvmSECPOwnerOutput.fromArgs(args);
  }

  @override
  Output clone() {
    return PvmSECPOwnerOutput()..fromBuffer(toBuffer());
  }

  @override
  Output select(int id, {Map<String, dynamic> args = const {}}) {
    return selectOutputClass(id, args: args);
  }
}

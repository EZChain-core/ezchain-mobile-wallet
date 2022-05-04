import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/pvm/constants.dart';
import 'package:wallet/ezc/sdk/common/input.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

Input selectInputClass(
  int inputId, {
  Map<String, dynamic> args = const {},
}) {
  switch (inputId) {
    case SECPINPUTID:
      return PvmSECPTransferInput.fromArgs(args);
    case STAKEABLELOCKINID:
      return PvmStakeableLockIn.fromArgs(args);
    default:
      throw Exception("Error - SelectInputClass: unknown inputId = $inputId");
  }
}

class PvmParseableInput extends StandardParseableInput {
  @override
  String get typeName => "PvmParseableInput";

  PvmParseableInput({Input? input}) : super(input: input);

  @override
  void deserialize(fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    input = selectInputClass(fields["input"]["_typeId"]);
    input.deserialize(fields["input"], encoding: encoding);
  }

  @override
  int fromBuffer(Uint8List bytes, {int? offset}) {
    offset ??= 0;
    final inputId =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    input = selectInputClass(inputId);
    return input.fromBuffer(bytes, offset: offset);
  }
}

class PvmTransferableInput extends StandardTransferableInput {
  @override
  String get typeName => "PvmTransferableInput";

  PvmTransferableInput(
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

abstract class PvmAmountInput extends StandardAmountInput {
  @override
  String get typeName => "PvmAmountInput";

  PvmAmountInput({BigInt? amount}) : super(amount: amount);

  @override
  Input select(int id, {Map<String, dynamic> args = const {}}) {
    return selectInputClass(id, args: args);
  }
}

class PvmSECPTransferInput extends PvmAmountInput {
  @override
  String get typeName => "PvmSECPTransferInput";

  PvmSECPTransferInput({BigInt? amount}) : super(amount: amount) {
    setTypeId(SECPINPUTID);
  }

  factory PvmSECPTransferInput.fromArgs(Map<String, dynamic> args) {
    return PvmSECPTransferInput(amount: args["amount"]);
  }

  @override
  Input clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  Input create({Map<String, dynamic> args = const {}}) {
    return PvmSECPTransferInput.fromArgs(args);
  }

  @override
  int getInputId() => getTypeId();

  @override
  int getCredentialId() {
    return SECPCREDENTIAL;
  }
}

class PvmStakeableLockIn extends PvmAmountInput {
  @override
  String get typeName => "PvmStakeableLockIn";

  late Uint8List stakeableLockTime;
  late PvmParseableInput transferableInput;

  PvmStakeableLockIn(
      {BigInt? amount,
      BigInt? stakeableLockTime,
      PvmParseableInput? transferableInput})
      : super(amount: amount) {
    setTypeId(STAKEABLELOCKINID);
    if (stakeableLockTime != null) {
      this.stakeableLockTime = fromBNToBuffer(stakeableLockTime, length: 8);
    }
    if (transferableInput != null) {
      this.transferableInput = transferableInput;
      _synchronize();
    }
  }

  factory PvmStakeableLockIn.fromArgs(Map<String, dynamic> args) {
    return PvmStakeableLockIn(
        amount: args["amount"],
        stakeableLockTime: args["stakeableLockTime"],
        transferableInput: args["transferableInput"]);
  }

  static Map<String, dynamic> createArgs(
      {BigInt? amount,
      BigInt? stakeableLockTime,
      PvmParseableInput? transferableInput}) {
    return {
      "amount": amount,
      "stakeableLockTime": stakeableLockTime,
      "transferableInput": transferableInput
    };
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    final object = {
      ...fields,
      "stakeableLockTime": Serialization.instance.encoder(stakeableLockTime,
          encoding, SerializedType.buffer, SerializedType.decimalString,
          args: [8]),
      "transferableInput": transferableInput.serialize(encoding: encoding)
    };
    object.remove("sigIdxs");
    object.remove("sigCount");
    object.remove("");
    object.remove("amount");
    return object;
  }

  @override
  void deserialize(fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    fields["sigIdxs"] = [];
    fields["sigCount"] = "0";
    fields["amount"] = "98";
    super.deserialize(fields, encoding: encoding);
    stakeableLockTime = Serialization.instance.decoder(
        fields["stakeableLockTime"],
        encoding,
        SerializedType.decimalString,
        SerializedType.buffer,
        args: [8]);
    transferableInput = PvmParseableInput();
    transferableInput.deserialize(
      fields["transferableInput"],
      encoding: encoding,
    );
    _synchronize();
  }

  void _synchronize() {
    final input = transferableInput.getInput() as PvmAmountInput;
    sigIdxs = input.getSigIdxs();
    sigCount = Uint8List(4);
    sigCount.buffer.asByteData().setUint32(0, sigIdxs.length);
    amount = fromBNToBuffer(input.getAmount(), length: 8);
    amountValue = input.getAmount();
  }

  BigInt getStakeableLocktime() {
    return fromBufferToBN(stakeableLockTime);
  }

  PvmParseableInput getTransferablInput() {
    return transferableInput;
  }

  @override
  int getInputId() {
    return getTypeId();
  }

  @override
  int getCredentialId() {
    return SECPCREDENTIAL;
  }

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    stakeableLockTime = bytes.sublist(offset, offset + 8);
    offset += 8;
    transferableInput = PvmParseableInput();
    offset = transferableInput.fromBuffer(bytes, offset: offset);
    _synchronize();
    return offset;
  }

  @override
  Uint8List toBuffer() {
    final xFerInBuff = transferableInput.toBuffer();
    return Uint8List.fromList([...stakeableLockTime, ...xFerInBuff]);
  }

  @override
  Input create({Map<String, dynamic> args = const {}}) {
    return PvmStakeableLockIn.fromArgs(args);
  }

  @override
  Input select(int id, {Map<String, dynamic> args = const {}}) {
    return selectInputClass(id, args: args);
  }

  @override
  Input clone() {
    return create()..fromBuffer(toBuffer());
  }
}

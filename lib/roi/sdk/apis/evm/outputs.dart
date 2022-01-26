import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/evm/constants.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/utils/bintools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

Output selectOutputClass(int outputId, {Map<String, dynamic> args = const {}}) {
  switch (outputId) {
    case SECPXFEROUTPUTID:
      return EvmSECPTransferOutput.fromArgs(args);
    default:
      throw Exception(
          "Error - SelectOutputClass: unknown outputId = $outputId");
  }
}

class EvmTransferableOutput extends StandardTransferableOutput {
  EvmTransferableOutput({Uint8List? assetId, Output? output})
      : super(assetId: assetId, output: output);

  @override
  String get typeName => "EvmTransferableOutput";

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

abstract class EvmAmountOutput extends StandardAmountOutput {
  @override
  String get typeName => "EvmAmountOutput";

  EvmAmountOutput(
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
  EvmTransferableOutput makeTransferable(Uint8List assetId) {
    return EvmTransferableOutput(assetId: assetId, output: this);
  }

  @override
  Output select(int id, {Map<String, dynamic> args = const {}}) {
    return selectOutputClass(id, args: args);
  }
}

class EvmSECPTransferOutput extends EvmAmountOutput {
  @override
  String get typeName => "EvmSECPTransferOutput";

  EvmSECPTransferOutput(
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

  factory EvmSECPTransferOutput.fromArgs(Map<String, dynamic> args) {
    return EvmSECPTransferOutput(
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
  Output clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  Output create({Map<String, dynamic> args = const {}}) {
    return EvmSECPTransferOutput.fromArgs(args);
  }

  @override
  int getOutputId() => getTypeId();
}

class EvmOutput {
  var address = Uint8List(20);
  var amount = Uint8List(8);
  var amountValue = BigInt.zero;
  var assetId = Uint8List(32);

  EvmOutput({dynamic address, dynamic amount, dynamic assetId}) {
    if (address != null && amount != null && assetId != null) {
      if (address is String) {
        final prefix = address.substring(0, 2);
        if (prefix == "0x") {
          address = address.split("x")[1];
        }
        address = hexDecode(address);
      }

      if (amount is int) {
        amountValue = BigInt.from(amount);
      } else {
        amountValue = amount;
      }

      if (assetId is! Uint8List) {
        assetId = cb58Decode(assetId);
      }
      this.address = address;
      this.amount = fromBNToBuffer(amountValue, length: 8);
      this.assetId = assetId;
    }
  }

  factory EvmOutput.fromArgs(Map<String, dynamic> args) {
    return EvmOutput(
      address: args["address"],
      amount: args["amount"],
      assetId: args["assetId"],
    );
  }

  @override
  String toString() => bufferToB58(toBuffer());

  EvmOutput create({Map<String, dynamic> args = const {}}) {
    return EvmOutput.fromArgs(args);
  }

  EvmOutput clone() {
    return create()..fromBuffer(toBuffer());
  }

  Uint8List getAddress() => address;

  String getAddressString() => hexEncode(address);

  BigInt getAmount() => amountValue;

  Uint8List getAssetId() => assetId;

  Uint8List toBuffer() {
    return Uint8List.fromList([...address, ...amount, ...assetId]);
  }

  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    address = bytes.sublist(offset, offset + 20);
    offset += 20;
    amount = bytes.sublist(offset, offset + 8);
    offset += 8;
    assetId = bytes.sublist(offset, offset + 32);
    offset += 32;
    return offset;
  }

  static int Function(EvmOutput a, EvmOutput b) comparator() {
    return (a, b) {
      var sortA = a.getAddress();
      var sortB = b.getAddress();
      if (sortA == sortB) {
        sortA = a.getAssetId();
        sortB = b.getAssetId();
      }
      return compare(sortA, sortB);
    };
  }
}

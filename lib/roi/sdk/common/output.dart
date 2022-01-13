import 'dart:convert';
import 'dart:typed_data';

import 'package:wallet/roi/sdk/common/nbytes.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

class Address extends NBytes {
  @override
  String get typeName => "Address";

  Address() : super(bytes: Uint8List(20), bSize: 20);

  @override
  int fromString(String b58Str) {
    final addressBuff = b58ToBuffer(b58Str);
    if (addressBuff.length == 24 && validateChecksum(addressBuff)) {
      final newBuff = addressBuff.sublist(0, addressBuff.length - 4);
      if (newBuff.length == 20) {
        setBuffer(newBuff);
      }
    } else if (addressBuff.length == 24) {
      throw Exception(
          "Error - Address.fromString: invalid checksum on address");
    } else if (addressBuff.length == 20) {
      setBuffer(addressBuff);
    } else {
      throw Exception("Error - Address.fromString: invalid address");
    }
    return getSize();
  }

  @override
  Address clone() {
    return Address()..fromBuffer(toBuffer());
  }

  static int Function(Address a, Address b) comparator() {
    return (a, b) {
      return compare(a.toBuffer(), b.toBuffer());
    };
  }
}

class OutputOwners extends Serializable {
  var lockTime = Uint8List(8);
  var threshold = Uint8List(4);
  var numAddress = Uint8List(4);
  List<Address> addresses = [];

  @override
  String get typeName => "OutputOwners";

  OutputOwners({BigInt? lockTime, int? threshold, List<Uint8List>? addresses}) {
    if (addresses != null) {
      final addrs = <Address>[];
      for (int i = 0; i < addresses.length; i++) {
        final address = Address();
        addrs.add(address);
        addrs[i].fromBuffer(addresses[i]);
      }
      this.addresses = addrs;
      this.addresses.sort(Address.comparator());
      numAddress.buffer.asByteData().setUint32(0, this.addresses.length);
    }

    this.threshold.buffer.asByteData().setUint32(0, threshold ??= 1);

    if (lockTime != null) {
      this.lockTime = fromBNToBuffer(lockTime, length: 8);
    }
  }

  @override
  dynamic serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    var fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "lockTime": Serialization.instance.encoder(lockTime, encoding,
          SerializedType.Buffer, SerializedType.decimalString,
          args: [8]),
      "threshold": Serialization.instance.encoder(threshold, encoding,
          SerializedType.Buffer, SerializedType.decimalString,
          args: [4]),
      "addresses":
          addresses.map((e) => e.serialize(encoding: encoding)).toList()
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    lockTime = Serialization.instance.decoder(fields["lockTime"], encoding,
        SerializedType.decimalString, SerializedType.Buffer,
        args: [8]);
    threshold = Serialization.instance.decoder(fields["threshold"], encoding,
        SerializedType.decimalString, SerializedType.Buffer,
        args: [4]);
    addresses = (fields["addresses"] as List<dynamic>)
        .map((e) => Address()..deserialize(e, encoding: encoding))
        .toList();
    numAddress.buffer.asByteData().setUint32(0, addresses.length);
  }

  @override
  String toString() {
    return bufferToB58(toBuffer());
  }

  int getThreshold() => threshold.buffer.asByteData().getUint32(0);

  BigInt getLockTime() => fromBufferToBN(lockTime);

  List<Uint8List> getAddresses() {
    final result = <Uint8List>[];
    for (int i = 0; i < addresses.length; i++) {
      result.add(addresses[i].toBuffer());
    }
    return result;
  }

  int getAddressIdx(Uint8List address) {
    for (int i = 0; i < addresses.length; i++) {
      final address1 = hexEncode(addresses[i].toBuffer());
      final address2 = hexEncode(address);
      if (address1 == address2) return i;
    }
    return -1;
  }

  Uint8List getAddress(int idx) {
    if (idx < addresses.length) {
      return addresses[idx].toBuffer();
    }
    throw Exception("Error - Output.getAddress: idx out of range");
  }

  bool meetsThreshold(List<Uint8List> addresses, {BigInt? asOf}) {
    final now = asOf ?? unixNow();
    final qualified = getSpenders(addresses, asOf: now);
    final threshold = this.threshold.buffer.asByteData().getUint32(0);
    if (qualified.length >= threshold) {
      return true;
    }
    return false;
  }

  List<Uint8List> getSpenders(List<Uint8List> addresses, {BigInt? asOf}) {
    final qualified = <Uint8List>[];
    final now = asOf ?? unixNow();
    final lockTime = fromBufferToBN(this.lockTime);
    if (now <= lockTime) {
      return qualified;
    }
    final threshold = this.threshold.buffer.asByteData().getUint32(0);
    for (int i = 0;
        i < this.addresses.length && qualified.length < threshold;
        i++) {
      for (int j = 0;
          j < addresses.length && qualified.length < threshold;
          j++) {
        final address1 = hexEncode(addresses[j]);
        final address2 = hexEncode(this.addresses[i].toBuffer());
        if (address1 == address2) {
          qualified.add(addresses[j]);
        }
      }
    }
    return qualified;
  }

  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    lockTime = bytes.sublist(offset, offset + 8);
    offset += 8;
    threshold = bytes.sublist(offset, offset + 4);
    offset += 4;
    this.numAddress = bytes.sublist(offset, offset + 4);
    offset += 4;
    final numAddress = this.numAddress.buffer.asByteData().getUint32(0);
    addresses = [];
    for (int i = 0; i < numAddress; i++) {
      final address = Address();
      offset = address.fromBuffer(bytes, offset: offset);
      addresses.add(address);
    }
    addresses.sort(Address.comparator());
    return offset;
  }

  Uint8List toBuffer() {
    addresses.sort(Address.comparator());
    numAddress.buffer.asByteData().setUint32(0, addresses.length);
    final barr = <Uint8List>[lockTime, threshold, numAddress];
    for (int i = 0; i < addresses.length; i++) {
      final b = addresses[i].toBuffer();
      barr.add(b);
    }

    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  static int Function(Output a, Output b) comparator() {
    return (a, b) {
      final aOutId = Uint8List(4);
      aOutId.buffer.asByteData().setUint32(0, a.getOutputId());
      final aBuff = a.toBuffer();

      final bOutId = Uint8List(4);
      bOutId.buffer.asByteData().setUint32(0, b.getOutputId());
      final bBuff = b.toBuffer();

      final aSort = Uint8List.fromList([...aOutId, ...aBuff]);
      final bSort = Uint8List.fromList([...bOutId, ...bBuff]);

      return compare(aSort, bSort);
    };
  }
}

abstract class Output extends OutputOwners {
  @override
  String get typeName => "Output";

  Output({
    BigInt? lockTime,
    int? threshold,
    List<Uint8List>? addresses,
  }) : super(
          lockTime: lockTime,
          threshold: threshold,
          addresses: addresses,
        );

  int getOutputId();

  Output clone();

  Output create({Map<String, dynamic> args = const {}});

  Output select(int id, {Map<String, dynamic> args = const {}});

  StandardTransferableOutput makeTransferable(Uint8List assetId);
}

abstract class StandardParseableOutput extends Serializable {
  late Output output;

  @override
  String get typeName => "StandardParseableOutput";

  StandardParseableOutput({Output? output}) {
    if (output != null) {
      this.output = output;
    }
  }

  int fromBuffer(Uint8List bytes, {int? offset});

  @override
  dynamic serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {...fields, "ouput": output.serialize(encoding: encoding)};
  }

  Uint8List toBuffer() {
    final outBuff = output.toBuffer();

    final outId = Uint8List(4);
    outId.buffer.asByteData().setUint32(0, output.getOutputId());

    return Uint8List.fromList([...outId, ...outBuff]);
  }

  Output getOutput() => output;

  static int Function(StandardParseableOutput a, StandardParseableOutput b)
      comparator() {
    return (a, b) {
      return compare(a.toBuffer(), b.toBuffer());
    };
  }
}

abstract class StandardTransferableOutput extends StandardParseableOutput {
  late Uint8List assetId;

  @override
  String get typeName => "StandardTransferableOutput";

  StandardTransferableOutput({Uint8List? assetId, Output? output})
      : super(output: output) {
    if (assetId != null) {
      this.assetId = assetId;
    }
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "assetId": Serialization.instance.encoder(
          assetId, encoding, SerializedType.Buffer, SerializedType.cb58)
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    assetId = Serialization.instance.decoder(
        fields["assetId"], encoding, SerializedType.cb58, SerializedType.Buffer,
        args: [32]);
  }

  @override
  Uint8List toBuffer() {
    final parseableBuff = super.toBuffer();
    return Uint8List.fromList([...assetId, ...parseableBuff]);
  }

  Uint8List getAssetId() => assetId;
}

abstract class StandardAmountOutput extends Output {
  var amount = Uint8List(8);
  var amountValue = BigInt.from(0);

  @override
  String get typeName => "StandardAmountOutput";

  StandardAmountOutput(
      {BigInt? amount,
      List<Uint8List>? addresses,
      BigInt? lockTime,
      int? threshold})
      : super(lockTime: lockTime, threshold: threshold, addresses: addresses) {
    if (amount != null) {
      amountValue = amount;
      this.amount = fromBNToBuffer(amount, length: 8);
    }
  }

  @override
  dynamic serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "amount": Serialization.instance.encoder(
          amount, encoding, SerializedType.Buffer, SerializedType.decimalString,
          args: [8])
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    amount = Serialization.instance.decoder(fields["amount"], encoding,
        SerializedType.decimalString, SerializedType.Buffer,
        args: [8]);
    amountValue = fromBufferToBN(amount);
  }

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    amount = bytes.sublist(offset, offset + 8);
    amountValue = fromBufferToBN(amount);
    offset += 8;
    return super.fromBuffer(bytes, offset: offset);
  }

  @override
  Uint8List toBuffer() {
    final superBuff = super.toBuffer();
    numAddress.buffer.asByteData().setUint32(0, addresses.length);
    return Uint8List.fromList([...amount, ...superBuff]);
  }

  BigInt getAmount() => amountValue;
}

abstract class BaseNFTOutput extends Output {
  var groupId = Uint8List(4);

  @override
  String get typeName => "BaseNFTOutput";

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "groupId": Serialization.instance.encoder(groupId, encoding,
          SerializedType.Buffer, SerializedType.decimalString,
          args: [4])
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    groupId = Serialization.instance.decoder(fields["groupId"], encoding,
        SerializedType.decimalString, SerializedType.Buffer,
        args: [4]);
  }

  int getGroupId() => groupId.buffer.asByteData().getUint32(0);
}

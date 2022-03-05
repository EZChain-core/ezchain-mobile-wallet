import 'dart:typed_data';

import 'package:wallet/ezc/sdk/common/credentials.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

abstract class Input extends Serializable {
  var sigCount = Uint8List(4);
  var sigIdxs = <SigIdx>[];

  @override
  String get typeName => "Input";

  int getInputId();

  int getCredentialId();

  Input clone();

  Input create({Map<String, dynamic> args = const {}});

  Input select(int id, {Map<String, dynamic> args = const {}});

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "sigIdxs": sigIdxs.map((e) => e.serialize(encoding: encoding))
    };
  }

  @override
  void deserialize(fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    sigIdxs = (fields["sigIdxs"] as List)
        .map((e) => SigIdx()..deserialize(e, encoding: encoding))
        .toList();
    sigCount.buffer.asByteData().setUint32(0, sigIdxs.length);
  }

  @override
  String toString() => bufferToB58(toBuffer());

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

  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    this.sigCount = bytes.sublist(offset, offset + 4);
    offset += 4;
    final sigCount = this.sigCount.buffer.asByteData().getUint32(0);
    sigIdxs.clear();
    for (int i = 0; i < sigCount; i++) {
      final sigIdx = SigIdx();
      final sigBuff = bytes.sublist(offset, offset + 4);
      sigIdx.fromBuffer(sigBuff);
      offset += 4;
      sigIdxs.add(sigIdx);
    }
    return offset;
  }

  Uint8List toBuffer() {
    sigCount.buffer.asByteData().setUint32(0, sigIdxs.length);
    final barr = [sigCount];
    for (int i = 0; i < sigIdxs.length; i++) {
      final b = sigIdxs[i].toBuffer();
      barr.add(b);
    }
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  static int Function(Input a, Input b) comparator() {
    return (a, b) {
      final aOutId = Uint8List(4);
      aOutId.buffer.asByteData().setUint32(0, a.getInputId());
      final aBuff = a.toBuffer();

      final bOutId = Uint8List(4);
      bOutId.buffer.asByteData().setUint32(0, b.getInputId());
      final bBuff = b.toBuffer();

      final aSort = Uint8List.fromList([...aOutId, ...aBuff]);
      final bSort = Uint8List.fromList([...bOutId, ...bBuff]);
      return compare(aSort, bSort);
    };
  }
}

abstract class StandardParseableInput extends Serializable {
  late Input input;

  StandardParseableInput({Input? input}) {
    if (input != null) {
      this.input = input;
    }
  }

  @override
  String get typeName => "StandardParseableInput";

  int fromBuffer(Uint8List bytes, {int? offset});

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {...fields, "input": input.serialize(encoding: encoding)};
  }

  Input getInput() => input;

  Uint8List toBuffer() {
    final inputBuff = input.toBuffer();
    final inputId = Uint8List(4);
    inputId.buffer.asByteData().setUint32(0, input.getInputId());
    return Uint8List.fromList([...inputId, ...inputBuff]);
  }

  static int Function(StandardParseableInput a, StandardParseableInput b)
      comparator() {
    return (a, b) {
      return compare(a.toBuffer(), b.toBuffer());
    };
  }
}

abstract class StandardTransferableInput extends StandardParseableInput {
  var txId = Uint8List(32);
  var outputIdx = Uint8List(4);
  var assetId = Uint8List(32);

  @override
  String get typeName => "StandardTransferableInput";

  StandardTransferableInput(
      {Input? input, Uint8List? txId, Uint8List? outputIdx, Uint8List? assetId})
      : super(input: input) {
    if (txId != null) {
      this.txId = txId;
    }
    if (outputIdx != null) {
      this.outputIdx = outputIdx;
    }
    if (assetId != null) {
      this.assetId = assetId;
    }
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "txId": Serialization.instance.encoder(
        txId,
        encoding,
        SerializedType.Buffer,
        SerializedType.cb58,
      ),
      "outputIdx": Serialization.instance.encoder(
        outputIdx,
        encoding,
        SerializedType.Buffer,
        SerializedType.decimalString,
      ),
      "assetId": Serialization.instance.encoder(
        assetId,
        encoding,
        SerializedType.Buffer,
        SerializedType.cb58,
      )
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    txId = Serialization.instance.decoder(
      fields["txId"],
      encoding,
      SerializedType.decimalString,
      SerializedType.Buffer,
      args: [4],
    );
    outputIdx = Serialization.instance.decoder(
      fields["outputIdx"],
      encoding,
      SerializedType.decimalString,
      SerializedType.Buffer,
      args: [4],
    );
    assetId = Serialization.instance.decoder(
      fields["assetId"],
      encoding,
      SerializedType.cb58,
      SerializedType.Buffer,
      args: [32],
    );
  }

  @override
  String toString() => bufferToB58(toBuffer());

  Uint8List getTxId() => txId;

  Uint8List getOutputIdx() => outputIdx;

  String getUTXOId() =>
      bufferToB58(Uint8List.fromList([...txId, ...outputIdx]));

  @override
  Input getInput() => input;

  Uint8List getAssetId() => assetId;

  @override
  Uint8List toBuffer() {
    final parseableBuff = super.toBuffer();
    return Uint8List.fromList(
        [...txId, ...outputIdx, ...assetId, ...parseableBuff]);
  }
}

abstract class StandardAmountInput extends Input {
  var amount = Uint8List(8);
  var amountValue = BigInt.from(0);

  @override
  String get typeName => "StandardAmountInput";

  StandardAmountInput({BigInt? amount}) {
    if (amount != null) {
      amountValue = amount;
      this.amount = fromBNToBuffer(amount, length: 8);
    }
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "amount": Serialization.instance.encoder(
        amount,
        encoding,
        SerializedType.Buffer,
        SerializedType.decimalString,
        args: [8],
      )
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    amount = Serialization.instance.decoder(
      fields["amount"],
      encoding,
      SerializedType.decimalString,
      SerializedType.Buffer,
      args: [8],
    );
    amountValue = fromBufferToBN(amount);
  }

  BigInt getAmount() => amountValue;

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
    return Uint8List.fromList([...amount, ...superBuff]);
  }
}

import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/common/output.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

class InitialStates extends Serializable {
  @override
  String get typeName => "InitialStates";

  final fxs = <int, List<Output>>{};

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    final flatFxs = <int, dynamic>{};
    for (final fxId in fxs.keys) {
      flatFxs[fxId] =
          fxs[fxId]!.map((output) => output.serialize(encoding: encoding));
    }
    return {
      ...fields,
      "fxs": flatFxs,
    };
  }

  @override
  void deserialize(fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);

    fxs.clear();
    final flatFxs = fields["fxs"] as Map<int, dynamic>;
    for (final fxId in flatFxs.keys) {
      fxs[fxId] = flatFxs[fxId]!.map((o) {
        final output = selectOutputClass(o["_typeId"]);
        output.deserialize(o, encoding: encoding);
        return output;
      });
    }
  }

  /// @param out The output state to add to the collection
  /// @param fxid The FxID that will be used for this output, default AVMfinalants.SECPFXID
  addOutput(Output out, {int fxId = SECPFXID}) {
    if (!fxs.containsKey(fxId)) {
      fxs[fxId] = [];
    }
    fxs[fxId]!.add(out);
  }

  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    final result = <int, List<Output>>{};
    final kLen = bytes.sublist(offset, offset + 4);
    offset += 4;
    final kLenNum = kLen.buffer.asByteData().getUint32(0);
    for (var i = 0; i < kLenNum; i++) {
      final fxIdBuff = bytes.sublist(offset, offset + 4);
      offset += 4;
      final fxId = fxIdBuff.buffer.asByteData().getUint32(0);
      result[fxId] = [];
      final stateLenBuff = bytes.sublist(offset, offset + 4);
      offset += 4;
      final stateLen = stateLenBuff.buffer.asByteData().getUint32(0);
      for (var j = 0; j < stateLen; j++) {
        final outputId =
            bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);

        offset += 4;
        final out = selectOutputClass(outputId);
        offset = out.fromBuffer(bytes, offset: offset);
        result[fxId]!.add(out);
      }
    }
    fxs.clear();
    fxs.addAll(result);
    return offset;
  }

  Uint8List toBuffer() {
    final buff = <Uint8List>[];
    final keys = fxs.keys.toList();
    keys.sort();
    final kLen = Uint8List(4);
    kLen.buffer.asByteData().setUint32(0, keys.length);
    buff.add(kLen);
    for (var i = 0; i < keys.length; i++) {
      final fxId = keys[i];
      final fxIdBuff = Uint8List(4);
      fxIdBuff.buffer.asByteData().setUint32(0, fxId);
      buff.add(fxIdBuff);
      final initialState = fxs[fxId]!;
      initialState.sort(OutputOwners.comparator());
      final stateLen = Uint8List(4);
      stateLen.buffer.asByteData().setUint32(0, initialState.length);
      buff.add(stateLen);
      for (var j = 0; j < initialState.length; j++) {
        final outputId = Uint8List(4);
        outputId.buffer
            .asByteData()
            .setUint32(0, initialState[j].getOutputId());
        buff.add(outputId);
        buff.add(initialState[j].toBuffer());
      }
    }
    return Uint8List.fromList(buff.expand((element) => element).toList());
  }
}

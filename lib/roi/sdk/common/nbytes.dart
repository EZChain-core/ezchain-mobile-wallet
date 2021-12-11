import 'dart:typed_data';

import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

abstract class NBytes extends Serializable {
  @override
  String get _typeName => "NBytes";

  var _bytes = Uint8List.fromList([]);
  var _bSize = 0;

  NBytes({required Uint8List bytes, required int bSize}) {
    _bytes = bytes;
    _bSize = bSize;
  }

  NBytes clone();

  @override
  dynamic serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "bSize": Serialization.instance.encoder(
          _bSize, encoding, SerializedType.number, SerializedType.decimalString,
          args: [4]),
      "bytes": Serialization.instance.encoder(
          _bytes, encoding, SerializedType.Buffer, SerializedType.hex,
          args: [_bSize])
    };
  }

  @override
  void deserialize(dynamic fields, SerializedEncoding encoding) {
    super.deserialize(fields, encoding);
    _bSize = Serialization.instance.decoder(fields["bSize"], encoding,
        SerializedType.decimalString, SerializedType.number,
        args: [4]);
    _bytes = Serialization.instance.decoder(
        fields["bytes"], encoding, SerializedType.hex, SerializedType.Buffer,
        args: [_bSize]);
  }

  @override
  String toString() => bufferToB58(toBuffer());

  int fromString(String b58Str) {
    try {
      fromBuffer(b58ToBuffer(b58Str));
    } catch (e) {}
    return _bSize;
  }

  int fromBuffer(Uint8List buff, {int offset = 0}) {
    try {
      if (buff.length - offset < _bSize) {
        throw Exception(
            "Error - NBytes.fromBuffer: not enough space available in buffer.");
      }
      _bytes = buff.sublist(offset, offset + _bSize);
    } catch (e) {}
    return offset + _bSize;
  }

  Uint8List toBuffer() => _bytes;

  void setBuffer(Uint8List bytes) {
    _bytes = bytes;
  }

  int getSize() => _bSize;
}

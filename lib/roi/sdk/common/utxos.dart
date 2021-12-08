import 'dart:typed_data';

import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

abstract class StandardUTXO extends Serializable {
  var codecId = Uint8List(2);
  var txId = Uint8List(32);
  var outputIdx = Uint8List(4);
  var assetId = Uint8List(32);
  Output? output;

  StandardUTXO(
      {int codecId = 0,
      Uint8List? txId,
      Uint8List? outputIdx,
      Uint8List? assetId,
      Output? output}) {}

  num fromBuffer(Uint8List bytes, num? offset);

  num fromString(String serialized);

  String toString();

  StandardUTXO clone();

  @override
  String get _typeName => "StandardUTXO";

  @override
  dynamic serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    var fields = super.serialize(encoding: encoding);
    return {
      "fields": fields,
      "codecId": Serialization.instance.encoder(codecId, encoding,
          SerializedType.Buffer, SerializedType.decimalString),
      "txId": Serialization.instance
          .encoder(txId, encoding, SerializedType.Buffer, SerializedType.cb58),
      "outputIdx": Serialization.instance.encoder(outputIdx, encoding,
          SerializedType.Buffer, SerializedType.decimalString),
      "assetId": Serialization.instance.encoder(
          assetId, encoding, SerializedType.Buffer, SerializedType.cb58),
      "output": output?.serialize(encoding: encoding)
    };
  }

  @override
  void deserialize(dynamic fields, SerializedEncoding encoding) {
    super.deserialize(fields, encoding);
    codecId = Serialization.instance.decoder(fields["fields"], encoding,
        SerializedType.decimalString, SerializedType.Buffer,
        args: [2]);
    txId = Serialization.instance.decoder(
        fields["txId"], encoding, SerializedType.cb58, SerializedType.Buffer,
        args: [32]);
    outputIdx = Serialization.instance.decoder(fields["outputIdx"], encoding,
        SerializedType.decimalString, SerializedType.Buffer,
        args: [4]);
    assetId = Serialization.instance.decoder(
        fields["assetId"], encoding, SerializedType.cb58, SerializedType.Buffer,
        args: [32]);
  }
}

abstract class StandardUTXOSet<UTXOClass extends StandardUTXO> {}

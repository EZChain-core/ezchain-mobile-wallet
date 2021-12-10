import 'dart:typed_data';

import 'package:wallet/roi/sdk/common/nbytes.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

class Address extends NBytes {
  @override
  String get _typeName => "Address";
}

class OutputOwners extends Serializable {
  var lockTime = Uint8List(8);
  var _threshold = Uint8List(4);
  var numAddress = Uint8List(4);
  List<Address> addresses = [];

  int get threshold => _threshold.buffer.asByteData().getUint32(0);

  @override
  String get _typeName => "OutputOwners";

  @override
  dynamic serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    var fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "lockTime": Serialization.instance.encoder(lockTime, encoding,
          SerializedType.Buffer, SerializedType.decimalString,
          args: [8]),
      "threshold": Serialization.instance.encoder(_threshold, encoding,
          SerializedType.Buffer, SerializedType.decimalString,
          args: [4]),
      "addresses": addresses.map((e) => e.serialize(encoding: encoding))
    };
  }

  @override
  void deserialize(dynamic fields, SerializedEncoding encoding) {
    super.deserialize(fields, encoding);
    lockTime = Serialization.instance.decoder(fields["lockTime"], encoding,
        SerializedType.decimalString, SerializedType.Buffer,
        args: [8]);
    _threshold = Serialization.instance.decoder(fields["threshold"], encoding,
        SerializedType.decimalString, SerializedType.Buffer,
        args: [4]);
    addresses = (fields["addresses"] as List<dynamic>)
        .map((e) => Address()..deserialize(e, encoding))
        .toList();
    final byteData = ByteData(4)..setUint32(0, addresses.length);
    numAddress = byteData.buffer.asUint8List();
  }

  Uint8List toBuffer() {
    throw UnimplementedError();
  }
}

abstract class Output extends OutputOwners {
  @override
  String get _typeName => "Output";

  int getOutputId();
}

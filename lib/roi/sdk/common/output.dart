import 'dart:typed_data';

import 'package:wallet/roi/sdk/common/nbytes.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

class Address extends NBytes {
  @override
  String get _typeName => "Address";
}

class OutputOwners extends Serializable {
  var lockTime = Uint8List(8);
  var threshold = Uint8List(4);
  var numAddress = Uint8List(4);
  List<Address> addresses = [];

  @override
  String get _typeName => "OutputOwners";

  @override
  dynamic serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    var fields = super.serialize(encoding: encoding);
    return {};
  }

  @override
  void deserialize(dynamic fields, SerializedEncoding encoding) {
    super.deserialize(fields, encoding);
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

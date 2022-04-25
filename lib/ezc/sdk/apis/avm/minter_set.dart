import 'dart:typed_data';

import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

class MinterSet extends Serializable {
  @override
  String get typeName => "Minterset";

  int threshold = 1;
  final minters = <Uint8List>[];

  MinterSet({this.threshold = 1, List<String> minters = const []}) : super() {
    final _minters = minters.map((minter) => stringToAddress(minter)).toList();
    this.minters.clear();
    this.minters.addAll(_minters);
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "threshold": Serialization.instance.encoder(
        threshold,
        encoding,
        SerializedType.number,
        SerializedType.decimalString,
        args: [4],
      ),
      "minters": minters.map(
        (m) => Serialization.instance.encoder(
          m,
          encoding,
          SerializedType.buffer,
          SerializedType.cb58,
          args: [20],
        ),
      )
    };
  }

  @override
  void deserialize(fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    threshold = Serialization.instance.decoder(
      fields["threshold"],
      encoding,
      SerializedType.decimalString,
      SerializedType.number,
      args: [4],
    );
    final minters = fields["minters"].map(
      (minter) => Serialization.instance.decoder(
        minter,
        encoding,
        SerializedType.cb58,
        SerializedType.bn,
        args: [20],
      ),
    );
    this.minters.clear();
    this.minters.addAll(minters);
  }
}

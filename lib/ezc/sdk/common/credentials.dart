import 'dart:typed_data';

import 'package:wallet/ezc/sdk/common/nbytes.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

class SigIdx extends NBytes {
  var source = Uint8List(20);

  @override
  String get typeName => "SigIdx";

  SigIdx() : super(bytes: Uint8List(4), bSize: 4);

  @override
  dynamic serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "source": Serialization.instance.encoder(
        source,
        encoding,
        SerializedType.buffer,
        SerializedType.hex,
      )
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    source = Serialization.instance.decoder(
      fields["source"],
      encoding,
      SerializedType.buffer,
      SerializedType.hex,
    );
  }

  @override
  NBytes clone() {
    return SigIdx()..fromBuffer(toBuffer());
  }

  void setSource(Uint8List source) {
    this.source = source;
  }

  Uint8List getSource() => source;
}

class Signature extends NBytes {
  @override
  String get typeName => "Signature";

  Signature() : super(bytes: Uint8List(65), bSize: 65);

  @override
  NBytes clone() {
    return Signature()..fromBuffer(toBuffer());
  }
}

abstract class Credential extends Serializable {
  List<Signature> sigArray = [];

  @override
  String get typeName => "Credential";

  int getCredentialId();

  Credential clone();

  Credential create({Map<String, dynamic> args = const {}});

  Credential select(int id, {Map<String, dynamic> args = const {}});

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "sigArray": sigArray.map((e) => e.serialize(encoding: encoding)).toList()
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    final sigArray = (fields["sigArray"] as List)
        .map((e) => Signature()..deserialize(e, encoding: encoding))
        .toList();
    this.sigArray = sigArray;
  }

  int addSignature(Signature signature) {
    sigArray.add(signature);
    return sigArray.length - 1;
  }

  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    final sigLen =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    sigArray.clear();
    for (int i = 0; i < sigLen; i++) {
      final sig = Signature();
      offset = sig.fromBuffer(bytes, offset: offset);
      sigArray.add(sig);
    }
    return offset;
  }

  Uint8List toBuffer() {
    final sigLen = Uint8List(4);
    sigLen.buffer.asByteData().setInt32(0, sigArray.length);
    final barr = <Uint8List>[sigLen];
    for (int i = 0; i < sigArray.length; i++) {
      final sigBuff = sigArray[i].toBuffer();
      barr.add(sigBuff);
    }
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  void setCodecID(int codecId) {}
}

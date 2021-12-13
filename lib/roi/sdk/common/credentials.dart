import 'dart:typed_data';

import 'package:wallet/roi/sdk/common/nbytes.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

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
      "source": Serialization.instance
          .encoder(source, encoding, SerializedType.Buffer, SerializedType.hex)
    };
  }

  @override
  void deserialize(dynamic fields, SerializedEncoding encoding) {
    super.deserialize(fields, encoding);
    source = Serialization.instance.decoder(
        fields["source"], encoding, SerializedType.Buffer, SerializedType.hex);
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
  final List<Signature> sigArray;

  @override
  String get typeName => "Credential";

  Credential({this.sigArray = const []});

  int getCredentialId();

  Credential clone();

  Credential create({List<dynamic> args = const []});

  Credential select(int id, {List<dynamic> args = const []});

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "sigArray": sigArray.map((e) => e.serialize(encoding: encoding))
    };
  }

  @override
  void deserialize(fields, SerializedEncoding encoding) {
    super.deserialize(fields, encoding);
    final sigArray = (fields["sigArray"] as List)
        .map((e) => Signature()..deserialize(e, encoding))
        .toList();
    this.sigArray.clear();
    this.sigArray.addAll(sigArray);
  }

  int addSignature(Signature signature) {
    sigArray.add(signature);
    return sigArray.length - 1;
  }

  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    final siglen =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    sigArray.clear();
    for (int i = 0; i < siglen; i++) {
      final sig = Signature()..fromBuffer(bytes, offset: offset);
      sigArray.add(sig);
    }
    return offset;
  }

  Uint8List toBuffer() {
    final siglen = Uint8List(4);
    siglen.buffer.asByteData().setInt32(0, sigArray.length);
    final barr = <Uint8List>[siglen];
    for (int i = 0; i < sigArray.length; i++) {
      final sigBuff = sigArray[i].toBuffer();
      barr.add(sigBuff);
    }
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  void setCodecID(int codecId) {}
}

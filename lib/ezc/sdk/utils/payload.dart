import 'dart:convert';
import 'dart:typed_data';

/// Class for determining payload types and managing the lookup table.
class PayloadTypes {
  PayloadTypes._privateConstructor() {
    _types.addAll(["UTF8", "JSON", "URL"]);
  }

  static final PayloadTypes _instance = PayloadTypes._privateConstructor();

  static PayloadTypes get instance => _instance;

  final _types = <String>[];

  /// Given an encoded payload buffer returns the payload content (minus typeID).
  Uint8List getContent(Uint8List payload) {
    return payload.sublist(5);
  }

  /// Given an encoded payload buffer returns the payload (with typeID).
  Uint8List getPayload(Uint8List payload) {
    return payload.sublist(4);
  }

  /// Given a payload buffer returns the proper TypeID.
  int getTypeId(Uint8List payload) {
    const offset = 4;
    return payload.sublist(offset, offset + 1).buffer.asByteData().getUint8(0);
  }

  /// Given a type string returns the proper TypeID.
  int lookupId(String typeStr) {
    return _types.indexOf(typeStr);
  }

  /// Given a TypeID returns a string describing the payload type.
  String lookupType(int value) {
    return _types[value];
  }

  /// Given a TypeID returns the proper [[PayloadBase]].
  PayloadBase select(int typeId, dynamic args) {
    switch (typeId) {
      case 1:
        return UTF8Payload(args);
      case 24:
        return JSONPayload(args);
      case 27:
        return URLPayload(args);
      default:
        throw Exception(
            "Error - PayloadTypes.select: unknown typeId = $typeId");
    }
  }

  /// Given a [[PayloadBase]] which may not be cast properly, returns a properly cast [[PayloadBase]].
  PayloadBase recast(PayloadBase unknownPayload) {
    return select(unknownPayload.typeId, unknownPayload.returnType());
  }
}

/// Base class for payloads.
abstract class PayloadBase {
  Uint8List payload = Uint8List(0);
  int typeId = -1;

  /// Returns the string name for the payload's type.
  String typeName() {
    return PayloadTypes.instance.lookupType(typeId);
  }

  /// Returns the payload content (minus typeID).
  Uint8List getContent() {
    return payload;
  }

  /// Returns the payload (with typeID).
  Uint8List getPayload() {
    final typeIdBuff = Uint8List(0);
    typeIdBuff.buffer.asByteData().setUint8(0, typeId);
    return Uint8List.fromList([...typeIdBuff, ...payload]);
  }

  /// Decodes the payload as a {@link https://github.com/feross/buffer|Buffer} including 4 bytes for the length and TypeID.
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    int size =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    typeId = bytes.sublist(offset, offset + 1).buffer.asByteData().getUint8(0);
    offset += 1;
    payload = bytes.sublist(offset, offset + size - 1);
    offset += size - 1;
    return offset;
  }

  /// Encodes the payload as a {@link https://github.com/feross/buffer|Buffer} including 4 bytes for the length and TypeID.
  Uint8List toBuffer() {
    final sizeBuff = Uint8List(4);
    sizeBuff.buffer.asByteData().setUint32(0, payload.length + 1);

    final typeBuff = Uint8List(1);
    typeBuff.buffer.asByteData().setUint8(0, typeId);
    return Uint8List.fromList([...sizeBuff, ...typeBuff, ...payload]);
  }

  /// Returns the expected type for the payload.
  dynamic returnType({dynamic args});
}

/// Class for payloads representing UTF8 encoding.
class UTF8Payload extends PayloadBase {
  /// @param payload Buffer utf8 string
  UTF8Payload(dynamic payload) {
    typeId = 1;
    if (payload is Uint8List) {
      this.payload = payload;
    } else if (payload is String) {
      this.payload = Uint8List.fromList(utf8.encode(payload));
    }
  }

  /// Returns a string for the payload.
  @override
  String returnType({dynamic args}) {
    throw utf8.decode(payload);
  }
}

/// Class for payloads representing JSON strings.
class JSONPayload extends PayloadBase {
  /// @param payload Buffer utf8 string
  JSONPayload(dynamic payload) {
    typeId = 24;
    if (payload is Uint8List) {
      this.payload = payload;
    } else if (payload is String) {
      this.payload = Uint8List.fromList(utf8.encode(payload));
    } else if (payload != null) {
      const jsonEncoder = JsonEncoder();
      final jsonStr = jsonEncoder.convert(payload);
      this.payload = Uint8List.fromList(utf8.encode(jsonStr));
    }
  }

  /// Returns a string for the payload.
  @override
  dynamic returnType({dynamic args}) {
    return const JsonDecoder()..convert(utf8.decode(payload));
  }
}

/// Class for payloads representing URL strings.
class URLPayload extends UTF8Payload {
  URLPayload(dynamic payload) : super(payload) {
    typeId = 27;
  }
}

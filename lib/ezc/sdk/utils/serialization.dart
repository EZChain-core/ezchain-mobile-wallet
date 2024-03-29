import 'dart:convert';
import 'dart:typed_data';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';

//ignore: constant_identifier_names
const SERIALIZATIONVERSION = 0;

abstract class Serializable {
  String get typeName;

  var _typeId = 0;

  var _codecId = 0;

  dynamic serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    return {
      "typeName": typeName,
      "_typeId": _typeId,
      "_codecId": _codecId,
    };
  }

  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    assert(fields["typeName"] is String);
    assert(fields["typeName"] == typeName);
    if (fields["_typeId"] != null) {
      assert(fields["_typeId"] is int);
      assert(fields["_typeId"] == _typeId);
    }
    if (fields["_codecId"] != null) {
      assert(fields["_codecId"] is int);
      assert(fields["_codecId"] == _codecId);
    }
  }

  String getTypeName() {
    return typeName;
  }

  int getCodecId() {
    return _codecId;
  }

  void setCodecId(int codecId) {
    _codecId = codecId;
  }

  int getTypeId() {
    return _typeId;
  }

  void setTypeId(int typeId) {
    _typeId = typeId;
  }
}

class Serialization {
  Serialization._privateConstructor();

  static final Serialization _instance = Serialization._privateConstructor();

  static Serialization get instance => _instance;

  dynamic bufferToType(
    Uint8List vb,
    SerializedType type, {
    List<dynamic> args = const [],
  }) {
    switch (type) {
      case SerializedType.hex:
        return hexEncode(vb);
      case SerializedType.bn:
        return bufferToBigInt16(vb);
      case SerializedType.buffer:
        if (args.length == 1 && args.first is int) {
          vb = Uint8List.fromList(
              hexDecode(hexEncode(vb).padLeft(args.first * 2, "0")));
        }
        return vb;
      case SerializedType.bech32:
        return addressToString(args[0], args[1], vb);
      case SerializedType.nodeId:
        return bufferToNodeIdString(vb);
      case SerializedType.privateKey:
        return bufferToPrivateKeyString(vb);
      case SerializedType.cb58:
        return cb58Encode(vb);
      case SerializedType.base58:
        return bufferToB58(vb);
      case SerializedType.base64:
        return base64Encode(vb);
      case SerializedType.decimalString:
        return bufferToBigInt16(vb).toRadixString(10);
      case SerializedType.number:
        return bufferToBigInt16(vb).toInt();
      case SerializedType.utf8:
        return utf8.decode(vb);
    }
  }

  Uint8List typeToBuffer(
    dynamic v,
    SerializedType type, {
    List<dynamic> args = const [],
  }) {
    switch (type) {
      case SerializedType.hex:
        var value = v as String;
        if (value.startsWith("0x")) {
          value = value.substring(2);
        }
        return Uint8List.fromList(hexDecode(value));
      case SerializedType.bn:
        final str = (v as BigInt).toRadixString(16);
        if (args.length == 1 && args.first is int) {
          return Uint8List.fromList(
              hexDecode(str.padLeft(args.first * 2, "0")));
        }
        return Uint8List.fromList(hexDecode(str));
      case SerializedType.buffer:
        return v;
      case SerializedType.bech32:
        final hrp = args.getOrNull(0);
        return stringToAddress(v, hrp: hrp);
      case SerializedType.nodeId:
        return nodeIdStringToBuffer(v);
      case SerializedType.privateKey:
        return privateKeyStringToBuffer(v);
      case SerializedType.cb58:
        return cb58Decode(v);
      case SerializedType.base58:
        return b58ToBuffer(v);
      case SerializedType.base64:
        return base64Decode(v);
      case SerializedType.decimalString:
        if (args.length == 1 && args.first is int) {}
        final str = BigInt.parse(v, radix: 10).toRadixString(16);
        if (args.length == 1 && args.first is int) {
          return Uint8List.fromList(
              hexDecode(str.padLeft(args.first * 2, "0")));
        }
        return Uint8List.fromList(hexDecode(str));
      case SerializedType.number:
        final str = BigInt.parse(v.toString(), radix: 10).toRadixString(16);
        if (args.length == 1 && args.first is int) {
          return Uint8List.fromList(
              hexDecode(str.padLeft(args.first * 2, "0")));
        }
        return Uint8List.fromList(hexDecode(str));
      case SerializedType.utf8:
        if (args.length == 1 && args.first is int) {
          final b = Uint8List(args.first);
          b.addAll(v);
          return b;
        }
        return Uint8List.fromList(utf8.encode(v));
    }
  }

  dynamic encoder(
    dynamic value,
    SerializedEncoding encoding,
    SerializedType inType,
    SerializedType outType, {
    List<dynamic> args = const [],
  }) {
    assert(value != null);
    if (encoding != SerializedEncoding.display) {
      outType = SerializedType.values
          .firstWhere((element) => element.type == encoding.type);
    }
    final vb = typeToBuffer(value, inType, args: args);
    return bufferToType(vb, outType, args: args);
  }

  dynamic decoder(
    dynamic value,
    SerializedEncoding encoding,
    SerializedType inType,
    SerializedType outType, {
    List<dynamic> args = const [],
  }) {
    assert(value != null);
    if (encoding != SerializedEncoding.display) {
      inType = SerializedType.values
          .firstWhere((element) => element.type == encoding.type);
    }
    final vb = typeToBuffer(value, inType, args: args);
    return bufferToType(vb, outType, args: args);
  }

  Serialized serialize(
    Serializable serialize,
    String vm,
    SerializedEncoding encoding,
    String? notes,
  ) {
    notes ??= serialize.typeName;
    return Serialized(
        vm: vm,
        encoding: encoding,
        version: SERIALIZATIONVERSION,
        notes: notes,
        fields: serialize.serialize(encoding: encoding));
  }

  void deserialize(Serialized input, Serializable output) {
    output.deserialize(input.fields, encoding: input.encoding);
  }
}

class Serialized {
  final String vm;
  final SerializedEncoding encoding;
  final int version;
  final String notes;
  final dynamic fields;

  Serialized(
      {required this.vm,
      required this.encoding,
      required this.version,
      required this.notes,
      required this.fields});
}

enum SerializedType {
  hex,
  bn,
  buffer,
  bech32,
  nodeId,
  privateKey,
  cb58,
  base58,
  base64,
  decimalString,
  number,
  utf8
}

extension SerializedTypeString on SerializedType {
  String get type {
    switch (this) {
      case SerializedType.hex:
        return "hex";
      case SerializedType.bn:
        return "BN";
      case SerializedType.buffer:
        return "Buffer";
      case SerializedType.bech32:
        return "bech32";
      case SerializedType.nodeId:
        return "nodeID";
      case SerializedType.privateKey:
        return "privateKey";
      case SerializedType.cb58:
        return "cb58";
      case SerializedType.base58:
        return "base58";
      case SerializedType.base64:
        return "base64";
      case SerializedType.decimalString:
        return "decimalString";
      case SerializedType.number:
        return "number";
      case SerializedType.utf8:
        return "utf8";
    }
  }
}

enum SerializedEncoding {
  hex,
  cb58,
  base58,
  base64,
  decimalString,
  number,
  utf8,
  display,
}

extension SerializedEncodingString on SerializedEncoding {
  String get type {
    switch (this) {
      case SerializedEncoding.hex:
        return "hex";
      case SerializedEncoding.cb58:
        return "cb58";
      case SerializedEncoding.base58:
        return "base58";
      case SerializedEncoding.base64:
        return "base64";
      case SerializedEncoding.decimalString:
        return "decimalString";
      case SerializedEncoding.number:
        return "number";
      case SerializedEncoding.utf8:
        return "utf8";
      case SerializedEncoding.display:
        return "display";
    }
  }
}

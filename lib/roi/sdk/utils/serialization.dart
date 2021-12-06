const SERIALIZATIONVERSION = 0;

abstract class Serializable {
  String get typeName;

  int get typeId;

  int get codecId;

  Object sanitizeObject(Object object) {
    return {};
  }

  Object serialize(SerializedEncoding? encoding) {
    return {};
  }

  void deserialize(Object fields, SerializedEncoding? encoding) {}
}

class Serialization {}

enum SerializedType {
  hex,
  BN,
  buffer,
  bech32,
  nodeID,
  privateKey,
  cb58,
  base58,
  base64,
  decimalString,
  number,
  utf8
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

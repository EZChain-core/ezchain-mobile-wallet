import 'dart:convert';
import 'dart:typed_data';
import 'package:collection/collection.dart';

import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

/// Class for determining payload types and managing the lookup table.
class PayloadTypes {
  PayloadTypes._privateConstructor() {
    _types[0] = "BIN";
    _types[1] = "UTF8";
    _types[2] = "HEXSTR";
    _types[3] = "B58STR";
    _types[4] = "B64STR";
    _types[5] = "BIGNUM";
    _types[6] = "XCHAINADDR";
    _types[7] = "PCHAINADDR";
    _types[8] = "CCHAINADDR";
    _types[9] = "TXID";
    _types[10] = "ASSETID";
    _types[11] = "UTXOID";
    _types[12] = "NFTID";
    _types[13] = "SUBNETID";
    _types[14] = "CHAINID";
    _types[15] = "NODEID";
    _types[16] = "SECPSIG";
    _types[17] = "SECPENC";
    _types[18] = "JPEG";
    _types[19] = "PNG";
    _types[20] = "BMP";
    _types[21] = "ICO";
    _types[22] = "SVG";
    _types[23] = "CSV";
    _types[24] = "JSON";
    _types[25] = "YAML";
    _types[26] = "EMAIL";
    _types[27] = "URL";
    _types[28] = "IPFS";
    _types[29] = "ONION";
    _types[30] = "MAGNET";
  }

  static final PayloadTypes _instance = PayloadTypes._privateConstructor();

  static PayloadTypes get instance => _instance;

  final _types = <int, String>{};

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
  int? lookupId(String typeStr) {
    return _types.entries
        .firstWhereOrNull((element) => element.value == typeStr)
        ?.key;
  }

  /// Given a TypeID returns a string describing the payload type.
  String? lookupType(int value) {
    return _types[value];
  }

  /// Given a TypeID returns the proper [[PayloadBase]].
  PayloadBase select(int typeId, dynamic args) {
    switch (typeId) {
      case 0:
        return BINPayload(payload: args, typeId: typeId);
      case 1:
        return UTF8Payload(payload: args, typeId: typeId);
      case 2:
        return HEXSTRPayload(args);
      case 3:
        return B58STRPayload(payload: args, typeId: typeId);
      case 4:
        return B64STRPayload(args);
      case 5:
        return BIGNUMPayload(args);
      case 6:
        return XCHAINADDRPayload(args);
      case 7:
        return PCHAINADDRPayload(args);
      case 8:
        return CCHAINADDRPayload(args);
      case 9:
        return TXIDPayload(args);
      case 10:
        return ASSETIDPayload(args);
      case 11:
        return UTXOIDPayload(payload: args, typeId: typeId);
      case 12:
        return NFTIDPayload(args);
      case 13:
        return SUBNETIDPayload(args);
      case 14:
        return CHAINIDPayload(args);
      case 15:
        return NODEIDPayload(args);
      case 16:
        return SECPSIGPayload(args);
      case 17:
        return SECPENCPayload(args);
      case 18:
        return JPEGPayload(args);
      case 19:
        return PNGPayload(args);
      case 20:
        return BMPPayload(args);
      case 21:
        return ICOPayload(args);
      case 22:
        return SVGPayload(args);
      case 23:
        return CSVPayload(args);
      case 24:
        return JSONPayload(args);
      case 25:
        return YAMLPayload(args);
      case 26:
        return EMAILPayload(args);
      case 27:
        return URLPayload(args);
      case 28:
        return IPFSPayload(args);
      case 29:
        return ONIONPayload(args);
      case 30:
        return MAGNETPayload(args);
      default:
        throw Exception(
            "Error - PayloadTypes.select: unknown typeId = $typeId");
    }
  }

  /// Given a [[PayloadBase]] which may not be cast properly, returns a properly cast [[PayloadBase]].
  PayloadBase recast(PayloadBase unknownPayload) {
    return select(unknownPayload.typeId, unknownPayload.getContentType());
  }
}

/// Base class for payloads.
abstract class PayloadBase {
  Uint8List _payload = Uint8List(0);
  int _typeId = -1;

  PayloadBase(this._typeId);

  int get typeId => _typeId;

  /// Returns the string name for the payload's type.
  String? getTypeName() {
    return PayloadTypes.instance.lookupType(_typeId);
  }

  /// Returns the payload content (minus typeID).
  Uint8List getContent() {
    return _payload;
  }

  setPayload(Uint8List payload) {
    _payload = payload;
  }

  /// Returns the payload (with typeID).
  Uint8List getPayload() {
    final typeIdBuff = Uint8List(1);
    typeIdBuff.buffer.asByteData().setUint8(0, _typeId);
    return Uint8List.fromList([...typeIdBuff, ..._payload]);
  }

  /// Decodes the payload as a {@link https://github.com/feross/buffer|Buffer} including 4 bytes for the length and TypeID.
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    int size =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    _typeId = bytes.sublist(offset, offset + 1).buffer.asByteData().getUint8(0);
    offset += 1;
    _payload = bytes.sublist(offset, offset + size - 1);
    offset += size - 1;
    return offset;
  }

  /// Encodes the payload as a {@link https://github.com/feross/buffer|Buffer} including 4 bytes for the length and TypeID.
  Uint8List toBuffer() {
    final sizeBuff = Uint8List(4);
    sizeBuff.buffer.asByteData().setUint32(0, _payload.length + 1);

    final typeBuff = Uint8List(1);
    typeBuff.buffer.asByteData().setUint8(0, _typeId);
    return Uint8List.fromList([...sizeBuff, ...typeBuff, ..._payload]);
  }

  /// Returns the expected type for the payload.
  dynamic getContentType();
}

/// Class for payloads representing simple binary blobs.
class BINPayload extends PayloadBase {
  /// @param payload Buffer or cb58 encoded string
  BINPayload({required dynamic payload, int? typeId}) : super(typeId ?? 0) {
    if (payload is Uint8List) {
      setPayload(payload);
    } else if (payload is String) {
      setPayload(b58ToBuffer(payload));
    }
  }

  /// Returns a string for the payload.
  @override
  String getContentType() {
    return utf8.decode(getContent(), allowMalformed: true);
  }
}

/// Class for payloads representing UTF8 encoding.
class UTF8Payload extends PayloadBase {
  /// @param payload Buffer utf8 string
  UTF8Payload({required dynamic payload, int? typeId}) : super(typeId ?? 1) {
    if (payload is Uint8List) {
      setPayload(payload);
    } else if (payload is String) {
      setPayload(Uint8List.fromList(utf8.encode(payload)));
    }
  }

  /// Returns a string for the payload.
  @override
  String getContentType() {
    return utf8.decode(getContent(), allowMalformed: true);
  }
}

/// Class for payloads representing Hexadecimal encoding.
class HEXSTRPayload extends PayloadBase {
  /// @param payload Buffer utf8 string
  HEXSTRPayload(dynamic payload) : super(2) {
    if (payload is Uint8List) {
      setPayload(payload);
    } else if (payload is String) {
      if (payload.startsWith("0x") ||
          !RegExp(r'^[0-9A-Fa-f]+$').hasMatch(payload)) {
        throw Exception(
            "HEXSTRPayload.constructor -- hex string may not start with 0x and must be in /^[0-9A-Fa-f]+\$/: ");
      }
      setPayload(hexDecode(payload));
    }
  }

  /// Returns a hex string for the payload.
  @override
  String getContentType() {
    return hexEncode(getContent());
  }
}

/// Class for payloads representing Base58 encoding.
class B58STRPayload extends PayloadBase {
  /// @param payload Buffer or cb58 encoded string
  B58STRPayload({required dynamic payload, int? typeId}) : super(typeId ?? 3) {
    if (payload is Uint8List) {
      setPayload(payload);
    } else if (payload is String) {
      setPayload(b58ToBuffer(payload));
    }
  }

  /// Returns a base58 string for the payload.
  @override
  String getContentType() {
    return bufferToB58(getContent());
  }
}

/// Class for payloads representing Base64 encoding.
class B64STRPayload extends PayloadBase {
  /// @param payload Buffer of base64 string
  B64STRPayload(dynamic payload) : super(4) {
    if (payload is Uint8List) {
      setPayload(payload);
    } else if (payload is String) {
      setPayload(base64Decode(payload));
    }
  }

  /// Returns a base64 string for the payload.
  @override
  String getContentType() {
    return base64Encode(getContent());
  }
}

/// Class for payloads representing Big Numbers.
class BIGNUMPayload extends PayloadBase {
  /// @param payload Buffer, BN, or base64 string
  BIGNUMPayload(dynamic payload) : super(5) {
    if (payload is Uint8List) {
      setPayload(payload);
    } else if (payload is BigInt) {
      setPayload(fromBNToBuffer(payload));
    } else if (payload is String) {
      setPayload(hexDecode(payload));
    }
  }

  /// Returns a BigInt for the payload.
  @override
  BigInt getContentType() {
    return fromBufferToBN(getContent());
  }
}

/// Class for payloads representing chain addresses.
abstract class ChainAddressPayload extends PayloadBase {
  final String chainId;

  final String? hrp;

  /// @param payload Buffer or address string
  ChainAddressPayload({
    required int typeId,
    required dynamic payload,
    required this.chainId,
    this.hrp,
  }) : super(typeId) {
    if (payload is Uint8List) {
      setPayload(payload);
    } else if (payload is String) {
      setPayload(stringToAddress(payload, hrp: hrp));
    }
  }

  /// Returns the chainId.
  String returnChainId() {
    return chainId;
  }

  /// Returns an address string for the payload.
  @override
  String getContentType() {
    return Serialization.instance.bufferToType(
        getContent(), SerializedType.bech32,
        args: [chainId, hrp]);
  }
}

/// Class for payloads representing X-Chin addresses.
class XCHAINADDRPayload extends ChainAddressPayload {
  XCHAINADDRPayload(dynamic payload)
      : super(typeId: 6, payload: payload, chainId: "X");
}

/// Class for payloads representing P-Chain addresses.
class PCHAINADDRPayload extends ChainAddressPayload {
  PCHAINADDRPayload(dynamic payload)
      : super(typeId: 7, payload: payload, chainId: "P");
}

/// Class for payloads representing C-Chain addresses.
class CCHAINADDRPayload extends ChainAddressPayload {
  CCHAINADDRPayload(dynamic payload)
      : super(typeId: 8, payload: payload, chainId: "C");
}

/// Class for payloads representing data serialized by cb58Encode().
abstract class Cb58EncodedPayload extends PayloadBase {
  ///@param payload Buffer or cb58 encoded string
  Cb58EncodedPayload({required dynamic payload, required int typeId})
      : super(typeId) {
    if (payload is Uint8List) {
      setPayload(payload);
    } else if (payload is String) {
      setPayload(cb58Decode(payload));
    }
  }

  /// Returns a cb58Encoded string for the payload.
  @override
  String getContentType() {
    return cb58Encode(getContent());
  }
}

/// Class for payloads representing TxIds.
class TXIDPayload extends Cb58EncodedPayload {
  TXIDPayload(dynamic payload) : super(payload: payload, typeId: 9);
}

/// Class for payloads representing AssetIds.
class ASSETIDPayload extends Cb58EncodedPayload {
  ASSETIDPayload(dynamic payload) : super(payload: payload, typeId: 10);
}

/// Class for payloads representing NodeIds.
class UTXOIDPayload extends Cb58EncodedPayload {
  UTXOIDPayload({required dynamic payload, int? typeId})
      : super(typeId: typeId ?? 11, payload: payload);
}

/// Class for payloads representing NFTIDs (UTXOIDs in an NFT context).
class NFTIDPayload extends UTXOIDPayload {
  NFTIDPayload(dynamic payload) : super(payload: payload, typeId: 12);
}

/// Class for payloads representing SubnetIDs.
class SUBNETIDPayload extends Cb58EncodedPayload {
  SUBNETIDPayload(dynamic payload) : super(payload: payload, typeId: 13);
}

/// Class for payloads representing ChainIDs.
class CHAINIDPayload extends Cb58EncodedPayload {
  CHAINIDPayload(dynamic payload) : super(payload: payload, typeId: 14);
}

/// Class for payloads representing NodeIDs.
class NODEIDPayload extends Cb58EncodedPayload {
  NODEIDPayload(dynamic payload) : super(payload: payload, typeId: 15);
}

/// Class for payloads representing secp256k1 signatures.
/// convention: secp256k1 signature (130 bytes)
class SECPSIGPayload extends B58STRPayload {
  SECPSIGPayload(dynamic payload) : super(payload: payload, typeId: 16);
}

/// Class for payloads representing secp256k1 encrypted messages.
/// convention: public key (65 bytes) + secp256k1 encrypted message for that public key
class SECPENCPayload extends B58STRPayload {
  SECPENCPayload(dynamic payload) : super(payload: payload, typeId: 17);
}

/// Class for payloads representing JPEG images.
class JPEGPayload extends BINPayload {
  JPEGPayload(dynamic payload) : super(payload: payload, typeId: 18);
}

class PNGPayload extends BINPayload {
  PNGPayload(dynamic payload) : super(payload: payload, typeId: 19);
}

/// Class for payloads representing BMP images.
class BMPPayload extends BINPayload {
  BMPPayload(dynamic payload) : super(payload: payload, typeId: 20);
}

/// Class for payloads representing ICO images.
class ICOPayload extends BINPayload {
  ICOPayload(dynamic payload) : super(payload: payload, typeId: 21);
}

/// Class for payloads representing SVG images.
class SVGPayload extends UTF8Payload {
  SVGPayload(dynamic payload) : super(payload: payload, typeId: 22);
}

/// Class for payloads representing CSV files.
class CSVPayload extends UTF8Payload {
  CSVPayload(dynamic payload) : super(payload: payload, typeId: 23);
}

/// Class for payloads representing JSON strings.
class JSONPayload extends PayloadBase {
  /// @param payload Buffer utf8 string
  JSONPayload(dynamic payload) : super(24) {
    if (payload is Uint8List) {
      setPayload(payload);
    } else if (payload is String) {
      setPayload(Uint8List.fromList(utf8.encode(payload)));
    } else if (payload != null) {
      final jsonStr = jsonEncode(payload);
      setPayload(Uint8List.fromList(utf8.encode(jsonStr)));
    }
  }

  /// Returns a string for the payload.
  @override
  Map<String, dynamic> getContentType() {
    return jsonDecode(utf8.decode(getContent(), allowMalformed: true));
  }
}

/// Class for payloads representing YAML definitions.
class YAMLPayload extends UTF8Payload {
  YAMLPayload(dynamic payload) : super(payload: payload, typeId: 25);
}

/// Class for payloads representing email addresses.
class EMAILPayload extends UTF8Payload {
  EMAILPayload(dynamic payload) : super(payload: payload, typeId: 26);
}

/// Class for payloads representing URL strings.
class URLPayload extends UTF8Payload {
  URLPayload(dynamic payload) : super(payload: payload, typeId: 27);
}

/// Class for payloads representing IPFS addresses.
class IPFSPayload extends B58STRPayload {
  IPFSPayload(dynamic payload) : super(payload: payload, typeId: 28);
}

/// Class for payloads representing onion URLs.
class ONIONPayload extends UTF8Payload {
  ONIONPayload(dynamic payload) : super(payload: payload, typeId: 29);
}

/// Class for payloads representing torrent magnet links.
class MAGNETPayload extends UTF8Payload {
  MAGNETPayload(dynamic payload) : super(payload: payload, typeId: 30);
}

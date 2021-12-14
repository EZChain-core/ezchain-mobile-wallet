import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

final serialization = Serialization.instance;
const address = "X-avax1wst8jt3z3fm9ce0z6akj3266zmgccdp03hjlaj";
const nodeID = "NodeID-MFrZFVCXPv5iCn6M9K6XduxGTYp891xXZ";
const privateKey =
    "PrivateKey-ewoqjP7PxY4yr3iLTpLisriqt94hdyDFNgchSxGGztUrTXtNN";
const cb58 = "2eNy1mUFdmaxXNj1eQHUe7Np4gju9sJsEtWQ4MX3ToiNKuADed";
const base64 = "ZnJvbSBzbm93Zmxha2UgdG8gQXZhbGFuY2hl";
const hex = "66726f6d20736e6f77666c616b6520746f204176616c616e636865";
const decimalString = "12345";
const num = 12345;
const utf8 = "from snowflake to Avalanche";
final bn = BigInt.from(9000);
const name = "BaseTx";
final denomination = Uint8List(1);
const chainID = "X";
final hrp = getPreferredHRP(1);

void main() {
  group("typeToBuffer && bufferToType", () {
    var type = SerializedType.hex;
    var buff = Uint8List.fromList([]);

    test("BN", () {
      type = SerializedType.BN;
      buff = serialization.typeToBuffer(bn, type);
      final b = serialization.bufferToType(buff, type);
      expect(bn.toString(), b.toString());
    });

    test("bech32", () {
      type = SerializedType.bech32;
      buff = serialization.typeToBuffer(address, type);
      final bech32 =
          serialization.bufferToType(buff, type, args: [chainID, hrp]);
      expect(bech32, address);
    });

    test("nodeID", () {
      type = SerializedType.nodeID;
      buff = serialization.typeToBuffer(nodeID, type);
      final n = serialization.bufferToType(buff, type);
      expect(n, nodeID);
    });

    test("privateKey", () {
      type = SerializedType.privateKey;
      buff = serialization.typeToBuffer(privateKey, type);
      final p = serialization.bufferToType(buff, type);
      expect(p, privateKey);
    });

    test("cb58", () {
      type = SerializedType.cb58;
      buff = serialization.typeToBuffer(cb58, type);
      final c = serialization.bufferToType(buff, type);
      expect(c, cb58);
    });

    test("base58", () {
      type = SerializedType.base58;
      buff = serialization.typeToBuffer(cb58, type);
      final c = serialization.bufferToType(buff, type);
      expect(c, cb58);
    });

    test("base64", () {
      type = SerializedType.base64;
      buff = serialization.typeToBuffer(base64, type);
      final b64 = serialization.bufferToType(buff, type);
      expect(b64, base64);
    });

    test("hex", () {
      type = SerializedType.hex;
      buff = serialization.typeToBuffer(hex, type);
      final h = serialization.bufferToType(buff, type);
      expect(h, hex);
    });

    test("decimalString", () {
      type = SerializedType.decimalString;
      buff = serialization.typeToBuffer(decimalString, type);
      final d = serialization.bufferToType(buff, type);
      expect(d, decimalString);
    });

    test("number", () {
      type = SerializedType.number;
      buff = serialization.typeToBuffer(num, type);
      final n = serialization.bufferToType(buff, type);
      expect(n, num);
    });

    test("utf8", () {
      type = SerializedType.utf8;
      buff = serialization.typeToBuffer(utf8, type);
      final u = serialization.bufferToType(buff, type);
      expect(u, utf8);
    });
  });

  group("encoder && decoder", () {
    const encoding = SerializedEncoding.hex;

    test("BN", () {
      final str = serialization.encoder(
          bn, encoding, SerializedType.BN, SerializedType.BN);
      final decoded = serialization.decoder(
          str, encoding, SerializedType.BN, SerializedType.BN);
      expect(decoded.toString(), bn.toString());
    });

    test("bech32", () {
      final str = serialization.encoder(
          address, encoding, SerializedType.bech32, SerializedType.bech32);
      final decoded = serialization.decoder(
          str, encoding, SerializedType.bech32, SerializedType.bech32,
          args: [chainID, hrp]);
      expect(decoded.toString(), address);
    });

    test("nodeID", () {
      final str = serialization.encoder(
          nodeID, encoding, SerializedType.nodeID, SerializedType.nodeID);
      final decoded = serialization.decoder(
          str, encoding, SerializedType.nodeID, SerializedType.nodeID);
      expect(decoded.toString(), nodeID);
    });

    test("privateKey", () {
      final str = serialization.encoder(privateKey, encoding,
          SerializedType.privateKey, SerializedType.privateKey);
      final decoded = serialization.decoder(
          str, encoding, SerializedType.privateKey, SerializedType.privateKey);
      expect(decoded.toString(), privateKey);
    });

    test("cb58", () {
      final str = serialization.encoder(
          cb58, encoding, SerializedType.cb58, SerializedType.cb58);
      final decoded = serialization.decoder(
          str, encoding, SerializedType.cb58, SerializedType.cb58);
      expect(decoded.toString(), cb58);
    });

    test("cb58", () {
      final str = serialization.encoder(
          cb58, encoding, SerializedType.base58, SerializedType.base58);
      final decoded = serialization.decoder(
          str, encoding, SerializedType.base58, SerializedType.base58);
      expect(decoded.toString(), cb58);
    });

    test("base64", () {
      final str = serialization.encoder(
          base64, encoding, SerializedType.base64, SerializedType.base64);
      final decoded = serialization.decoder(
          str, encoding, SerializedType.base64, SerializedType.base64);
      expect(decoded.toString(), base64);
    });

    test("hex", () {
      final str = serialization.encoder(
          hex, encoding, SerializedType.hex, SerializedType.hex);
      final decoded = serialization.decoder(
          str, encoding, SerializedType.hex, SerializedType.hex);
      expect(decoded.toString(), hex);
    });

    test("utf8", () {
      final str = serialization.encoder(
          name, encoding, SerializedType.utf8, SerializedType.utf8);
      final decoded = serialization.decoder(
          str, encoding, SerializedType.utf8, SerializedType.utf8);
      expect(decoded.toString(), name);
    });

    test("decimalString", () {
      final str = serialization.encoder(decimalString, encoding,
          SerializedType.decimalString, SerializedType.decimalString);
      final decoded = serialization.decoder(str, encoding,
          SerializedType.decimalString, SerializedType.decimalString);
      expect(decoded.toString(), decimalString);
    });

    test("number", () {
      final str = serialization.encoder(
          num, encoding, SerializedType.number, SerializedType.number);
      final decoded = serialization.decoder(
          str, encoding, SerializedType.number, SerializedType.number);
      expect(decoded, num);
    });

    test("Buffer", () {
      final str = serialization.encoder(denomination, encoding,
          SerializedType.Buffer, SerializedType.decimalString,
          args: [1]);
      final decoded = serialization.decoder(
          str, encoding, SerializedType.decimalString, SerializedType.Buffer,
          args: [1]);
      expect(hexEncode(decoded), hexEncode(denomination));
    });
  });
}

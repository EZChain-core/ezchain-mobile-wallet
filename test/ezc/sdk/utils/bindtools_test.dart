import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';

const hexstr = "00112233445566778899aabbccddeeff";
final buff = Uint8List.fromList(hexDecode(hexstr));

void main() {
  test("fromBufferToBN", () {
    final bign = fromBufferToBN(buff);
    expect(bign.toRadixString(16).padLeft(buff.length * 2, '0'), hexstr);
  });

  test("fromBNToBuffer", () {
    final bn1 = BigInt.parse(hexstr, radix: 16);
    final bn2 = BigInt.parse(hexstr, radix: 16);
    final b1 = fromBNToBuffer(bn1);
    final b2 = fromBNToBuffer(bn2, length: buff.length);

    expect(b1.length, buff.length - 1);
    expect(hexEncode(b1), hexstr.substring(2));

    expect(b2.length, buff.length);
    expect(hexEncode(b2), hexstr);
  });
}

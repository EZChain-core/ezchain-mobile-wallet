import 'package:test/test.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

void main() {
  group("stringToBN", () {
    test("no decimals", () {
      final value = stringToBn("10", 0);
      expect(value, BigInt.from(10));
    });

    test("string has decimal point, but value doesn't", () {
      final value = stringToBn("10.0", 0);
      expect(value, BigInt.from(10));
    });

    test("should be 0", () {
      final value = stringToBn("0", 0);
      final valuePoint = stringToBn("0.0", 0);
      expect(value, BigInt.from(0));
      expect(valuePoint, BigInt.from(0));
    });

    test("has decimal values", () {
      final value = stringToBn("1.12", 5);
      expect(value, BigInt.from(112000));
    });

    test("has decimal values with extra 0s", () {
      final value = stringToBn("1.12000", 5);
      expect(value, BigInt.from(112000));
    });

    test("decimals has extra 0, higher than the denomination", () {
      final value = stringToBn("1.1232", 2);
      expect(value, BigInt.from(112));
    });

    test("Million AVAX 9 decimals", () {
      final value = stringToBn("360123900", 9);
      expect(value, BigInt.parse("360123900000000000"));
    });

    test("Million AVAX 18 decimals", () {
      final value = stringToBn("360123900", 18);
      expect(value, BigInt.parse("360123900000000000000000000"));
    });

    test("bnToAvaxX = 0", () {
      final value = bnToAvaxX(BigInt.zero);
      expect(value, "0");
    });

    test("bnToAvaxX", () {
      final value = bnToAvaxX(BigInt.parse("31770334734826818"));
      expect(value, "31,770,334.734826818");
    });
  });
}

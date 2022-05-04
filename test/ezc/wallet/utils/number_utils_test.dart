import 'package:test/test.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

void main() {
  group("stringToBN", () {
    test("no decimals", () {
      final value = "10".toBN(0);
      expect(value, BigInt.from(10));
    });

    test("string has decimal point, but value doesn't", () {
      final value = "10.0".toBN(0);
      expect(value, BigInt.from(10));
    });

    test("should be 0", () {
      final value = "0".toBN(0);
      final valuePoint = "0.0".toBN(0);
      expect(value, BigInt.from(0));
      expect(valuePoint, BigInt.from(0));
    });

    test("has decimal values", () {
      final value = "1.12".toBN(5);
      expect(value, BigInt.from(112000));
    });

    test("has decimal values with extra 0s", () {
      final value = "1.12000".toBN(5);
      expect(value, BigInt.from(112000));
    });

    test("decimals has extra 0, higher than the denomination", () {
      final value = "1.1232".toBN(2);
      expect(value, BigInt.from(112));
    });

    test("Million AVAX 9 decimals", () {
      final value = "360123900".toBN(9);
      expect(value, BigInt.parse("360123900000000000"));
    });

    test("Million AVAX 18 decimals", () {
      final value = "360123900".toBN(18);
      expect(value, BigInt.parse("360123900000000000000000000"));
    });

    test("bnToAvaxX = 0", () {
      final value = BigInt.zero.toAvaxX();
      expect(value, "0");
    });

    test("bnToAvaxX", () {
      final value = BigInt.parse("31770334734826818").toAvaxX();
      expect(value, "31,770,334.734826818");
    });
  });
}

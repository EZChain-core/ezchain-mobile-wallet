import 'package:test/test.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/common/output.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';

void main() {
  group("Outputs", () {
    const codecID_zero = 0;
    const codecID_one = 1;

    group("SECPTransferOutput", () {
      final addrs = [
        cb58Decode("B6D4v1VtPYLbiUvYXtW4Px8oE9imC2vGW"),
        cb58Decode("P5wdRuZeaDt28eHMP5S3w9ZdoBfo7wuzF"),
        cb58Decode("6Y3kysjF9jnHnYkdS9yGAuoHyae2eNmeV")
      ]..sortBuffer();

      final locktime = BigInt.from(54321);
      final addrpay = [addrs[0], addrs[1]];
      final fallLocktime = locktime + BigInt.from(50);

      test("SelectOutputClass", () {
        final goodout = AvmSECPTransferOutput(
            amount: BigInt.from(2600),
            addresses: addrpay,
            lockTime: fallLocktime,
            threshold: 1);
        final outpayment = selectOutputClass(goodout.getOutputId());
        expect(outpayment is AvmSECPTransferOutput, true);
        expect(() => selectOutputClass(99),
            throwsA(predicate((e) => e is Exception)));
      });

      test("comparator", () {
        final outpayment1 = AvmSECPTransferOutput(
            amount: BigInt.from(10000),
            addresses: addrs,
            lockTime: locktime,
            threshold: 3);

        final outpayment2 = AvmSECPTransferOutput(
            amount: BigInt.from(10001),
            addresses: addrs,
            lockTime: locktime,
            threshold: 3);

        final outpayment3 = AvmSECPTransferOutput(
            amount: BigInt.from(9999),
            addresses: addrs,
            lockTime: locktime,
            threshold: 3);

        final cmp = OutputOwners.comparator();

        expect(cmp(outpayment1, outpayment1), 0);
        expect(cmp(outpayment2, outpayment2), 0);
        expect(cmp(outpayment3, outpayment3), 0);
        expect(cmp(outpayment1, outpayment2), -1);
        expect(cmp(outpayment1, outpayment3), 1);
      });

      test("SECPTransferOutput fields", () {
        final out = AvmSECPTransferOutput(
            amount: BigInt.from(10000),
            addresses: addrs,
            lockTime: locktime,
            threshold: 3);

        expect(out.getOutputId(), 7);
        expect(out.getAddresses()..sortBuffer(), addrs..sortBuffer());
        expect(out.getThreshold(), 3);
        expect(out.getLockTime(), locktime);

        final r = out.getAddressIdx(addrs[2]);
        expect(out.getAddress(r), addrs[2]);
        expect(() => out.getAddress(400),
            throwsA(predicate((e) => e is Exception)));

        expect(out.getAmount().toInt(), 10000);

        final b = out.toBuffer();
        expect(out.toString(), bufferToB58(b));

        final s = out.getSpenders(addrs);
        expect(s..sortBuffer(), addrs..sortBuffer());

        final m1 = out.meetsThreshold([addrs[0]]);
        expect(m1, false);
        final m2 = out.meetsThreshold(addrs, asOf: BigInt.from(100));
        expect(m2, false);
        final m3 = out.meetsThreshold(addrs);
        expect(m3, true);
        final m4 = out.meetsThreshold(addrs, asOf: locktime + BigInt.from(100));
        expect(m4, true);
      });

      test("SECPTransferOutput codecIDs", () {
        final out = AvmSECPTransferOutput(
            amount: BigInt.from(10000),
            addresses: addrs,
            lockTime: locktime,
            threshold: 3);

        expect(out.getTypeName(), "SECPTransferOutput");
        expect(out.getCodecId(), codecID_zero);
        expect(out.getOutputId(), SECPXFEROUTPUTID);

        out.setCodecId(codecID_one);
        expect(out.getCodecId(), codecID_one);
        expect(out.getOutputId(), SECPXFEROUTPUTID_CODECONE);

        out.setCodecId(codecID_zero);
        expect(out.getCodecId(), codecID_zero);
        expect(out.getOutputId(), SECPXFEROUTPUTID);
      });

      test("Invalid SECPTransferOutput codecID", () {
        final out = AvmSECPTransferOutput(
            amount: BigInt.from(10000),
            addresses: addrs,
            lockTime: locktime,
            threshold: 3);
        expect(
            () => out.setCodecId(2), throwsA(predicate((e) => e is Exception)));
      });
    });
  });
}

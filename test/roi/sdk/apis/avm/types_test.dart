import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/utils/bintools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';

void main() {
  test("Does it return the right time?", () {
    final now = (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).round();
    final unow = unixNow();
    expect(now / 10, unow / BigInt.from(10));
  });

  test("Signature & NBytes", () {
    final sig = Signature();
    final sigpop = <int>[];
    for (int i = 0; i < sig.getSize(); i++) {
      sigpop.add(i);
    }
    final sigbuff = Uint8List.fromList(sigpop);
    final size = sig.fromBuffer(sigbuff);
    expect(sig.getSize(), size);
    expect(size, sig.getSize());

    final sigbuff2 = sig.toBuffer();
    for (int i = 0; i < sigbuff.length; i++) {
      expect(sigbuff2[i], sigbuff[i]);
    }
    final sigbuffstr = bufferToB58(sigbuff);
    expect(sig.toString(), sigbuffstr);
    sig.fromString(sigbuffstr);
    expect(sig.toString(), sigbuffstr);
  });

  test("SigIdx", () {
    final sigidx = SigIdx();
    expect(sigidx.getSize(), sigidx.toBuffer().length);
    sigidx.setSource(Uint8List.fromList(hexDecode("abcd")));
    expect(hexEncode(sigidx.getSource()), "abcd");
  });

  test("Address", () {
    final addr1 = Address();
    final addr2 = Address();
    final smaller = [
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      9,
      8,
      7,
      6,
      5,
      4,
      3,
      2,
      1,
      0
    ];
    final bigger = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 8, 7, 6, 5, 4, 3, 2, 1, 1];
    final addr1bytes = Uint8List.fromList(smaller);
    final addr2bytes = Uint8List.fromList(bigger);
    addr1.fromBuffer(addr1bytes);
    addr2.fromBuffer(addr2bytes);
    expect(Address.comparator()(addr1, addr2), -1);
    expect(Address.comparator()(addr2, addr1), 1);

    final addr2str = addr2.toString();

    addr2.fromBuffer(addr1bytes);
    expect(Address.comparator()(addr1, addr2), 0);

    addr2.fromString(addr2str);
    expect(Address.comparator()(addr1, addr2), -1);

    final a1b = addr1.toBuffer();
    final a1s = bufferToB58(a1b);
    addr2.fromString(a1s);
    expect(Address.comparator()(addr1, addr2), 0);

    final badbuff = addr1bytes;
    var badbuffout = Uint8List.fromList([...badbuff, 1, 2]);
    var badstr = bufferToB58(badbuffout);
    final badaddr = Address();

    expect(() => badaddr.fromString(badstr),
        throwsA(predicate((e) => e is Exception)));

    badbuffout = Uint8List.fromList([...badbuff, 1, 2, 3, 4]);
    badstr = bufferToB58(badbuffout);

    expect(() => badaddr.fromString(badstr),
        throwsA(predicate((e) => e is Exception)));
  });
}

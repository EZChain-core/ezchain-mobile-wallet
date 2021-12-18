import 'dart:convert';

import 'package:hash/hash.dart';
import 'package:test/test.dart';
import 'package:wallet/roi/sdk/apis/avm/key_chain.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';

const alias = "X";
const hrp = "tests";

void main() {
  test("repeatable 1", () {
    final kp = AvmKeyPair(chainId: alias, hrp: hrp);
    kp.importKey(hexDecode(
        "ef9bf2d4436491c153967c9709dd8e82795bdb9b5ad44ee22c2903005d1cf676"));
    expect(hexEncode(kp.publicKeyBytes),
        "033fad3644deb20d7a210d12757092312451c112d04773cee2699fbb59dc8bb2ef");

    final msg = SHA256().update(hexDecode("09090909")).digest();

    final sig = kp.sign(msg);
    expect(sig.length, 65);
    expect(kp.verify(msg, sig), true);
    expect(hexEncode(kp.recover(msg, sig)), hexEncode(kp.publicKeyBytes));
  });
}

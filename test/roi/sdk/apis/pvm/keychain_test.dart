import 'dart:convert';

import 'package:hash/hash.dart';
import 'package:test/test.dart';
import 'package:wallet/roi/sdk/apis/pvm/key_chain.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';

const alias = "";
const hrp = "tests";

void main() {
  test("repeatable 1", () {
    final keyBuff = hexDecode(
        "ef9bf2d4436491c153967c9709dd8e82795bdb9b5ad44ee22c2903005d1cf676");
    final kp = PvmKeyPair(chainId: alias, hrp: hrp);
    kp.importKey(keyBuff);
    expect(hexEncode(kp.publicKeyBytes),
        "033fad3644deb20d7a210d12757092312451c112d04773cee2699fbb59dc8bb2ef");

    final msg = SHA256().update(hexDecode("09090909")).digest();

    final sig = kp.sign(msg);
    expect(sig.length, 65);
    expect(kp.verify(msg, sig), true);
    expect(hexEncode(kp.recover(msg, sig)), hexEncode(kp.publicKeyBytes));
  });

  test("importKey from Buffer", () {
    final keyBuff = hexDecode(
        "d0e17d4b31380f96a42b3e9ffc4c1b2a93589a1e51d86d7edc107f602fbc7475");
    final kc = PvmKeyChain(chainId: alias, hrp: hrp);

    final address1 = kc.importKey(keyBuff).getAddress();
    final kp1 = kc.getKey(address1)!;
    final address2 = kp1.getAddress();

    final kp2 = PvmKeyPair(chainId: alias, hrp: hrp);
    kp2.importKey(keyBuff);

    expect(hexEncode(address1), hexEncode(address2));
    expect(kp1.getPrivateKeyString(), kp2.getPrivateKeyString());
    expect(kp1.getPublicKeyString(), kp2.getPublicKeyString());
    expect(kc.hasKey(address1), true);
  });
}

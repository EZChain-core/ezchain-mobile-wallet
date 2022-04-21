import 'package:hash/hash.dart';
import 'package:test/test.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';

const alias = "C";
const hrp = "tests";

void main() {
  test("repeatable 1", () {
    final keyBuff = hexDecode(
        "d0e17d4b31380f96a42b3e9ffc4c1b2a93589a1e51d86d7edc107f602fbc7475");
    final kp = EZCKeyPair(chainId: alias, hrp: hrp);
    kp.importKey(keyBuff);
    expect(hexEncode(kp.publicKeyBytes),
        "031475b91d4fcf52979f1cf107f058088cc2bea6edd51915790f27185a7586e2f2");

    final msg = SHA256().update(hexDecode("09090909")).digest();

    final sig = kp.sign(msg);
    expect(sig.length, 65);
    expect(kp.verify(msg, sig), true);
    expect(hexEncode(kp.recover(msg, sig)), hexEncode(kp.publicKeyBytes));
  });

  test("importKey from Buffer", () {
    final keyBuff = hexDecode(
        "d0e17d4b31380f96a42b3e9ffc4c1b2a93589a1e51d86d7edc107f602fbc7475");
    final kc = EZCKeyChain(chainId: alias, hrp: hrp);

    final address1 = kc.importKey(keyBuff).getAddress();
    final kp1 = kc.getKey(address1)!;
    final address2 = kp1.getAddress();

    final kp2 = EZCKeyPair(chainId: alias, hrp: hrp);
    kp2.importKey(keyBuff);

    expect(hexEncode(address1), hexEncode(address2));
    expect(kp1.getPrivateKeyString(), kp2.getPrivateKeyString());
    expect(kp1.getPublicKeyString(), kp2.getPublicKeyString());
    expect(kc.hasKey(address1), true);
  });
}

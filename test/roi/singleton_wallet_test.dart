import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

void main() {
  const myPk = "PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb";
  const evmPrivateKey =
      "85299dffb775bda7e2bec2a085c6207e5f21b058ad92c097a5274fe2b62e1a68";

  final wallet = SingletonWallet.fromEvmKey(evmPrivateKey);

  test("can return initial X address", () {
    String addressX = wallet.getAddressX();
    expect(addressX, 'X-avax19v8flm9qt2gv2tctztjjerlgs4k3vgjsfw8udh');
  });

  test("can return initial P address", () {
    String addressP = wallet.getAddressP();
    expect(addressP, 'P-avax19v8flm9qt2gv2tctztjjerlgs4k3vgjsfw8udh');
  });

  test("can return initial C address", () {
    String addressC = wallet.getAddressC();
    expect(addressC, '0x6a23c16777a3a194b2773df90feb8753a8e619ee');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

void main() {
  const myPk = "PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb";
  final wallet = SingletonWallet(privateKey: myPk);

  test("can return initial X address", () {
    String addressX = wallet.getAddressX();
    expect(addressX, 'X-avax129sdwasyyvdlqqsg8d9pguvzlqvup6cm8lrd3j');
  });

  test("can return initial P address", () {
    String addressP = wallet.getAddressP();
    expect(addressP, 'P-avax129sdwasyyvdlqqsg8d9pguvzlqvup6cm8lrd3j');
  });

  test("can return initial C address", () {
    String addressC = wallet.getAddressC();
    expect(addressC, '0xd30a9f6645a73f67b7850b9304b6a3172dda75bf');
  });
}

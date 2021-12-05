import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

void main() {
  const evmPk =
      "75d9395f950b405e8477877e891e79127356768b196007bd06331696c76d3d95";
  final wallet = SingletonWallet.fromEvmKey(evmPk);

  test("can return initial X address", () {
    String addressX = wallet.getAddressX();
    expect(addressX, 'X-avax1zx8ckk5qfhw365gemu6e76tynwuj6d89pyzqfj');
  });

  test("can return initial P address", () {
    String addressP = wallet.getAddressP();
    expect(addressP, 'P-avax1zx8ckk5qfhw365gemu6e76tynwuj6d89pyzqfj');
  });

  test("can return initial C address", () {
    String addressC = wallet.getAddressC();
    expect(addressC, '0x39bcdb76dcc314dec0e68927eff08f86a5ccdc1f');
  });
}

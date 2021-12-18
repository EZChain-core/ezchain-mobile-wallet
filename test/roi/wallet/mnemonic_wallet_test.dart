import 'package:test/test.dart';

import 'package:wallet/roi/wallet/mnemonic_wallet.dart';

void main() {
  const mnemonic =
      "unaware click walnut alpha leopard pig attitude collect suit belt math sword token pupil matrix void ten vendor barrel bitter rather debris include moral";
  final wallet = MnemonicWallet(mnemonic: mnemonic);

  test("isValid Mnemonic", () {
    expect(MnemonicWallet.import(mnemonic) != null, true);
  });

  test("isInValid Mnemonic", () {
    expect(
        MnemonicWallet.import(mnemonic.replaceFirst("unaware", "kien")), null);
  });

  test("isInValid length Mnemonic", () {
    expect(MnemonicWallet.import(mnemonic.substring(8)), null);
  });

  test("can return initial X address", () {
    final addressX = wallet.getAddressX();
    expect(addressX, 'X-avax1drhz4wmg2fcxgm6f2ypffl7stugezxr8uu0xqt');
  });

  test("can return initial P address", () {
    final addressP = wallet.getAddressP();
    expect(addressP, 'P-avax1drhz4wmg2fcxgm6f2ypffl7stugezxr8uu0xqt');
  });

  test("can return initial C address", () {
    final addressC = wallet.getAddressC();
    expect(addressC, '0x39bcdb76dcc314dec0e68927eff08f86a5ccdc1f');
  });

  test("all X addresses", () {
    final allAddressesX = wallet.getAllAddressesXSync();
    expect(allAddressesX, [
      "X-avax1drhz4wmg2fcxgm6f2ypffl7stugezxr8uu0xqt",
      "X-avax1txyfeuea7uw0g8d7659dxxejcjz3zws25v7mhg"
    ]);
  });

  test("all P addresses", () {
    final allAddressesP = wallet.getAllAddressesPSync();
    expect(allAddressesP, ["P-avax1drhz4wmg2fcxgm6f2ypffl7stugezxr8uu0xqt"]);
  });
}
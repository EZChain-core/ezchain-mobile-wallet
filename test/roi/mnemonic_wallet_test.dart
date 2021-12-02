import 'package:flutter_test/flutter_test.dart';

import 'package:wallet/roi/wallet/mnemonic_wallet.dart';

const TEST_MNEMONIC =
    'chimney noodle canyon tunnel sample stuff scan symbol sight club net own arrive cause suffer purity manage squirrel boost diesel bring cement father slide';

void main() {
  final wallet = MnemonicWallet(mnemonic: TEST_MNEMONIC);
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

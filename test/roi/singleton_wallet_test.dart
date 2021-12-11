import 'package:test/test.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

void main() {
  const invalidAvmKey =
      "PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdbXXX";
  final walletFromInvalidAvmKey = SingletonWallet.access(invalidAvmKey);

  test("SingletonWallet from invalid Avm Key", () {
    expect(walletFromInvalidAvmKey, null);
  });

  const invalidEvmKey =
      "75d9395f950b405e8477877e891e79127356768b196007bd06331696c76d3XXX";
  final walletFromInvalidEvmKey = SingletonWallet.access(invalidEvmKey);

  test("SingletonWallet from invalid Evm Key", () {
    expect(walletFromInvalidEvmKey, null);
  });

  const avmPk = "PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb";
  final walletFromAvmKey = SingletonWallet.access(avmPk)!;

  test("can return initial X address", () {
    String addressX = walletFromAvmKey.getAddressX();
    expect(addressX, 'X-avax129sdwasyyvdlqqsg8d9pguvzlqvup6cm8lrd3j');
  });

  test("can return initial P address", () {
    String addressP = walletFromAvmKey.getAddressP();
    expect(addressP, 'P-avax129sdwasyyvdlqqsg8d9pguvzlqvup6cm8lrd3j');
  });

  test("can return initial C address", () {
    String addressC = walletFromAvmKey.getAddressC();
    expect(addressC, '0xd30a9f6645a73f67b7850b9304b6a3172dda75bf');
  });

  const evmPk =
      "75d9395f950b405e8477877e891e79127356768b196007bd06331696c76d3d95";
  final walletFromEvmKey = SingletonWallet.access(evmPk)!;

  test("can return initial X address", () {
    String addressX = walletFromEvmKey.getAddressX();
    expect(addressX, 'X-avax1zx8ckk5qfhw365gemu6e76tynwuj6d89pyzqfj');
  });

  test("can return initial P address", () {
    String addressP = walletFromEvmKey.getAddressP();
    expect(addressP, 'P-avax1zx8ckk5qfhw365gemu6e76tynwuj6d89pyzqfj');
  });

  test("can return initial C address", () {
    String addressC = walletFromEvmKey.getAddressC();
    expect(addressC, '0x39bcdb76dcc314dec0e68927eff08f86a5ccdc1f');
  });
}

import 'package:wallet/roi/wallet/singleton_wallet.dart';

void main() {
  const myPk = "PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb";
  const evmPrivateKey =
      "27e6693f3122aed61653343559d5cd2702f0dd38ad2ce08e31f72c3c40fd19c4";

  // final wallet = SingletonWallet(privateKey: myPk);
  final wallet = SingletonWallet.fromEvmKey(evmPrivateKey);

  print("evmWallet.address = ${wallet.evmWallet.address}");
  print("evmWallet.getPrivateKeyHex = ${wallet.evmWallet.getPrivateKeyHex()}");
  print("getAddressX = ${wallet.getAddressX()}");
  print("getAddressP = ${wallet.getAddressP()}");
  print("getAddressC = ${wallet.getAddressC()}");
}

// evmWallet.address = 0xd30a9f6645a73f67b7850b9304b6a3172dda75bf
// evmWallet.getPrivateKeyHex = 27e6693f3122aed61653343559d5cd2702f0dd38ad2ce08e31f72c3c40fd19c4
// getAddressX = X-avax129sdwasyyvdlqqsg8d9pguvzlqvup6cm8lrd3j
// getAddressP = P-avax129sdwasyyvdlqqsg8d9pguvzlqvup6cm8lrd3j
// getAddressC = 0xd30a9f6645a73f67b7850b9304b6a3172dda75bf

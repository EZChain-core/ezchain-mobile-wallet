import 'package:wallet/roi/wallet/singleton_wallet.dart';

void main() {
  const myPk = "PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb";

  final wallet = SingletonWallet(privateKey: myPk);

  print("address = ${wallet.evmWallet.address}");
}

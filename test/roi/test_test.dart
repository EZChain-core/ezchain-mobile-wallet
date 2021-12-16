import 'dart:convert';
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';

void main() {
  final keyChain = ROIKeyChain(chainId: "X", hrp: "avax");

  const privateKey =
      "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M";

  print(
      "length1 = ${"PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb".length}");
  print(
      "length2 = ${"PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M".length}");

  keyChain.importKey(privateKey);
  final addresses = keyChain.getAddresses();
  final keypair = keyChain.getKey(addresses[0])!;

  print("getAddressString = ${keypair.getAddressString()}");

  final wallet = SingletonWallet(
      privateKey:
          "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");

  print("getAddressX = ${wallet.getAddressX()}");
}

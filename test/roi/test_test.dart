import 'dart:convert';
import 'dart:typed_data';
import 'package:decimal/decimal.dart';
import 'package:test/test.dart';
import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/wallet/singleton_wallet.dart';
import 'package:wallet/roi/wallet/utils/number_utils.dart';

import 'sdk/utils/serialization_test.dart';

void main() {
  final totalROI = Decimal.parse("31769498.674525431");

  final total = decimalToLocaleString(totalROI);
  print("total = $total");

  final usd = Decimal.parse(116.04.toString());

  final totalUsd = totalROI * usd;

  final totalUsdString = decimalToLocaleString(totalUsd, decimals: 2);
  print("totalUsdString = $totalUsdString");

  // print("value = ${stringToBigInt16("0x2540be400")}");
  // final keyChain = ROIKeyChain(chainId: "X", hrp: "avax");
  //
  // const privateKey =
  //     "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M";
  //
  // print(
  //     "length1 = ${"PrivateKey-JaCCSxdoWfo3ao5KwenXrJjJR7cBTQ287G1C5qpv2hr2tCCdb".length}");
  // print(
  //     "length2 = ${"PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M".length}");
  //
  // keyChain.importKey(privateKey);
  // final addresses = keyChain.getAddresses();
  // final keypair = keyChain.getKey(addresses[0])!;
  //
  // print("getAddressString = ${keypair.getAddressString()}");
  //
  // final wallet = SingletonWallet(
  //     privateKey:
  //         "PrivateKey-25UA2N5pAzFmLwQoCxTpp66YcRjYZwGFZ2hB6Jk6nf67qWDA8M");
  //
  // print("getAddressX = ${wallet.getAddressX()}");
}

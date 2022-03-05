import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:decimal/decimal.dart';
import 'package:test/test.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';
import 'package:wallet/ezc/wallet/helpers/staking_helper.dart';
import 'package:wallet/ezc/wallet/singleton_wallet.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

import 'sdk/utils/serialization_test.dart';

void main() {
  const SECONDS_PER_YEAR = 31536000;
  final rewardValue = reward(
    SECONDS_PER_YEAR,
    BigInt.parse("999999999999999983222784"),
    BigInt.parse("999999999999999983222784"),
    BigInt.parse("500000000000000006643777536"),
  );
  print(
      "rewardValue = ${bnToDecimal(rewardValue ~/ BigInt.parse("1000000"), denomination: 18).toStringAsFixed(2)}");
  // print("value = ${decimalToLocaleString(rewardValue.toDecimal())}");
  // print(
  //     "value = ${reward(SECONDS_PER_YEAR, BigInt.one, BigInt.one, BigInt.from(500))}");
  // print(
  //     "value = ${reward(SECONDS_PER_YEAR, BigInt.one, BigInt.two, BigInt.from(500))}");
  // print(
  //     "value = ${reward(SECONDS_PER_YEAR, BigInt.one, BigInt.from(4), BigInt.from(500))}");
}

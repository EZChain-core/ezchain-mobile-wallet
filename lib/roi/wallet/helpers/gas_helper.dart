import 'package:wallet/roi/sdk/utils/bigint.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:web3dart/web3dart.dart';

final MAX_GAS = BigInt.from(1000000000000);

/// Returns the current gas price in WEI from the network
Future<BigInt> getGasPrice() async {
  final gasPrice = await web3.getGasPrice();
  return gasPrice.getValueInUnitBI(EtherUnit.wei);
}

/// Returns the gas price + 25%, or max gas
Future<BigInt> getAdjustedGasPrice() async {
  final gasPrice = await getGasPrice();
  final adjustedGas = adjustValue(gasPrice, 25);
  return min(adjustedGas, MAX_GAS);
}

/// @param val
/// @param percent What percentage to adjust with
BigInt adjustValue(BigInt val, int percent) {
  final padAmt = BigInt.from(val / BigInt.from(100)) * BigInt.from(percent);
  return val + padAmt;
}

/// Returns the base fee from the network.
Future<BigInt> getBaseFee() async {
  final rawHex = await cChain.getBaseFee();
  return stringToBigInt16(rawHex);
}

/// Returns the current base fee + 25%
Future<BigInt> getBaseFeeRecommended() async {
  final baseFee = await getBaseFee();
  return adjustValue(baseFee, 25);
}

/// Returns the base max priority fee from the network.
Future<BigInt> getMaxPriorityFee() async {
  final rawHex = await cChain.getMaxPriorityFeePerGas();
  return stringToBigInt16(rawHex);
}

/// Calculate max fee for EIP 1559 transactions given baseFee and maxPriorityFee.
/// According to https://www.blocknative.com/blog/eip-1559-fees
/// @param baseFee in WEI
/// @param maxPriorityFee in WEI
BigInt calculateMaxFee(BigInt baseFee, BigInt maxPriorityFee) {
  return (baseFee * BigInt.from(2)) + maxPriorityFee;
}

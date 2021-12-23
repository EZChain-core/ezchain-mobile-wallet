import 'package:wallet/roi/sdk/utils/bigint.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:web3dart/web3dart.dart';

final MAX_GAS = BigInt.from(1000000000000);

Future<BigInt> getGasPrice() async {
  final gasPrice = await web3.getGasPrice();
  return gasPrice.getValueInUnitBI(EtherUnit.wei);
}

Future<BigInt> getAdjustedGasPrice() async {
  final gasPrice = await getGasPrice();
  final adjustedGas = adjustValue(gasPrice, 25);
  return min(gasPrice, adjustedGas);
}

BigInt adjustValue(BigInt val, int perc) {
  final padAmt = BigInt.from(val / BigInt.from(100)) * BigInt.from(perc);
  return val + padAmt;
}

// Future<BigInt> getBaseFee() async{
//    final rawHex = await cChain.getBase
// }

// getBaseFee

// getMaxPriorityFeePerGas
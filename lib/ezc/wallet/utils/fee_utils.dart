import 'package:wallet/ezc/wallet/helpers/gas_helper.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/types.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';

BigInt getTxFeeX() {
  return xChain.getTxFee();
}

BigInt getTxFeeP() {
  return pChain.getTxFee();
}

/// Estimates the required fee for a C chain export transaction
/// @param destinationChain Either `X` or `P`
/// @param baseFee Current base fee of the network, use a padded amount.
/// @return BN C chain atomic export transaction fee in nEZC.
Future<BigInt> estimateExportGasFee(
  ExportChainsC destinationChain,
  BigInt amount,
  String hexAddress,
  String destinationAddress,
) async {
  final exportGas = estimateExportGasFeeFromMockTx(
    destinationChain,
    amount,
    hexAddress,
    destinationAddress,
  );
  final baseFee = await getBaseFeeRecommended();
  return (baseFee * BigInt.from(exportGas)).avaxCtoX();
}

Future<BigInt> estimateImportGasFee({int numIns = 1, int numSigs = 1}) async {
  final importGas = estimateImportGasFeeFromMockTx(numIns, numSigs);
  final baseFee = await getBaseFeeRecommended();
  return (baseFee * BigInt.from(importGas)).avaxCtoX();
}

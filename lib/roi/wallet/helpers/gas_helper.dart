import 'package:wallet/roi/sdk/apis/evm/export_tx.dart';
import 'package:wallet/roi/sdk/apis/evm/inputs.dart';
import 'package:wallet/roi/sdk/apis/evm/outputs.dart';
import 'package:wallet/roi/sdk/apis/evm/tx.dart';
import 'package:wallet/roi/sdk/utils/bigint.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/wallet/network/helpers/id_from_alias.dart';
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:wallet/roi/wallet/network/utils.dart';
import 'package:wallet/roi/wallet/types.dart';
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

/// Creates a mock import transaction and estimates the gas required for it. Returns fee in units of gas.
/// @param numIns Number of inputs for the import transaction.
/// @param numSigs Number of signatures used in the import transactions. This value is the sum of owner addresses in every UTXO.
int estimateImportGasFeeFromMockTx(int numIns, int numSigs) {
  const ATOMIC_TX_COST = 10000; // in gas
  const SIG_COST = 1000; // in gas
  const BASE_TX_SIZE = 78;
  const SINGLE_OWNER_INPUT_SIZE = 90; // in bytes
  const OUTPUT_SIZE = 60; // in bytes

  // C chain imports consolidate inputs to one output
  const numOutputs = 1;
  // Assuming each input has 1 owner
  final baseSize = BASE_TX_SIZE +
      numIns * SINGLE_OWNER_INPUT_SIZE +
      numOutputs * OUTPUT_SIZE;
  final importGas = baseSize + numSigs * SIG_COST + ATOMIC_TX_COST;
  return importGas;
}

/// Estimates the gas fee using a mock ExportTx built from the passed values.
/// @param destinationChain `X` or `P`
/// @param amount in nROI
/// @param from The C chain hex address exported from
/// @param to The destination X or P address
int estimateExportGasFeeFromMockTx(
  ExportChainsC destinationChain,
  BigInt amount,
  String from,
  String to,
) {
  final destChainId = chainIdFromAlias(destinationChain.value);
  final destChainIdBuff = cb58Decode(destChainId);
  final toBuff = stringToAddress(to);
  final netId = activeNetwork.networkId;
  final chainId = activeNetwork.cChainId;
  final chainIdBuff = cb58Decode(chainId);
  final avaxId = getAvaxAssetId();
  final avaxIdBuff = cb58Decode(avaxId);
  final txIn = EvmInput(
    address: from,
    amount: amount,
    assetId: avaxIdBuff,
  );
  final secpOut = EvmSECPTransferOutput(
    amount: amount,
    addresses: [toBuff],
  );
  final txOut = EvmTransferableOutput(
    assetId: avaxIdBuff,
    output: secpOut,
  );
  final exportTx = EvmExportTx(
    networkId: netId,
    blockchainId: chainIdBuff,
    destinationChain: destChainIdBuff,
    inputs: [txIn],
    exportedOutputs: [txOut],
  );
  final unsignedTx = EvmUnsignedTx(transaction: exportTx);
  return costExportTx(unsignedTx);
}

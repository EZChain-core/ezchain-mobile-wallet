import 'package:wallet/roi/wallet/explorer/ortelius/types.dart';
import 'package:wallet/roi/wallet/explorer/ortelius/utxo_utils.dart';

/// If any of the inputs has a different chain ID, thats the source chain
/// else return current chain
/// Returns the source chain id.
/// @param tx Tx data from the explorer.
String findSourceChain(OrteliusTx tx) {
  final baseChain = tx.chainId;
  final ins = tx.inputs ?? [];

  for (var i = 0; i < ins.length; i++) {
    final inChainId = ins[i].output.inChainId;
    if (inChainId != baseChain) return inChainId;
  }
  return baseChain;
}

/// If any of the outputs has a different chain ID, that's the destination chain
/// else return current chain
/// Returns the destination chain id.
/// @param tx Tx data from the explorer.
String findDestinationChain(OrteliusTx tx) {
  final baseChain = tx.chainId;
  final outs = tx.outputs ?? [];

  for (var i = 0; i < outs.length; i++) {
    final outChainId = outs[i].outChainId;
    if (outChainId != baseChain) return outChainId;
  }
  return baseChain;
}

/// To get the stake amount, sum the non-reward output utxos.
BigInt getStakeAmount(OrteliusTx tx) {
  final outs = tx.outputs ?? [];
  final nonRewardUtxos =
      outs.where((utxo) => !utxo.rewardUtxo && utxo.stake == true).toList();
  return getOutputTotals(nonRewardUtxos);
}

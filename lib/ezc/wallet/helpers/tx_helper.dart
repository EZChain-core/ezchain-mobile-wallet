import 'package:wallet/ezc/sdk/apis/avm/tx.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/apis/evm/tx.dart';
import 'package:wallet/ezc/sdk/apis/pvm/tx.dart';
import 'package:wallet/ezc/sdk/apis/pvm/utxos.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/wallet/network/helpers/id_from_alias.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/types.dart';
import 'package:web3dart/web3dart.dart';

Future<Transaction> buildEvmTransferNativeTx(
  String from,
  String to,
  BigInt amount,
  BigInt gasPrice,
  int gasLimit,
) async {
  final etherFromAddress = EthereumAddress.fromHex(from);
  final nonce = await web3.getTransactionCount(etherFromAddress);
  return Transaction(
    from: etherFromAddress,
    to: EthereumAddress.fromHex(to),
    maxGas: gasLimit,
    gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.wei, gasPrice),
    value: EtherAmount.fromUnitAndValue(EtherUnit.wei, amount),
    nonce: nonce,
  );
}

Future<BigInt> estimateAvaxGas(
  String from,
  String to,
  BigInt amount,
  BigInt gasPrice,
) async {
  try {
    final test = await web3.estimateGas(
      sender: EthereumAddress.fromHex(from),
      to: EthereumAddress.fromHex(to),
      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.wei, gasPrice),
      value: EtherAmount.fromUnitAndValue(EtherUnit.wei, amount),
    );
    return test;
  } catch (e) {
    return BigInt.from(21000);
  }
}

Future<AvmUnsignedTx> buildAvmExportTransaction(
  ExportChainsX destinationChain,
  AvmUTXOSet utxoSet,
  List<String> fromAddresses,
  String toAddress,
  BigInt amount, // export amount + fee
  String sourceChangeAddress,
) async {
  final destinationChainId = chainIdFromAlias(destinationChain.value);

  return await xChain.buildExportTx(
    utxoSet,
    amount,
    destinationChainId,
    [toAddress],
    fromAddresses,
    changeAddresses: [sourceChangeAddress],
  );
}

Future<PvmUnsignedTx> buildPvmExportTransaction(
  PvmUTXOSet utxoSet,
  List<String> fromAddresses,
  String toAddress,
  BigInt amount,
  String sourceChangeAddress,
  ExportChainsP destinationChain,
) async {
  final destinationChainId = chainIdFromAlias(destinationChain.value);

  return await pChain.buildExportTx(
    utxoSet,
    amount,
    destinationChainId,
    [toAddress],
    fromAddresses,
    changeAddresses: [sourceChangeAddress],
  );
}

Future<EvmUnsignedTx> buildEvmExportTransaction(
  List<String> fromAddresses,
  String toAddress,
  BigInt amount,
  String fromAddressBech,
  ExportChainsC destinationChain,
  BigInt fee,
) async {
  final destinationChainId = chainIdFromAlias(destinationChain.value);
  final fromAddressHex = fromAddresses[0];
  final nonce =
      await web3.getTransactionCount(EthereumAddress.fromHex(fromAddressHex));
  final avaxAssetIdBuff = await xChain.getAVAXAssetId();
  final avaxAssetIdString = cb58Encode(avaxAssetIdBuff!);

  final unsignedTx = await cChain.buildExportTx(
    amount,
    avaxAssetIdString,
    destinationChainId,
    fromAddressHex,
    fromAddressBech,
    [toAddress],
    nonce: nonce,
    fee: fee,
  );
  return unsignedTx;
}

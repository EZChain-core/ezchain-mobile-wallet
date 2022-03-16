import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/avm/minter_set.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/tx.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/apis/evm/tx.dart';
import 'package:wallet/ezc/sdk/apis/pvm/tx.dart';
import 'package:wallet/ezc/sdk/apis/pvm/utxos.dart';
import 'package:wallet/ezc/sdk/common/output.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/payload.dart';
import 'package:wallet/ezc/wallet/asset/erc20/erc20.dart';
import 'package:wallet/ezc/wallet/network/helpers/id_from_alias.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/types.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

Future<Transaction> buildEvmTransferNativeTx(
  String from,
  String to,
  BigInt amount,
  BigInt gasPrice,
  int gasLimit,
) async {
  final etherFromAddress = EthereumAddress.fromHex(from);
  final nonce = await web3Client.getTransactionCount(
    etherFromAddress,
    atBlock: const BlockNum.pending(),
  );
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
    return await web3Client.estimateGas(
      sender: EthereumAddress.fromHex(from),
      to: EthereumAddress.fromHex(to),
      gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.wei, gasPrice),
      value: EtherAmount.fromUnitAndValue(EtherUnit.wei, amount),
    );
  } catch (e) {
    return BigInt.from(21000);
  }
}

Future<Transaction> buildCustomEvmTx(
  String from,
  String to,
  BigInt amount,
  BigInt gasPrice,
  int gasLimit, {
  String? data,
  int? nonce,
}) async {
  final etherFromAddress = EthereumAddress.fromHex(from);
  nonce ??= await web3Client.getTransactionCount(
    etherFromAddress,
    atBlock: const BlockNum.pending(),
  );
  Uint8List? dataBytes;
  if (data != null) {
    hexToBytes(data);
  }
  return Transaction(
    from: etherFromAddress,
    to: EthereumAddress.fromHex(to),
    maxGas: gasLimit,
    gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.wei, gasPrice),
    nonce: nonce,
    data: dataBytes,
    value: EtherAmount.fromUnitAndValue(EtherUnit.wei, amount),
  );
}

Future<Transaction> buildEvmTransferErc20Tx(
  String evmPrivateKey,
  String from,
  String to,
  BigInt amount,
  BigInt gasPrice,
  int gasLimit,
  String contractAddress,
) async {
  final erc20 = ERC20(
    address: EthereumAddress.fromHex(contractAddress),
    client: web3Client,
  );
  final credentials = EthPrivateKey.fromHex(evmPrivateKey);
  final tokenTx = await erc20.transfer(
    EthereumAddress.fromHex(to),
    amount,
    credentials: credentials,
  );
  return await buildCustomEvmTx(
    from,
    to,
    amount,
    gasPrice,
    gasLimit,
    data: tokenTx,
  );
}

Future<BigInt> estimateErc20Gas(
  String contractAddress,
  String from,
  String to,
  BigInt amount,
) async {
  try {
    final erc20 = ERC20(
      address: EthereumAddress.fromHex(contractAddress),
      client: web3Client,
    );
    final method = erc20.self.function('transfer');

    final gas = await web3Client.estimateGas(
      sender: EthereumAddress.fromHex(from),
      to: EthereumAddress.fromHex(contractAddress),
      data: method.encodeCall([EthereumAddress.fromHex(to), amount]),
    );

    return BigInt.from(gas.toDouble() * 1.1);
  } catch (e) {
    return BigInt.from(31000);
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
  final nonce = await web3Client.getTransactionCount(
    EthereumAddress.fromHex(fromAddressHex),
    atBlock: const BlockNum.pending(),
  );
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

Future<AvmUnsignedTx> buildCreateNFTFamilyTx(
  String name,
  String symbol,
  int groupNum,
  List<String> fromAddresses,
  String minterAddress,
  String changeAddress,
  AvmUTXOSet utxoSet,
) async {
  final minterSets = <MinterSet>[];
  for (var i = 0; i < groupNum; i++) {
    final minterSet = MinterSet(threshold: 1, minters: [minterAddress]);
    minterSets.add(minterSet);
  }

  final unsignedTx = await xChain.buildCreateNFTAssetTx(
    utxoSet,
    fromAddresses,
    [changeAddress],
    minterSets,
    name,
    symbol,
  );
  return unsignedTx;
}

Future<AvmUnsignedTx> buildMintNFTTx(
  AvmUTXO mintUtxo,
  PayloadBase payload,
  int quantity,
  String ownerAddress,
  String changeAddress,
  List<String> fromAddresses,
  AvmUTXOSet utxoSet,
) async {
  final addressBuff = parseAddress(ownerAddress, 'X');
  final owners = <OutputOwners>[];

  final sourceAddresses = fromAddresses;

  for (var i = 0; i < quantity; i++) {
    final owner = OutputOwners(addresses: [addressBuff]);
    owners.add(owner);
  }

  final groupId = (mintUtxo.getOutput() as AvmNFTOutput).getGroupId();

  final unsignedTx = await xChain.buildCreateNFTMintTx(
    utxoSet,
    owners,
    sourceAddresses,
    [changeAddress],
    [mintUtxo.getUTXOId()],
    groupId,
    payload,
  );
  return unsignedTx;
}

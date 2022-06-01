import 'dart:typed_data';

import 'package:wallet/common/logger.dart';
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
import 'package:wallet/ezc/wallet/asset/erc20/types.dart';
import 'package:wallet/ezc/wallet/asset/erc721/erc721.dart';
import 'package:wallet/ezc/wallet/network/helpers/id_from_alias.dart';
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:wallet/ezc/wallet/types.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

Future<int> getEvmTransactionCount(
  String address, {
  BlockNum atBlock = const BlockNum.pending(),
}) async {
  final etherAddress = EthereumAddress.fromHex(address);
  return await web3Client.getTransactionCount(
    etherAddress,
    atBlock: atBlock,
  );
}

Future<Transaction> buildEvmTransferNativeTx(
  String from,
  String to,
  BigInt amount,
  BigInt gasPrice,
  int gasLimit, {
  int? nonce,
}) async {
  return Transaction(
    from: EthereumAddress.fromHex(from),
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
  int gasLimit,
  Uint8List data, {
  int? nonce,
}) async {
  final etherFromAddress = EthereumAddress.fromHex(from);
  nonce ??= await web3Client.getTransactionCount(
    etherFromAddress,
    atBlock: const BlockNum.pending(),
  );
  return Transaction(
    from: etherFromAddress,
    to: EthereumAddress.fromHex(to),
    maxGas: gasLimit,
    gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.wei, gasPrice),
    nonce: nonce,
    data: data,
    value: EtherAmount.fromUnitAndValue(EtherUnit.wei, amount),
  );
}

Future<Transaction> buildEvmTransferErc20Tx(
  ERC20 erc20,
  String evmPrivateKey,
  String from,
  String to,
  BigInt amount,
  BigInt gasPrice,
  int gasLimit, {
  int? nonce,
}) async {
  final method = erc20.self.function('transfer');
  int gasLimit,
  String contractAddress, {
  int? nonce,
}) async {
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
    method.encodeCall([EthereumAddress.fromHex(to), amount]),
    nonce: nonce,
    data: tokenTx,
    nonce: nonce,
  );
}

Future<BigInt> estimateErc20Gas(
  ERC20 erc20,
  String from,
  String to,
  BigInt amount,
) async {
  try {
    final contractAddress = erc20.self.address;
    final method = erc20.self.function('transfer');

    return await web3Client.estimateGas(
      sender: EthereumAddress.fromHex(from),
      to: contractAddress,
      data: method.encodeCall([EthereumAddress.fromHex(to), amount]),
    );
  } catch (e) {
    return BigInt.from(31000);
  }
}

Future<Transaction> buildEvmTransferErc721Tx(
  ERC721 erc721,
  String from,
  String to,
  BigInt gasPrice,
  int gasLimit,
  BigInt tokenId, {
  int? nonce,
}) async {
  final contractAddress = erc721.self.address;
  final fromEther = EthereumAddress.fromHex(from);
  final toEther = EthereumAddress.fromHex(to);
  final method = erc721.self.functions.singleWhere((function) =>
      function.encodeName() == 'safeTransferFrom(address,address,uint256)');
  nonce ??= await web3Client.getTransactionCount(
    fromEther,
    atBlock: const BlockNum.pending(),
  );
  return Transaction(
    from: fromEther,
    to: contractAddress,
    maxGas: gasLimit,
    gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.wei, gasPrice),
    nonce: nonce,
    data: method.encodeCall([fromEther, toEther, tokenId]),
  );
}

Future<BigInt> estimateErc721TransferGas(
  ERC721 erc721,
  String from,
  String to,
  BigInt tokenId,
) async {
  try {
    final contractAddress = erc721.self.address;
    final method = erc721.self.functions.singleWhere((function) =>
        function.encodeName() == 'safeTransferFrom(address,address,uint256)');
    final fromEther = EthereumAddress.fromHex(from);
    final toEther = EthereumAddress.fromHex(to);
    return await web3Client.estimateGas(
      sender: fromEther,
      to: contractAddress,
      data: method.encodeCall([fromEther, toEther, tokenId]),
    );
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

  final groupId = (mintUtxo.getOutput() as AvmNFTMintOutput).getGroupId();

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

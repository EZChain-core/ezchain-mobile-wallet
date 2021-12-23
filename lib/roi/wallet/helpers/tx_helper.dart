import 'dart:convert';
import 'dart:typed_data';

import 'package:wallet/roi/wallet/network/network.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

Future<Transaction> buildEvmTransferNativeTx(String from, String to,
    BigInt amount, BigInt gasPrice, int gasLimit) async {
  final etherFromAddress = EthereumAddress.fromHex(from);
  final nonce = await web3.getTransactionCount(etherFromAddress);
  return Transaction(
    from: etherFromAddress,
    to: EthereumAddress.fromHex(to),
    maxGas: gasLimit,
    gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, gasPrice),
    value: EtherAmount.fromUnitAndValue(EtherUnit.wei, amount),
    data: Uint8List.fromList(utf8.encode("0x")),
    nonce: nonce,
  );
}

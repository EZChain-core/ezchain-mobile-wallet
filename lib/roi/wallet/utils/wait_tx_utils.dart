import 'package:wallet/roi/sdk/apis/avm/model/get_tx_status.dart'
    as AvmTxStatus;
import 'package:wallet/roi/sdk/apis/pvm/model/get_tx_status.dart'
    as PvmTxStatus;
import 'package:wallet/roi/wallet/network/network.dart';
import 'package:web3dart/web3dart.dart';

Future<String> waitTxX(String txId, {int tryCount = 10}) async {
  assert(tryCount > 0, "Timeout");
  final AvmTxStatus.TxStatus txStatus;
  String? reason;
  try {
    final response = await xChain.getTxStatus(txId);
    txStatus = response.status;
    reason = response.reason;
  } catch (e) {
    throw Exception("Unable to get transaction status.");
  }
  if (txStatus == AvmTxStatus.TxStatus.unknown ||
      txStatus == AvmTxStatus.TxStatus.processing) {
    return Future.delayed(const Duration(seconds: 1),
        () => waitTxX(txId, tryCount: tryCount - 1));
  } else if (txStatus == AvmTxStatus.TxStatus.rejected) {
    throw Exception(reason);
  } else if (txStatus == AvmTxStatus.TxStatus.accepted) {
    return txId;
  }
  return txId;
}

Future<String> waitTxP(String txId, {int tryCount = 10}) async {
  assert(tryCount > 0, "Timeout");
  final PvmTxStatus.TxStatus txStatus;
  String? reason;
  try {
    final response = await pChain.getTxStatus(txId);
    txStatus = response.status;
    reason = response.reason;
  } catch (e) {
    throw Exception("Unable to get transaction status.");
  }
  if (txStatus == PvmTxStatus.TxStatus.unknown ||
      txStatus == PvmTxStatus.TxStatus.processing) {
    return Future.delayed(const Duration(seconds: 1),
        () => waitTxX(txId, tryCount: tryCount - 1));
  } else if (txStatus == PvmTxStatus.TxStatus.dropped) {
    throw Exception(reason);
  } else if (txStatus == PvmTxStatus.TxStatus.committed) {
    return txId;
  }
  return txId;
}

Future<String> waitTxEvm(String txHash, {int tryCount = 10}) async {
  assert(tryCount > 0, "Timeout");
  TransactionReceipt? receipt;
  try {
    receipt = await web3.getTransactionReceipt(txHash);
  } catch (e) {
    throw Exception("Unable to get transaction receipt.");
  }
  if (receipt == null) {
    return Future.delayed(const Duration(seconds: 1),
        () => waitTxEvm(txHash, tryCount: tryCount - 1));
  } else {
    if (receipt.status == true) {
      return txHash;
    } else {
      throw Exception("Transaction reverted.");
    }
  }
}

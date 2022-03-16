import 'package:wallet/ezc/sdk/apis/avm/model/get_tx_status.dart'
    as avm_tx_status;
import 'package:wallet/ezc/sdk/apis/pvm/model/get_tx_status.dart'
    as pvm_tx_status;
import 'package:wallet/ezc/sdk/apis/evm/model/get_atomic_tx_status.dart'
    as evm_tx_status;
import 'package:wallet/ezc/wallet/network/network.dart';
import 'package:web3dart/web3dart.dart';

Future<String> waitTxX(String txId, {int tryCount = 15}) async {
  if (tryCount <= 0) {
    return throw ("Wait Tx X Timeout");
  }
  final avm_tx_status.TxStatus txStatus;
  String? reason;
  try {
    final response = await xChain.getTxStatus(txId);
    txStatus = response.status;
    reason = response.reason;
  } catch (e) {
    throw Exception("Unable to get transaction status.");
  }
  if (txStatus == avm_tx_status.TxStatus.unknown ||
      txStatus == avm_tx_status.TxStatus.processing) {
    return Future.delayed(const Duration(seconds: 1),
        () => waitTxX(txId, tryCount: tryCount - 1));
  } else if (txStatus == avm_tx_status.TxStatus.rejected) {
    throw Exception(reason);
  } else if (txStatus == avm_tx_status.TxStatus.accepted) {
    return txId;
  }
  return txId;
}

Future<String> waitTxP(String txId, {int tryCount = 15}) async {
  if (tryCount <= 0) {
    return throw ("Wait Tx P Timeout");
  }
  final pvm_tx_status.TxStatus txStatus;
  String? reason;
  try {
    final response = await pChain.getTxStatus(txId);
    txStatus = response.status;
    reason = response.reason;
  } catch (e) {
    throw Exception("Unable to get transaction status.");
  }
  if (txStatus == pvm_tx_status.TxStatus.unknown ||
      txStatus == pvm_tx_status.TxStatus.processing) {
    return Future.delayed(const Duration(seconds: 1),
        () => waitTxP(txId, tryCount: tryCount - 1));
  } else if (txStatus == pvm_tx_status.TxStatus.dropped) {
    throw Exception(reason);
  } else if (txStatus == pvm_tx_status.TxStatus.committed) {
    return txId;
  }
  return txId;
}

Future<String> waitTxC(String txId, {int tryCount = 15}) async {
  if (tryCount <= 0) {
    return throw ("Wait Tx C Timeout");
  }
  final evm_tx_status.TxStatus txStatus;
  String? reason;
  try {
    final response = await cChain.getAtomicTxStatus(txId);
    txStatus = response.status;
    reason = response.reason;
  } catch (e) {
    throw Exception("Unable to get transaction status.");
  }
  if (txStatus == evm_tx_status.TxStatus.unknown ||
      txStatus == evm_tx_status.TxStatus.processing) {
    return Future.delayed(const Duration(seconds: 1),
        () => waitTxC(txId, tryCount: tryCount - 1));
  } else if (txStatus == evm_tx_status.TxStatus.dropped) {
    throw Exception(reason);
  } else if (txStatus == evm_tx_status.TxStatus.accepted) {
    return txId;
  }
  return txId;
}

Future<String> waitTxEvm(String txHash, {int tryCount = 15}) async {
  if (tryCount <= 0) {
    return throw ("Wait Tx Evm Timeout");
  }
  TransactionReceipt? receipt;
  try {
    receipt = await web3Client.getTransactionReceipt(txHash);
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
      print("txHash = $txHash, receipt = $receipt");
      throw Exception("Transaction reverted.");
    }
  }
}

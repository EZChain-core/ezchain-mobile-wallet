import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/evm/constants.dart';
import 'package:wallet/ezc/sdk/apis/evm/export_tx.dart';
import 'package:wallet/ezc/sdk/apis/evm/inputs.dart';
import 'package:wallet/ezc/sdk/apis/evm/model/get_asset_description.dart';
import 'package:wallet/ezc/sdk/apis/evm/model/get_atomic_tx_status.dart';
import 'package:wallet/ezc/sdk/apis/evm/model/get_utxos.dart';
import 'package:wallet/ezc/sdk/apis/evm/model/issue_tx.dart';
import 'package:wallet/ezc/sdk/apis/evm/outputs.dart';
import 'package:wallet/ezc/sdk/apis/evm/rest_client.dart';
import 'package:wallet/ezc/sdk/apis/evm/tx.dart';
import 'package:wallet/ezc/sdk/apis/evm/utxos.dart';
import 'package:wallet/ezc/sdk/apis/ezc_api.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/common/output.dart';
import 'package:wallet/ezc/sdk/common/rpc/rpc_request.dart';
import 'package:wallet/ezc/sdk/ezc.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart' as bindtools;

abstract class EvmApi implements EZCApi {
  Future<GetUTXOsResponse> getUTXOs(
    List<String> addresses, {
    String? sourceChain,
    int limit = 0,
    GetUTXOsStartIndex? startIndex,
  });

  Future<EvmUnsignedTx> buildImportTx(
    EvmUTXOSet utxoSet,
    String toAddress,
    List<String> ownerAddresses,
    String sourceChain,
    List<String> fromAddresses, {
    BigInt? fee,
  });

  Future<EvmUnsignedTx> buildExportTx(
    BigInt amount,
    String assetId,
    String destinationChainId,
    String fromAddressHex,
    String fromAddressBech,
    List<String> toAddresses, {
    int nonce = 0,
    BigInt? lockTime,
    int threshold = 1,
    BigInt? fee,
  });

  Future<String> issueTx(EvmTx tx);

  Future<GetAtomicTxStatusResponse> getAtomicTxStatus(String txId);

  Future<String> getBaseFee();

  Future<String> getMaxPriorityFeePerGas();

  factory EvmApi.create({
    required EZCNetwork ezcNetwork,
    String ezcEndPoint = "/ext/bc/C/ezc",
    String rpcEndPoint = "/ext/bc/C/rpc",
    String xEndPoint = "/ext/bc/X",
    String blockChainId = "",
  }) {
    return _EvmApiImpl(
        ezcNetwork: ezcNetwork,
        ezcEndPoint: ezcEndPoint,
        rpcEndPoint: rpcEndPoint,
        xEndPoint: xEndPoint,
        blockChainId: blockChainId);
  }
}

class _EvmApiImpl implements EvmApi {
  @override
  EZCNetwork ezcNetwork;

  @override
  EZCKeyChain get keyChain => _keyChain;

  late EZCKeyChain _keyChain;

  String blockChainId;

  String? blockchainAlias;

  Uint8List? avaxAssetId;

  late EvmAvaxRestClient evmAvaxRestClient;
  late EvmRpcRestClient evmRpcRestClient;
  late EvmXRestClient evmXRestClient;

  _EvmApiImpl({
    required this.ezcNetwork,
    required String ezcEndPoint,
    required String rpcEndPoint,
    required String xEndPoint,
    required this.blockChainId,
  }) {
    final networkId = ezcNetwork.networkId;
    final network = networks[networkId];
    final String alias;
    if (network != null) {
      alias = network.findAliasByBlockChainId(blockChainId) ?? "";
    } else {
      alias = blockChainId;
    }
    _keyChain = EZCKeyChain(chainId: alias, hrp: ezcNetwork.hrp);
    final dio = ezcNetwork.dio;

    evmAvaxRestClient = EvmAvaxRestClient(
      dio,
      baseUrl: dio.options.baseUrl + ezcEndPoint,
    );

    evmRpcRestClient = EvmRpcRestClient(
      dio,
      baseUrl: dio.options.baseUrl + rpcEndPoint,
    );

    evmXRestClient = EvmXRestClient(
      dio,
      baseUrl: dio.options.baseUrl + xEndPoint,
    );
  }

  @override
  EZCKeyChain newKeyChain() {
    final alias = getBlockchainAlias();
    if (alias == null) {
      _keyChain = EZCKeyChain(chainId: blockChainId, hrp: ezcNetwork.hrp);
    } else {
      _keyChain = EZCKeyChain(chainId: alias, hrp: ezcNetwork.hrp);
    }
    return keyChain;
  }

  @override
  String? getBlockchainAlias() {
    if (blockchainAlias == null) {
      final networkId = ezcNetwork.networkId;
      final network = networks[networkId];
      blockchainAlias = network?.findAliasByBlockChainId(blockChainId);
    }
    return blockchainAlias;
  }

  @override
  String getBlockchainId() => blockChainId;

  @override
  String addressFromBuffer(Uint8List address) {
    final chainId = getBlockchainAlias() ?? blockChainId;
    return Serialization.instance.bufferToType(
      address,
      SerializedType.bech32,
      args: [chainId, ezcNetwork.hrp],
    );
  }

  @override
  Uint8List parseAddress(String address) {
    final alias = getBlockchainAlias();
    return bindtools.parseAddress(
      address,
      blockChainId,
      alias: alias,
      addressLength: ADDRESSLENGTH,
    );
  }

  @override
  Future<GetUTXOsResponse> getUTXOs(
    List<String> addresses, {
    String? sourceChain,
    int limit = 0,
    GetUTXOsStartIndex? startIndex,
  }) async {
    final request = GetUTXOsRequest(
      addresses: addresses,
      sourceChain: sourceChain,
      limit: limit,
      startIndex: startIndex,
    ).toRpc();
    final response = await evmAvaxRestClient.getUTXOs(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }

  @override
  Future<EvmUnsignedTx> buildImportTx(
    EvmUTXOSet utxoSet,
    String toAddress,
    List<String> ownerAddresses,
    String sourceChain,
    List<String> fromAddresses, {
    BigInt? fee,
  }) async {
    final utxoResponse = await getUTXOs(
      ownerAddresses,
      sourceChain: sourceChain,
    );
    final atomicUTXOs = utxoResponse.getUTXOs();
    final networkId = ezcNetwork.networkId;
    final avaxAssetId = networks[networkId]!.x.avaxAssetId;
    final avaxAssetIdBuff = bindtools.cb58Decode(avaxAssetId);
    final atomics = atomicUTXOs.getAllUTXOs();
    if (atomics.isEmpty) {
      throw Exception(
          "Error - EVMAPI.buildImportTx: no atomic utxos to import");
    }
    return utxoSet.buildImportTx(
      networkId,
      bindtools.cb58Decode(blockChainId),
      toAddress,
      atomics,
      sourceChain: bindtools.cb58Decode(sourceChain),
      fee: fee,
      feeAssetId: avaxAssetIdBuff,
    );
  }

  @override
  Future<EvmUnsignedTx> buildExportTx(
    BigInt amount,
    String assetId,
    String destinationChainId,
    String fromAddressHex,
    String fromAddressBech,
    List<String> toAddresses, {
    int nonce = 0,
    BigInt? lockTime,
    int threshold = 1,
    BigInt? fee,
  }) async {
    lockTime ??= BigInt.zero;
    fee ??= BigInt.zero;

    final prefixes = <String, bool>{};
    for (var address in toAddresses) {
      prefixes[address.split("-")[0]] = true;
    }
    if (prefixes.keys.length != 1) {
      throw Exception(
          "Error - EVMAPI.buildExportTx: To addresses must have the same chainID prefix.");
    }

    final destinationChain = bindtools.cb58Decode(destinationChainId);

    if (destinationChain.length != 32) {
      throw Exception(
          "Error - EVMAPI.buildExportTx: Destination ChainID must be 32 bytes in length.");
    }

    final assetDescription = await _getAssetDescription(primaryAssetAlias);
    final evmInputs = <EvmInput>[];

    if (assetDescription.assetId == assetId) {
      final evmInput = EvmInput(
        address: fromAddressHex,
        amount: amount + fee,
        assetId: assetId,
        nonce: nonce,
      );
      evmInput.addSignatureIdx(0, bindtools.stringToAddress(fromAddressBech));
      evmInputs.add(evmInput);
    } else {
      final evmAvaxInput = EvmInput(
        address: fromAddressHex,
        amount: fee,
        assetId: assetDescription.assetId,
        nonce: nonce,
      );
      evmAvaxInput.addSignatureIdx(
          0, bindtools.stringToAddress(fromAddressBech));
      evmInputs.add(evmAvaxInput);

      final evmANTInput = EvmInput(
        address: fromAddressHex,
        amount: amount,
        assetId: assetId,
        nonce: nonce,
      );
      evmANTInput.addSignatureIdx(
          0, bindtools.stringToAddress(fromAddressBech));
      evmInputs.add(evmANTInput);
    }

    final to = toAddresses
        .map((address) => bindtools.stringToAddress(address))
        .toList();

    final exportedOuts = <EvmTransferableOutput>[];
    final secpTransferOutput = EvmSECPTransferOutput(
      amount: amount,
      addresses: to,
      lockTime: lockTime,
      threshold: threshold,
    );

    final transferableOutput = EvmTransferableOutput(
      assetId: bindtools.cb58Decode(assetId),
      output: secpTransferOutput,
    );
    exportedOuts.add(transferableOutput);

    evmInputs.sort(EvmOutput.comparator());
    exportedOuts.sort(StandardParseableOutput.comparator());
    final exportTx = EvmExportTx(
      networkId: ezcNetwork.networkId,
      blockchainId: bindtools.cb58Decode(blockChainId),
      destinationChain: destinationChain,
      inputs: evmInputs,
      exportedOutputs: exportedOuts,
    );

    return EvmUnsignedTx(transaction: exportTx);
  }

  @override
  Future<String> issueTx(EvmTx tx) async {
    final transaction = tx.toString();
    final request = IssueTxRequest(tx: transaction).toRpc();
    final response = await evmAvaxRestClient.issueTx(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result.txId;
  }

  @override
  Future<GetAtomicTxStatusResponse> getAtomicTxStatus(String txId) async {
    final request = GetAtomicTxStatusRequest(txId: txId).toRpc();
    final response = await evmAvaxRestClient.getAtomicTxStatus(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }

  @override
  Future<String> getBaseFee() async {
    const request = RpcRequest(method: "eth_baseFee", params: []);
    final response = await evmRpcRestClient.getEthBaseFee(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }

  @override
  Future<String> getMaxPriorityFeePerGas() async {
    const request = RpcRequest(method: "eth_maxPriorityFeePerGas", params: []);
    final response = await evmRpcRestClient.getEthMaxPriorityFeePerGas(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }

  Future<GetAssetDescriptionResponse> _getAssetDescription(
    String assetId,
  ) async {
    final response = await evmXRestClient.getAssetDescription(
        GetAssetDescriptionRequest(assetId: assetId).toRpc());
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }
}

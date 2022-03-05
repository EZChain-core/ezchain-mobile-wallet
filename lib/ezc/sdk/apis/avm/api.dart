import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/key_chain.dart';
import 'package:wallet/ezc/sdk/apis/avm/model/get_asset_description.dart';
import 'package:wallet/ezc/sdk/apis/avm/model/get_tx_status.dart';
import 'package:wallet/ezc/sdk/apis/avm/model/get_utxos.dart';
import 'package:wallet/ezc/sdk/apis/avm/model/issue_tx.dart';
import 'package:wallet/ezc/sdk/apis/avm/rest_client.dart';
import 'package:wallet/ezc/sdk/apis/avm/tx.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/apis/ezc_api.dart';
import 'package:wallet/ezc/sdk/ezc.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart' as bindtools;
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

abstract class AvmApi implements EZCApi {
  Future<AvmUnsignedTx> buildBaseTx(
    AvmUTXOSet utxoSet,
    BigInt amount,
    String assetId,
    List<String> toAddresses,
    List<String> fromAddresses,
    List<String> changeAddresses, {
    Uint8List? memo,
  });

  Future<AvmUnsignedTx> buildImportTx(
    AvmUTXOSet utxoSet,
    List<String> ownerAddresses,
    String sourceChain,
    List<String> toAddresses,
    List<String> fromAddresses, {
    List<String>? changeAddresses,
    Uint8List? memo,
    BigInt? asOf,
    BigInt? lockTime,
    int threshold = 1,
  });

  Future<AvmUnsignedTx> buildExportTx(
    AvmUTXOSet utxoSet,
    BigInt amount,
    String destinationChainId,
    List<String> toAddresses,
    List<String> fromAddresses, {
    List<String>? changeAddresses,
    Uint8List? memo,
    BigInt? asOf,
    BigInt? lockTime,
    int threshold = 1,
    String? assetId,
  });

  Future<GetUTXOsResponse> getUTXOs(
    List<String> addresses, {
    String? sourceChain,
    int limit = 0,
    GetUTXOsStartIndex? startIndex,
  });

  Future<GetAssetDescriptionResponse> getAssetDescription(String assetId);

  Future<Uint8List?> getAVAXAssetId({bool refresh = false});

  Future<String> issueTx(AvmTx tx);

  Future<GetTxStatusResponse> getTxStatus(String txId);

  BigInt getTxFee();

  factory AvmApi.create(
      {required EZCNetwork ezcNetwork,
      String endPoint = "/ext/bc/X",
      String blockChainId = ""}) {
    return _AvmApiImpl(
      ezcNetwork: ezcNetwork,
      endPoint: endPoint,
      blockChainId: blockChainId,
    );
  }
}

class _AvmApiImpl implements AvmApi {
  @override
  EZCNetwork ezcNetwork;

  @override
  AvmKeyChain get keyChain => _keyChain;

  late AvmKeyChain _keyChain;

  String blockChainId;

  String? blockchainAlias;

  Uint8List? avaxAssetId;

  late AvmRestClient avmRestClient;

  BigInt? _txFee;

  _AvmApiImpl(
      {required this.ezcNetwork,
      required String endPoint,
      required this.blockChainId}) {
    final networkId = ezcNetwork.networkId;
    final network = networks[networkId];
    final String alias;
    if (network != null) {
      alias = network.findAliasByBlockChainId(blockChainId) ?? "";
    } else {
      alias = blockChainId;
    }
    _keyChain = AvmKeyChain(chainId: alias, hrp: ezcNetwork.hrp);
    final dio = ezcNetwork.dio;
    avmRestClient = AvmRestClient(dio, baseUrl: dio.options.baseUrl + endPoint);
  }

  @override
  AvmKeyChain newKeyChain() {
    final alias = getBlockchainAlias();
    if (alias == null) {
      _keyChain = AvmKeyChain(chainId: blockChainId, hrp: ezcNetwork.hrp);
    } else {
      _keyChain = AvmKeyChain(chainId: alias, hrp: ezcNetwork.hrp);
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
  String addressFromBuffer(Uint8List address) {
    final chainId = getBlockchainAlias() ?? blockChainId;
    return Serialization.instance.bufferToType(
      address,
      SerializedType.bech32,
      args: [chainId, ezcNetwork.hrp],
    );
  }

  @override
  BigInt getTxFee() {
    _txFee ??= _getDefaultTxFee();
    return _txFee!;
  }

  @override
  Future<AvmUnsignedTx> buildBaseTx(
    AvmUTXOSet utxoSet,
    BigInt amount,
    String assetId,
    List<String> toAddresses,
    List<String> fromAddresses,
    List<String> changeAddresses, {
    Uint8List? memo,
    int threshold = 1,
  }) async {
    final to = toAddresses.map((e) => bindtools.stringToAddress(e)).toList();
    final from =
        fromAddresses.map((e) => bindtools.stringToAddress(e)).toList();
    final change =
        changeAddresses.map((e) => bindtools.stringToAddress(e)).toList();

    final buildUnsignedTx = utxoSet.buildBaseTx(
        ezcNetwork.networkId,
        bindtools.cb58Decode(blockChainId),
        amount,
        bindtools.cb58Decode(assetId),
        to,
        from,
        changeAddresses: change,
        fee: getTxFee(),
        feeAssetId: await getAVAXAssetId(),
        memo: memo,
        threshold: threshold);
    if (!await _checkGooseEgg(buildUnsignedTx)) {
      throw Exception("Error - AVMAPI.buildBaseTx:Failed Goose Egg Check");
    }
    return buildUnsignedTx;
  }

  @override
  Future<AvmUnsignedTx> buildImportTx(
    AvmUTXOSet utxoSet,
    List<String> ownerAddresses,
    String sourceChain,
    List<String> toAddresses,
    List<String> fromAddresses, {
    List<String>? changeAddresses,
    Uint8List? memo,
    BigInt? asOf,
    BigInt? lockTime,
    int threshold = 1,
  }) async {
    asOf ??= unixNow();
    lockTime ??= BigInt.zero;

    final to = toAddresses.map((a) => bindtools.stringToAddress(a)).toList();
    final from =
        fromAddresses.map((a) => bindtools.stringToAddress(a)).toList();
    final List<Uint8List>? change;
    if (changeAddresses == null) {
      change = null;
    } else {
      change =
          changeAddresses.map((a) => bindtools.stringToAddress(a)).toList();
    }

    final atomicUTXOs =
        (await getUTXOs(ownerAddresses, sourceChain: sourceChain)).getUTXOs();

    final avaxAssetId = await getAVAXAssetId();

    final atomics = atomicUTXOs.getAllUTXOs();

    final buildUnsignedTx = utxoSet.buildImportTx(
      ezcNetwork.networkId,
      bindtools.cb58Decode(blockChainId),
      atomics,
      to,
      from,
      changeAddresses: change,
      sourceChain: bindtools.cb58Decode(sourceChain),
      fee: getTxFee(),
      feeAssetId: avaxAssetId,
      memo: memo,
      asOf: asOf,
      lockTime: lockTime,
      threshold: threshold,
    );
    if (!await _checkGooseEgg(buildUnsignedTx)) {
      throw Exception("Error - AVMAPI.buildImportTx:Failed Goose Egg Check");
    }
    return buildUnsignedTx;
  }

  @override
  Future<AvmUnsignedTx> buildExportTx(
    AvmUTXOSet utxoSet,
    BigInt amount,
    String destinationChainId,
    List<String> toAddresses,
    List<String> fromAddresses, {
    List<String>? changeAddresses,
    Uint8List? memo,
    BigInt? asOf,
    BigInt? lockTime,
    int threshold = 1,
    String? assetId,
  }) async {
    asOf ??= unixNow();
    lockTime ??= BigInt.zero;

    final prefixes = <String, bool>{};
    for (var address in toAddresses) {
      prefixes[address.split("-")[0]] = true;
    }
    if (prefixes.keys.length != 1) {
      throw Exception(
          "Error - AVMAPI.buildExportTx: To addresses must have the same chainID prefix.");
    }

    final destinationChain = bindtools.cb58Decode(destinationChainId);

    if (destinationChain.length != 32) {
      throw Exception(
          "Error - AVMAPI.buildExportTx: Destination ChainID must be 32 bytes in length.");
    }

    final to = toAddresses.map((a) => bindtools.stringToAddress(a)).toList();
    final from =
        fromAddresses.map((a) => bindtools.stringToAddress(a)).toList();
    final List<Uint8List>? change;
    if (changeAddresses == null) {
      change = null;
    } else {
      change =
          changeAddresses.map((a) => bindtools.stringToAddress(a)).toList();
    }

    final avaxAssetId = await getAVAXAssetId();
    if (avaxAssetId != null) {
      assetId = bindtools.cb58Encode(avaxAssetId);
    }

    final builtUnsignedTx = utxoSet.buildExportTx(
        ezcNetwork.networkId,
        bindtools.cb58Decode(blockChainId),
        amount,
        bindtools.cb58Decode(assetId),
        destinationChain,
        to,
        from,
        changeAddresses: change,
        fee: getTxFee(),
        feeAssetId: avaxAssetId,
        memo: memo,
        asOf: asOf,
        lockTime: lockTime,
        threshold: threshold);

    if (!await _checkGooseEgg(builtUnsignedTx)) {
      throw Exception("Error - AVMAPI.buildExportTx:Failed Goose Egg Check");
    }
    return builtUnsignedTx;
  }

  Future<bool> _checkGooseEgg(AvmUnsignedTx utx, {BigInt? outTotal}) async {
    outTotal ??= BigInt.zero;
    final avaxAssetId = await getAVAXAssetId();
    if (avaxAssetId == null) return false;
    final outputTotal =
        outTotal > BigInt.zero ? outTotal : utx.getOutputTotal(avaxAssetId);
    final fee = utx.getBurn(avaxAssetId);
    if (fee <= ONEAVAX * BigInt.from(10) || fee <= outputTotal) {
      return true;
    } else {
      return false;
    }
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
    final response = await avmRestClient.getUTXOs(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }

  @override
  Future<GetAssetDescriptionResponse> getAssetDescription(
      String assetId) async {
    final response = await avmRestClient.getAssetDescription(
        GetAssetDescriptionRequest(assetId: assetId).toRpc());
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }

  @override
  Future<Uint8List?> getAVAXAssetId({bool refresh = false}) async {
    if (avaxAssetId == null || refresh) {
      try {
        final response = await getAssetDescription(primaryAssetAlias);
        avaxAssetId = bindtools.cb58Decode(response.assetId);
      } catch (e) {}
    }
    return avaxAssetId;
  }

  @override
  Future<String> issueTx(AvmTx tx) async {
    final transaction = tx.toString();
    final request = IssueTxRequest(tx: transaction).toRpc();
    final response = await avmRestClient.issueTx(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result.txId;
  }

  @override
  Future<GetTxStatusResponse> getTxStatus(String txId) async {
    final request = GetTxStatusRequest(txId: txId).toRpc();
    final response = await avmRestClient.getTxStatus(request);
    final result = response.result;
    if (result == null) throw Exception(response.error?.message);
    return result;
  }

  BigInt _getDefaultTxFee() {
    final networkId = ezcNetwork.networkId;
    return networks[networkId]?.x.txFee ?? BigInt.zero;
  }
}

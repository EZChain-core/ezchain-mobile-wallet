import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/pvm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/roi_api.dart';
import 'package:wallet/roi/sdk/roi.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';

abstract class PvmApi implements ROIChainApi {
  factory PvmApi.create(
      {required ROINetwork roiNetwork, String endPoint = "/ext/bc/P"}) {
    return _PvmApiImpl(
        roiNetwork: roiNetwork,
        endPoint: endPoint,
        blockChainId: platformChainId);
  }
}

class _PvmApiImpl implements PvmApi {
  @override
  ROINetwork roiNetwork;

  @override
  PvmKeyChain get keyChain => _keyChain;

  late PvmKeyChain _keyChain;

  String blockChainId;

  String? blockchainAlias;

  Uint8List? avaxAssetId;

  _PvmApiImpl(
      {required this.roiNetwork,
      required String endPoint,
      required this.blockChainId}) {
    final networkId = roiNetwork.networkId;
    final network = networks[networkId];
    final String alias;
    if (network != null) {
      alias = network.findAliasByBlockChainId(blockChainId) ?? "";
    } else {
      alias = blockChainId;
    }
    _keyChain = PvmKeyChain(chainId: alias, hrp: roiNetwork.hrp);
  }

  @override
  PvmKeyChain newKeyChain() {
    final alias = getBlockchainAlias();
    if (alias == null) {
      _keyChain = PvmKeyChain(chainId: blockChainId, hrp: roiNetwork.hrp);
    } else {
      _keyChain = PvmKeyChain(chainId: alias, hrp: roiNetwork.hrp);
    }
    return keyChain;
  }

  @override
  String? getBlockchainAlias() {
    if (blockchainAlias == null) {
      final networkId = roiNetwork.networkId;
      final network = networks[networkId];
      blockchainAlias = network?.findAliasByBlockChainId(blockChainId);
    }
    return blockchainAlias;
  }

  @override
  void refreshBlockchainId(String blockChainId) {
    this.blockChainId = blockChainId;
  }

  @override
  void setAVAXAssetId(String? avaxAssetId) {
    this.avaxAssetId = cb58Decode(avaxAssetId);
  }

  @override
  void setBlockchainAlias(String alias) {
    blockchainAlias = alias;
  }

  @override
  String addressFromBuffer(Uint8List address) {
    throw UnimplementedError();
  }

  @override
  Uint8List parseAddress(String address) {
    throw UnimplementedError();
  }
}

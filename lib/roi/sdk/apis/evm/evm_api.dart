import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/roi_api.dart';
import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/roi.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';

abstract class EvmApi implements ROIChainApi {
  factory EvmApi.create(
      {required ROINetwork roiNetwork,
      String endPoint = "/ext/bc/C/avax",
      String blockChainId = ""}) {
    return _EvmApiImpl(
        roiNetwork: roiNetwork, endPoint: endPoint, blockChainId: blockChainId);
  }
}

class _EvmApiImpl implements EvmApi {
  @override
  ROINetwork roiNetwork;

  @override
  ROIKeyChain get keyChain => _keyChain;

  late ROIKeyChain _keyChain;

  String blockChainId;

  String? blockchainAlias;

  Uint8List? avaxAssetId;

  _EvmApiImpl(
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
    _keyChain = ROIKeyChain(chainId: alias, hrp: roiNetwork.hrp);
  }

  @override
  ROIKeyChain newKeyChain() {
    final alias = getBlockchainAlias();
    if (alias == null) {
      _keyChain = ROIKeyChain(chainId: blockChainId, hrp: roiNetwork.hrp);
    } else {
      _keyChain = ROIKeyChain(chainId: alias, hrp: roiNetwork.hrp);
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
}

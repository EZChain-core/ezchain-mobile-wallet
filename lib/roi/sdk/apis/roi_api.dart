import 'dart:typed_data';

import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/roi.dart';

abstract class ROIApi {
  late ROINetwork roiNetwork;
}

abstract class ROIChainApi implements ROIApi {
  ROIKeyChain get keyChain;

  ROIKeyChain newKeyChain();

  String? getBlockchainAlias();

  void setBlockchainAlias(String alias);

  void refreshBlockchainId(String blockChainId);

  void setAVAXAssetId(String? avaxAssetId);

  String addressFromBuffer(Uint8List address);

  Uint8List parseAddress(String address);
}

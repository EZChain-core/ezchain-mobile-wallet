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

  String getBlockchainId();

  String addressFromBuffer(Uint8List address);

  Uint8List parseAddress(String address);
}

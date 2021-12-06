import 'dart:typed_data';

import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';

class AvmUnsignedTx {
  AvmTx sign(ROIKeyChain keyChain) {
    return AvmTx();
  }

  BigInt getInputTotal(Uint8List? avaxAssetId) {
    // TODO: implement getBlockchainAlias
    throw UnimplementedError();
  }

  BigInt getOutputTotal(Uint8List? avaxAssetId) {
    // TODO: implement getBlockchainAlias
    throw UnimplementedError();
  }

  BigInt getBurn(Uint8List? avaxAssetId) {
    return getInputTotal(avaxAssetId) ~/ getOutputTotal(avaxAssetId);
  }
}

class AvmTx {}

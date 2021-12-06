import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/avm/tx.dart';

class AvmUTXO {}

class AvmUTXOSet {
  AvmUnsignedTx buildBaseTx(
      int networkId,
      Uint8List blockchainId,
      BigInt amount,
      Uint8List assetId,
      List<Uint8List> toAddresses,
      List<Uint8List> fromAddresses,
      List<Uint8List>? changeAddresses,
      BigInt? fee,
      Uint8List? feeAssetID,
      Uint8List? memo,
      {int threshold = 1}) {
    if (threshold > toAddresses.length) {
      /* istanbul ignore next */
      throw Exception(
          "Error - UTXOSet.buildBaseTx: threshold is greater than number of addresses");
    }

    changeAddresses ??= toAddresses;
    feeAssetID ??= assetId;

    return AvmUnsignedTx();
  }
}

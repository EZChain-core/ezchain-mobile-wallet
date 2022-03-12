import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/avm/base_tx.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/inputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/ops.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';

class AvmOperationTx extends AvmBaseTx {
  @override
  String get typeName => "AvmCreateAssetTx";

  AvmOperationTx({
    int networkId = defaultNetworkId,
    Uint8List? blockchainId,
    List<AvmTransferableOutput>? outs,
    List<AvmTransferableInput>? ins,
    Uint8List? memo,
    List<AvmTransferableOperation>? ops,
  }) : super(
            networkId: networkId,
            blockchainId: blockchainId,
            outs: outs,
            ins: ins,
            memo: memo) {
    setCodecId(LATESTCODEC);
  }

  factory AvmOperationTx.fromArgs(Map<String, dynamic> args) {
    return AvmOperationTx(
      networkId: args["networkId"] ?? defaultNetworkId,
      blockchainId: args["blockchainId"],
      outs: args["outs"],
      ins: args["ins"],
      memo: args["memo"],
    );
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - AvmOperationTx.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    setTypeId(codecId == 0 ? OPERATIONTX : OPERATIONTX_CODECONE);
  }

  @override
  int getTxType() {
    return super.getTypeId();
  }
}

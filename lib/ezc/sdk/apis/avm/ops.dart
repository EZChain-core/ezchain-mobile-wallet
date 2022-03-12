import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/common/credentials.dart';
import 'package:wallet/ezc/sdk/common/nbytes.dart';
import 'package:wallet/ezc/sdk/common/output.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

AvmOperation selectOperationClass(
  int opId, {
  Map<String, dynamic> args = const {},
}) {
  switch (opId) {
    case NFTMINTOPID:
    case NFTMINTOPID_CODECONE:
      return AvmNFTMintOperation.fromArgs(args);
    default:
      throw Exception("Error - SelectOperationClass: unknown opId $opId");
  }
}

abstract class AvmOperation extends Serializable {
  @override
  String get typeName => "AvmOperation";

  var sigCount = Uint8List(4);
  var sigIdxs = <SigIdx>[];
}

class AvmTransferableOperation extends Serializable {
  @override
  String get typeName => "AvmTransferableOperation";

  var assetId = Uint8List(32);
  var utxoIds = <AvmUTXOId>[];
  late AvmOperation operation;

  AvmTransferableOperation({
    Uint8List? assetId,
    List<String>? utxoIds,
    AvmOperation? operation,
  }) {}
}

class AvmNFTMintOperation extends AvmOperation {
  @override
  String get typeName => "AvmNFTMintOperation";

  var groupId = Uint8List(4);
  late Uint8List payload;
  var outputOwners = <OutputOwners>[];

  AvmNFTMintOperation({
    int? groupId,
    Uint8List? payload,
    List<OutputOwners>? owners,
  }) {
    setCodecId(LATESTCODEC);
  }

  factory AvmNFTMintOperation.fromArgs(Map<String, dynamic> args) {
    return AvmNFTMintOperation(
      groupId: args["groupId"],
      payload: args["payload"],
      owners: args["owners"],
    );
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - AvmNFTMintOperation.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    setTypeId(codecId == 0 ? NFTMINTOPID : NFTMINTOPID_CODECONE);
  }

  addSignatureIdx(int addressIdx, Uint8List address) {}
}

class AvmUTXOId extends NBytes {
  AvmUTXOId() : super(bytes: Uint8List(36), bSize: 36);

  @override
  NBytes clone() {
    throw UnimplementedError();
  }
}

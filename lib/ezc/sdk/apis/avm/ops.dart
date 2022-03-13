import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/common/credentials.dart';
import 'package:wallet/ezc/sdk/common/nbytes.dart';
import 'package:wallet/ezc/sdk/common/output.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';
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
  var sigIdxs = <SigIdx>[]; // idxs of signers from utxo

  int getOperationId();

  int getCredentialId();

  @override
  String toString() {
    return bufferToB58(toBuffer());
  }

  addSignatureIdx(int addressIdx, Uint8List address) {
    final sigIdx = SigIdx();
    final b = Uint8List(4);
    b.buffer.asByteData().setUint32(0, addressIdx);
    sigIdx.fromBuffer(b);
    sigIdx.setSource(address);
    sigIdxs.add(sigIdx);
    sigCount.buffer.asByteData().setUint32(0, sigIdxs.length);
  }

  List<SigIdx> getSigIdxs() {
    return sigIdxs;
  }

  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    sigCount = bytes.sublist(offset, offset + 4);
    offset += 4;
    final sigCountNum = sigCount.buffer.asByteData().getUint32(0);
    sigIdxs = [];
    for (var i = 0; i < sigCountNum; i++) {
      final sigIdx = SigIdx();
      final sigBuff = bytes.sublist(offset, offset + 4);
      sigIdx.fromBuffer(sigBuff);
      offset += 4;
      sigIdxs.add(sigIdx);
    }
    return offset;
  }

  Uint8List toBuffer() {
    sigCount.buffer.asByteData().setUint32(0, sigIdxs.length);
    final barr = [sigCount];
    for (var i = 0; i < sigIdxs.length; i++) {
      final b = sigIdxs[i].toBuffer();
      barr.add(b);
    }
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  static int Function(AvmOperation a, AvmOperation b) comparator() {
    return (a, b) {
      return compare(a.toBuffer(), b.toBuffer());
    };
  }
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
  }) {
    if (assetId != null &&
        assetId.length == ASSETIDLEN &&
        utxoIds != null &&
        operation != null) {
      this.assetId = assetId;
      this.operation = operation;
      for (final utxoIdString in utxoIds) {
        final utxoId = AvmUTXOId()..fromString(utxoIdString);
        this.utxoIds.add(utxoId);
      }
    }
  }

  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    assetId = bytes.sublist(offset, offset + 32);
    offset += 32;
    final numUtxoIds =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    utxoIds = [];
    for (var i = 0; i < numUtxoIds; i++) {
      final utxoId = AvmUTXOId();
      offset = utxoId.fromBuffer(bytes, offset: offset);
      utxoIds.add(utxoId);
    }
    final opId =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    operation = selectOperationClass(opId);
    return operation.fromBuffer(bytes, offset: offset);
  }

  Uint8List toBuffer() {
    final numUtxoIds = Uint8List(4);
    numUtxoIds.buffer.asByteData().setUint32(0, utxoIds.length);
    final barr = [assetId, numUtxoIds];
    utxoIds.sort(AvmUTXOId.comparator());
    for (var i = 0; i < utxoIds.length; i++) {
      final b = utxoIds[i].toBuffer();
      barr.add(b);
    }
    final opId = Uint8List(4);
    opId.buffer.asByteData().setUint32(0, operation.getOperationId());
    barr.add(opId);
    barr.add(operation.toBuffer());
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  AvmOperation getOperation() {
    return operation;
  }

  Uint8List getAssetId() {
    return assetId;
  }

  List<AvmUTXOId> getUTXOIds() {
    return utxoIds;
  }

  static int Function(AvmTransferableOperation a, AvmTransferableOperation b)
      comparator() {
    return (a, b) {
      return compare(a.toBuffer(), b.toBuffer());
    };
  }
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
    if (groupId != null && payload != null && owners != null) {
      this.groupId.buffer.asByteData().setUint32(0, groupId);
      this.payload = payload;
      outputOwners = owners;
    }
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

  @override
  int getOperationId() {
    return super.getTypeId();
  }

  @override
  int getCredentialId() {
    if (getCodecId() == 0) {
      return NFTCREDENTIAL;
    } else if (getCodecId() == 1) {
      return NFTCREDENTIAL_CODECONE;
    } else {
      throw Exception(
          "Error - AvmNFTMintOperation.getCredentialId: invalid codecID. Valid codecIDs are 0 and 1.");
    }
  }

  Uint8List getGroupId() {
    return groupId;
  }

  Uint8List getPayload() {
    return payload;
  }

  Uint8List getPayloadBuffer() {
    final payloadLen = Uint8List(4);
    payloadLen.buffer.asByteData().setUint32(0, payload.length);
    return Uint8List.fromList([...payloadLen, ...payload]);
  }

  List<OutputOwners> getOutputOwners() {
    return outputOwners;
  }

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    offset = super.fromBuffer(bytes, offset: offset);
    groupId = bytes.sublist(offset, offset + 4);
    offset += 4;
    final payloadLen =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    payload = bytes.sublist(offset, offset + payloadLen);
    offset += payloadLen;
    final numOutputs =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    outputOwners = [];
    for (var i = 0; i < numOutputs; i++) {
      final outputOwner = OutputOwners();
      offset = outputOwner.fromBuffer(bytes, offset: offset);
      outputOwners.add(outputOwner);
    }
    return offset;
  }

  @override
  Uint8List toBuffer() {
    final superBuff = super.toBuffer();
    final payloadLen = Uint8List(4);
    payloadLen.buffer.asByteData().setUint32(0, payload.length);

    final outputOwnersLen = Uint8List(4);
    outputOwnersLen.buffer.asByteData().setUint32(0, outputOwners.length);

    final barr = [superBuff, groupId, payloadLen, payload, outputOwnersLen];

    for (var i = 0; i < outputOwners.length; i++) {
      final b = outputOwners[i].toBuffer();
      barr.add(b);
    }

    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  @override
  String toString() {
    return bufferToB58(toBuffer());
  }
}

class AvmUTXOId extends NBytes {
  AvmUTXOId() : super(bytes: Uint8List(36), bSize: 36);

  @override
  NBytes clone() {
    throw UnimplementedError();
  }

  @override
  String toString() {
    return cb58Encode(toBuffer());
  }

  @override
  int fromString(String b58Str) {
    final utxoIdBuff = b58ToBuffer(b58Str);
    if (utxoIdBuff.length == 40) {
      if (validateChecksum(utxoIdBuff)) {
        final newBuff = utxoIdBuff.sublist(0, utxoIdBuff.length - 4);
        if (newBuff.length == 36) {
          setBuffer(newBuff);
        }
      } else {
        throw Exception(
            "Error - AvmUTXOId.fromString: invalid checksum on address");
      }
    } else if (utxoIdBuff.length == 36) {
      setBuffer(utxoIdBuff);
    } else {
      throw Exception("Error - AvmUTXOId.fromString: invalid address");
    }
    return getSize();
  }

  static int Function(AvmUTXOId a, AvmUTXOId b) comparator() {
    return (a, b) {
      return compare(a.toBuffer(), b.toBuffer());
    };
  }
}

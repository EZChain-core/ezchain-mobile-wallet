import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/common/output.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

/// Takes a buffer representing the output and returns the proper Output instance.
///
/// @param outputId A number representing the inputID parsed prior to the bytes passed in
///
/// @returns An instance of an [[Output]]-extended class.
Output selectOutputClass(int outputId, {Map<String, dynamic> args = const {}}) {
  switch (outputId) {
    case SECPXFEROUTPUTID:
    case SECPXFEROUTPUTID_CODECONE:
      return AvmSECPTransferOutput.fromArgs(args);
    case SECPMINTOUTPUTID:
    case SECPMINTOUTPUTID_CODECONE:
      return AvmSECPMintOutput.fromArgs(args);
    case NFTMINTOUTPUTID:
    case NFTMINTOUTPUTID_CODECONE:
      return AvmNFTMintOutput.fromArgs(args);
    case NFTXFEROUTPUTID:
    case NFTXFEROUTPUTID_CODECONE:
      return AvmNFTTransferOutput.fromArgs(args);
    default:
      throw Exception(
          "Error - SelectOutputClass: unknown outputId = $outputId");
  }
}

class AvmTransferableOutput extends StandardTransferableOutput {
  AvmTransferableOutput({Uint8List? assetId, Output? output})
      : super(assetId: assetId, output: output);

  @override
  String get typeName => "AvmTransferableOutput";

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    output = selectOutputClass(fields["output"]["_typeId"]);
    output.deserialize(fields["output"], encoding: encoding);
  }

  @override
  int fromBuffer(Uint8List bytes, {int? offset}) {
    offset ??= 0;
    assetId = bytes.sublist(offset, offset + ASSETIDLEN);
    offset += ASSETIDLEN;
    final outputId =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    output = selectOutputClass(outputId);
    return output.fromBuffer(bytes, offset: offset);
  }
}

abstract class AvmAmountOutput extends StandardAmountOutput {
  @override
  String get typeName => "AvmAmountOutput";

  AvmAmountOutput(
      {BigInt? amount,
      List<Uint8List>? addresses,
      BigInt? lockTime,
      int? threshold})
      : super(
            amount: amount,
            addresses: addresses,
            lockTime: lockTime,
            threshold: threshold);

  @override
  AvmTransferableOutput makeTransferable(Uint8List assetId) {
    return AvmTransferableOutput(assetId: assetId, output: this);
  }

  @override
  Output select(int id, {Map<String, dynamic> args = const {}}) {
    return selectOutputClass(id, args: args);
  }
}

class AvmSECPTransferOutput extends AvmAmountOutput {
  @override
  String get typeName => "AvmSECPTransferOutput";

  AvmSECPTransferOutput(
      {BigInt? amount,
      List<Uint8List>? addresses,
      BigInt? lockTime,
      int? threshold})
      : super(
            amount: amount,
            addresses: addresses,
            lockTime: lockTime,
            threshold: threshold) {
    setCodecId(LATESTCODEC);
  }

  factory AvmSECPTransferOutput.fromArgs(Map<String, dynamic> args) {
    return AvmSECPTransferOutput(
      amount: args["amount"],
      lockTime: args["lockTime"],
      threshold: args["threshold"],
      addresses: args["addresses"],
    );
  }

  static Map<String, dynamic> createArgs({
    BigInt? amount,
    List<Uint8List>? addresses,
    BigInt? lockTime,
    int? threshold,
  }) {
    return {
      "amount": amount,
      "addresses": addresses,
      "lockTime": lockTime,
      "threshold": threshold
    };
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - AvmSECPTransferOutput.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    super
        .setTypeId(codecId == 0 ? SECPXFEROUTPUTID : SECPXFEROUTPUTID_CODECONE);
  }

  @override
  Output clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  Output create({Map<String, dynamic> args = const {}}) {
    return AvmSECPTransferOutput.fromArgs(args);
  }

  @override
  int getOutputId() => super.getTypeId();
}

abstract class AvmNFTOutput extends BaseNFTOutput {
  @override
  String get typeName => "AvmNFTOutput";

  AvmNFTOutput({
    List<Uint8List>? addresses,
    BigInt? lockTime,
    int? threshold,
    int? groupId,
  }) : super(
          lockTime: lockTime,
          threshold: threshold,
          addresses: addresses,
          groupId: groupId,
        );

  @override
  StandardTransferableOutput makeTransferable(Uint8List assetId) {
    return AvmTransferableOutput(assetId: assetId, output: this);
  }

  @override
  Output select(int id, {Map<String, dynamic> args = const {}}) {
    return selectOutputClass(id, args: args);
  }
}

/// An [[Output]] class which specifies an Output that carries an ammount for an assetID and uses secp256k1 signature scheme.
class AvmSECPMintOutput extends Output {
  @override
  String get typeName => "AvmSECPMintOutput";

  AvmSECPMintOutput({
    BigInt? lockTime,
    int? threshold,
    List<Uint8List>? addresses,
  }) : super(
          lockTime: lockTime,
          threshold: threshold,
          addresses: addresses,
        ) {
    setCodecId(LATESTCODEC);
  }

  factory AvmSECPMintOutput.fromArgs(Map<String, dynamic> args) {
    return AvmSECPMintOutput(
      lockTime: args["lockTime"],
      threshold: args["threshold"],
      addresses: args["addresses"],
    );
  }

  static Map<String, dynamic> createArgs({
    List<Uint8List>? addresses,
    BigInt? lockTime,
    int? threshold,
  }) {
    return {
      "addresses": addresses,
      "lockTime": lockTime,
      "threshold": threshold
    };
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - AvmSECPMintOutput.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    setTypeId(codecId == 0 ? SECPMINTOUTPUTID : SECPMINTOUTPUTID_CODECONE);
  }

  @override
  int getOutputId() {
    return getTypeId();
  }

  @override
  AvmSECPMintOutput create({Map<String, dynamic> args = const {}}) {
    return AvmSECPMintOutput.fromArgs(args);
  }

  @override
  AvmSECPMintOutput clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  Output select(int id, {Map<String, dynamic> args = const {}}) {
    return selectOutputClass(id, args: args);
  }

  @override
  AvmTransferableOutput makeTransferable(Uint8List assetId) {
    return AvmTransferableOutput(assetId: assetId, output: this);
  }
}

/// An [[Output]] class which specifies an Output that carries an NFT Mint and uses secp256k1 signature scheme.
class AvmNFTMintOutput extends AvmNFTOutput {
  @override
  String get typeName => "AvmNFTMintOutput";

  AvmNFTMintOutput({
    List<Uint8List>? addresses,
    BigInt? lockTime,
    int? threshold,
    int? groupId,
  }) : super(
          lockTime: lockTime,
          threshold: threshold,
          addresses: addresses,
          groupId: groupId,
        ) {
    setCodecId(LATESTCODEC);
  }

  factory AvmNFTMintOutput.fromArgs(Map<String, dynamic> args) {
    return AvmNFTMintOutput(
      lockTime: args["lockTime"],
      threshold: args["threshold"],
      addresses: args["addresses"],
      groupId: args["groupId"],
    );
  }

  static Map<String, dynamic> createArgs({
    List<Uint8List>? addresses,
    BigInt? lockTime,
    int? threshold,
    int? groupId,
  }) {
    return {
      "addresses": addresses,
      "lockTime": lockTime,
      "threshold": threshold,
      "groupId": groupId,
    };
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - AvmNFTMintOutput.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    setTypeId(codecId == 0 ? NFTMINTOUTPUTID : NFTMINTOUTPUTID_CODECONE);
  }

  @override
  int getOutputId() {
    return getTypeId();
  }

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    groupId = bytes.sublist(offset, offset + 4);
    offset += 4;
    return super.fromBuffer(bytes, offset: offset);
  }

  @override
  Uint8List toBuffer() {
    final superBuff = super.toBuffer();
    final barr = [groupId, superBuff];
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  @override
  Output select(int id, {Map<String, dynamic> args = const {}}) {
    return selectOutputClass(id, args: args);
  }

  @override
  AvmNFTMintOutput create({Map<String, dynamic> args = const {}}) {
    return AvmNFTMintOutput.fromArgs(args);
  }

  @override
  AvmNFTMintOutput clone() {
    return create()..fromBuffer(toBuffer());
  }
}

/// An [[Output]] class which specifies an Output that carries an NFT and uses secp256k1 signature scheme.
class AvmNFTTransferOutput extends AvmNFTOutput {
  @override
  String get typeName => "AvmNFTTransferOutput";

  var sizePayload = Uint8List(4);
  late Uint8List payload;

  AvmNFTTransferOutput({
    List<Uint8List>? addresses,
    BigInt? lockTime,
    int? threshold,
    int? groupId,
    Uint8List? payload,
  }) : super(
          lockTime: lockTime,
          threshold: threshold,
          addresses: addresses,
          groupId: groupId,
        ) {
    setCodecId(LATESTCODEC);
    if (payload != null) {
      sizePayload.buffer.asByteData().setUint32(0, payload.length);
      this.payload = payload;
    }
  }

  factory AvmNFTTransferOutput.fromArgs(Map<String, dynamic> args) {
    return AvmNFTTransferOutput(
      lockTime: args["lockTime"],
      threshold: args["threshold"],
      addresses: args["addresses"],
      groupId: args["groupId"],
      payload: args["payload"],
    );
  }

  static Map<String, dynamic> createArgs({
    List<Uint8List>? addresses,
    BigInt? lockTime,
    int? threshold,
    Uint8List? payload,
    int? groupId,
  }) {
    return {
      "addresses": addresses,
      "lockTime": lockTime,
      "threshold": threshold,
      "groupId": groupId,
      "payload": payload,
    };
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "payload": Serialization.instance.encoder(
        payload,
        encoding,
        SerializedType.buffer,
        SerializedType.hex,
        args: [payload.length],
      )
    };
  }

  @override
  void deserialize(fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    payload = Serialization.instance.decoder(
      fields["payload"],
      encoding,
      SerializedType.hex,
      SerializedType.buffer,
    );
    sizePayload = Uint8List(4);
    sizePayload.buffer.asByteData().setUint32(0, payload.length);
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - AvmNFTMintOutput.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    setTypeId(codecId == 0 ? NFTXFEROUTPUTID : NFTXFEROUTPUTID_CODECONE);
  }

  @override
  int getOutputId() {
    return getTypeId();
  }

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    groupId = bytes.sublist(offset, offset + 4);
    offset += 4;
    sizePayload = bytes.sublist(offset, offset + 4);
    final pSize = sizePayload.buffer.asByteData().getUint32(0);
    offset += 4;
    payload = bytes.sublist(offset, offset + pSize);
    offset += pSize;
    return super.fromBuffer(bytes, offset: offset);
  }

  @override
  Uint8List toBuffer() {
    final superBuff = super.toBuffer();
    sizePayload.buffer.asByteData().setUint32(0, payload.length);
    return Uint8List.fromList(
        [...groupId, ...sizePayload, ...payload, ...superBuff]);
  }

  @override
  AvmNFTTransferOutput clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  AvmNFTTransferOutput create({Map<String, dynamic> args = const {}}) {
    return AvmNFTTransferOutput.fromArgs(args);
  }

  Uint8List getPayloadBuffer() {
    return Uint8List.fromList([...sizePayload, ...payload]);
  }
}

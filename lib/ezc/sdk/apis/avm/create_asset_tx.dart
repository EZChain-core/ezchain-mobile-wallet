import 'dart:convert';
import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/avm/base_tx.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/initial_states.dart';
import 'package:wallet/ezc/sdk/apis/avm/inputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

class AvmCreateAssetTx extends AvmBaseTx {
  @override
  String get typeName => "AvmCreateAssetTx";

  var name = "";
  var symbol = "";
  var denomination = Uint8List(1);
  var initialState = InitialStates();

  AvmCreateAssetTx({
    int networkId = defaultNetworkId,
    Uint8List? blockchainId,
    List<AvmTransferableOutput>? outs,
    List<AvmTransferableInput>? ins,
    Uint8List? memo,
    String? name,
    String? symbol,
    int? denomination,
    InitialStates? initialState,
  }) : super(
            networkId: networkId,
            blockchainId: blockchainId,
            outs: outs,
            ins: ins,
            memo: memo) {
    setCodecId(LATESTCODEC);
    if (name != null &&
        symbol != null &&
        denomination != null &&
        denomination >= 0 &&
        denomination <= 32 &&
        initialState != null) {
      this.initialState = initialState;
      this.name = name;
      this.symbol = symbol;
      this.denomination.buffer.asByteData().setUint8(0, denomination);
    }
  }

  factory AvmCreateAssetTx.fromArgs(Map<String, dynamic> args) {
    return AvmCreateAssetTx(
      networkId: args["networkId"] ?? defaultNetworkId,
      blockchainId: args["blockchainId"],
      outs: args["outs"],
      ins: args["ins"],
      memo: args["memo"],
      name: args["name"],
      symbol: args["symbol"],
      denomination: args["denomination"],
      initialState: args["initialState"],
    );
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "name": Serialization.instance.encoder(
        name,
        encoding,
        SerializedType.utf8,
        SerializedType.utf8,
      ),
      "symbol": Serialization.instance.encoder(
        symbol,
        encoding,
        SerializedType.utf8,
        SerializedType.utf8,
      ),
      "denomination": Serialization.instance.encoder(
        denomination,
        encoding,
        SerializedType.buffer,
        SerializedType.decimalString,
        args: [1],
      ),
      "initialState": initialState.serialize(encoding: encoding),
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    name = Serialization.instance.decoder(
      fields["name"],
      encoding,
      SerializedType.utf8,
      SerializedType.utf8,
    );
    symbol = Serialization.instance.decoder(
      fields["symbol"],
      encoding,
      SerializedType.utf8,
      SerializedType.utf8,
    );
    denomination = Serialization.instance.decoder(
      fields["denomination"],
      encoding,
      SerializedType.decimalString,
      SerializedType.buffer,
      args: [1],
    );
    initialState = InitialStates()
      ..deserialize(
        fields["initialState"],
        encoding: encoding,
      );
  }

  @override
  void setCodecId(int codecId) {
    if (codecId != 0 && codecId != 1) {
      throw Exception(
          "Error - AvmCreateAssetTx.setCodecID: invalid codecID. Valid codecIDs are 0 and 1.");
    }
    super.setCodecId(codecId);
    setTypeId(codecId == 0 ? CREATEASSETTX : CREATEASSETTX_CODECONE);
  }

  @override
  int getTxType() {
    return super.getTypeId();
  }

  @override
  Uint8List toBuffer() {
    final superBuff = super.toBuffer();
    final initStateBuff = initialState.toBuffer();

    final nameBuff = Uint8List(name.length);
    nameBuff.setRange(0, name.length, utf8.encode(name));

    final nameSize = Uint8List(2);
    nameSize.buffer.asByteData().setUint16(0, name.length);

    final symBuff = Uint8List(symbol.length);
    symBuff.setRange(0, symbol.length, utf8.encode(symbol));

    final symSize = Uint8List(2);
    symSize.buffer.asByteData().setUint16(0, symbol.length);

    return Uint8List.fromList([
      ...superBuff,
      ...nameSize,
      ...nameBuff,
      ...symSize,
      ...symBuff,
      ...denomination,
      ...initStateBuff
    ]);
  }

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    offset = super.fromBuffer(bytes, offset: offset);
    final nameSize =
        bytes.sublist(offset, offset + 2).buffer.asByteData().getUint16(0);
    offset += 2;
    name = utf8.decode(bytes.sublist(offset, offset + nameSize));
    offset += nameSize;
    final symSize =
        bytes.sublist(offset, offset + 2).buffer.asByteData().getUint16(0);
    offset += 2;
    symbol = utf8.decode(bytes.sublist(offset, offset + symSize));
    offset += symSize;
    denomination = bytes.sublist(offset, offset + 1);
    offset += 1;
    initialState = InitialStates()..fromBuffer(bytes, offset: offset);
    return offset;
  }

  @override
  AvmCreateAssetTx create({Map<String, dynamic> args = const {}}) {
    return AvmCreateAssetTx.fromArgs(args);
  }

  int getDenomination() {
    return denomination.buffer.asByteData().getUint8(0);
  }
}

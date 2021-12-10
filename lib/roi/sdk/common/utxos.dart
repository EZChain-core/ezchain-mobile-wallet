import 'dart:typed_data';

import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

abstract class StandardUTXO extends Serializable {
  var codecId = Uint8List(2);
  var txId = Uint8List(32);
  var outputIdx = Uint8List(4);
  var assetId = Uint8List(32);
  late Output output;

  StandardUTXO(
      {int codecId = 0,
      Uint8List? txId,
      dynamic outputIdx,
      Uint8List? assetId,
      required Output output}) {
    final byteData = ByteData(2)..setUint8(0, codecId);
    this.codecId = byteData.buffer.asUint8List();
    if (txId != null) {
      this.txId = txId;
    }
    if (outputIdx != null) {
      if (outputIdx is int) {
        final byteData = ByteData(4)..setUint32(0, outputIdx);
        this.outputIdx = byteData.buffer.asUint8List();
      } else if (outputIdx is Uint8List) {
        this.outputIdx = outputIdx;
      }
    }
    if (assetId != null) {
      this.assetId == assetId;
    }
    this.output == output;
  }

  int fromBuffer(Uint8List bytes, int? offset);

  int fromString(String serialized);

  String toString();

  StandardUTXO clone();

  StandardUTXO create(int? codecID, Uint8List? txId, dynamic outputIdx,
      Uint8List? assetId, Output? output);

  getUTXOId() => bufferToB58(Uint8List.fromList([...txId, ...outputIdx]));

  Uint8List toBuffer() {
    final outBuff = output.toBuffer();
    final byteData = ByteData(4)..setUint32(0, output.getOutputId());
    final outputIdBuffer = byteData.buffer.asUint8List();
    return Uint8List.fromList([
      ...codecId,
      ...txId,
      ...outputIdx,
      ...assetId,
      ...outputIdBuffer,
      ...outBuff
    ]);
  }

  @override
  String get _typeName => "StandardUTXO";

  @override
  dynamic serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    var fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "codecId": Serialization.instance.encoder(codecId, encoding,
          SerializedType.Buffer, SerializedType.decimalString),
      "txId": Serialization.instance
          .encoder(txId, encoding, SerializedType.Buffer, SerializedType.cb58),
      "outputIdx": Serialization.instance.encoder(outputIdx, encoding,
          SerializedType.Buffer, SerializedType.decimalString),
      "assetId": Serialization.instance.encoder(
          assetId, encoding, SerializedType.Buffer, SerializedType.cb58),
      "output": output.serialize(encoding: encoding)
    };
  }

  @override
  void deserialize(dynamic fields, SerializedEncoding encoding) {
    super.deserialize(fields, encoding);
    codecId = Serialization.instance.decoder(fields["fields"], encoding,
        SerializedType.decimalString, SerializedType.Buffer,
        args: [2]);
    txId = Serialization.instance.decoder(
        fields["txId"], encoding, SerializedType.cb58, SerializedType.Buffer,
        args: [32]);
    outputIdx = Serialization.instance.decoder(fields["outputIdx"], encoding,
        SerializedType.decimalString, SerializedType.Buffer,
        args: [4]);
    assetId = Serialization.instance.decoder(
        fields["assetId"], encoding, SerializedType.cb58, SerializedType.Buffer,
        args: [32]);
  }
}

abstract class StandardUTXOSet<UTXOClass extends StandardUTXO>
    extends Serializable {
  Map<String, UTXOClass> utxos = {};

  Map<String, Map<String, BigInt>> addressUTXOs = {};

  @override
  String get _typeName => "StandardUTXOSet";

  UTXOClass parseUTXO(UTXOClass utxo);

  StandardUTXOSet clone();

  StandardUTXOSet create({List<dynamic> args = const []});

  @override
  dynamic serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    var fields = super.serialize(encoding: encoding);
    final utxos = {};
    for (final utxoId in this.utxos.keys) {
      final utxoIdCleaned = Serialization.instance.encoder(
          utxoId, encoding, SerializedType.base58, SerializedType.base58);

      utxos[utxoIdCleaned] = this.utxos[utxoId]!.serialize(encoding: encoding);
    }
    final addressUTXOs = {};
    for (final address in this.addressUTXOs.keys) {
      final addressCleaned = Serialization.instance.encoder(
          address, encoding, SerializedType.hex, SerializedType.base58);

      final utxoBalance = {};

      for (final utxoId in this.addressUTXOs[address]!.keys) {
        final utxoidCleaned = Serialization.instance.encoder(
            utxoId, encoding, SerializedType.base58, SerializedType.base58);

        utxoBalance[utxoidCleaned] = Serialization.instance.encoder(
            this.addressUTXOs[address]![utxoId]!,
            encoding,
            SerializedType.BN,
            SerializedType.decimalString);
      }
      addressUTXOs[addressCleaned] = utxoBalance;
    }

    return {...fields, "utxos": utxos, "addressUTXOs": addressUTXOs};
  }

  bool includes(UTXOClass utxo) {
    throw UnimplementedError();
  }

  UTXOClass add(UTXOClass utxo, {bool overwrite = false}) {
    throw UnimplementedError();
  }

  UTXOClass remove(UTXOClass utxo) {
    throw UnimplementedError();
  }

  List<UTXOClass> removeArray(List<UTXOClass> utxo) {
    throw UnimplementedError();
  }

  List<StandardUTXO> addArray(List<UTXOClass> utxos, {bool overwrite = false}) {
    throw UnimplementedError();
  }

  UTXOClass getUTXO(String utxoId) {
    throw UnimplementedError();
  }

  List<UTXOClass> getAllUTXOs(List<String> utxoId) {
    throw UnimplementedError();
  }

  List<String> getAllUTXOStrings(List<String> utxoId) {
    throw UnimplementedError();
  }

  List<String> getUTXOIds(List<Uint8List> addresses, {bool spendable = true}) {
    throw UnimplementedError();
  }

  List<Uint8List> getAddresses() {
    throw UnimplementedError();
  }

  BigInt getBalance(List<Uint8List> addresses, Uint8List assetId, BigInt asOf) {
    throw UnimplementedError();
  }

  List<Uint8List> getAssetIds(List<Uint8List> addresses) {
    throw UnimplementedError();
  }

  StandardUTXO filter(List<dynamic> args,
      bool Function(UTXOClass utxo, List<dynamic> largs) lambda) {
    throw UnimplementedError();
  }

  StandardUTXO merge(StandardUTXO utxoSet, List<String> hasUTXOIDs) {
    throw UnimplementedError();
  }

  StandardUTXO intersection(StandardUTXO utxoSet) {
    throw UnimplementedError();
  }

  StandardUTXO difference(StandardUTXO utxoSet) {
    throw UnimplementedError();
  }

  StandardUTXO symDifference(StandardUTXO utxoSet) {
    throw UnimplementedError();
  }

  StandardUTXO union(StandardUTXO utxoSet) {
    throw UnimplementedError();
  }

  StandardUTXO mergeByRule(StandardUTXO utxoSet, MergeRule mergeRule) {
    throw UnimplementedError();
  }
}

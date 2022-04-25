import 'dart:typed_data';

import 'package:wallet/ezc/sdk/common/output.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

abstract class StandardUTXO extends Serializable {
  var codecIdBuff = Uint8List(2);
  var txId = Uint8List(32);
  var outputIdx = Uint8List(4);
  var assetId = Uint8List(32);
  late Output output;

  @override
  String get typeName => "StandardUTXO";

  StandardUTXO(
      {int codecId = 0,
      Uint8List? txId,
      dynamic outputIdx,
      Uint8List? assetId,
      Output? output}) {
    codecIdBuff.buffer.asByteData().setUint8(0, codecId);
    if (txId != null) {
      this.txId = txId;
    }
    if (outputIdx != null) {
      if (outputIdx is int) {
        this.outputIdx.buffer.asByteData().setUint32(0, outputIdx);
      } else if (outputIdx is Uint8List) {
        this.outputIdx = outputIdx;
      }
    }
    if (assetId != null) {
      this.assetId = assetId;
    }
    if (output != null) {
      this.output = output;
    }
  }

  int fromBuffer(Uint8List bytes, {int? offset});

  int fromString(String serialized);

  @override
  String toString();

  StandardUTXO clone();

  @override
  dynamic serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    var fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "codecIdBuff": Serialization.instance.encoder(
        codecIdBuff,
        encoding,
        SerializedType.buffer,
        SerializedType.decimalString,
      ),
      "txId": Serialization.instance.encoder(
        txId,
        encoding,
        SerializedType.buffer,
        SerializedType.cb58,
      ),
      "outputIdx": Serialization.instance.encoder(
        outputIdx,
        encoding,
        SerializedType.buffer,
        SerializedType.decimalString,
      ),
      "assetId": Serialization.instance.encoder(
        assetId,
        encoding,
        SerializedType.buffer,
        SerializedType.cb58,
      ),
      "output": output.serialize(
        encoding: encoding,
      )
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    codecIdBuff = Serialization.instance.decoder(
      fields["codecIdBuff"],
      encoding,
      SerializedType.decimalString,
      SerializedType.buffer,
      args: [2],
    );
    txId = Serialization.instance.decoder(
      fields["txId"],
      encoding,
      SerializedType.cb58,
      SerializedType.buffer,
      args: [32],
    );
    outputIdx = Serialization.instance.decoder(
      fields["outputIdx"],
      encoding,
      SerializedType.decimalString,
      SerializedType.buffer,
      args: [4],
    );
    assetId = Serialization.instance.decoder(
      fields["assetId"],
      encoding,
      SerializedType.cb58,
      SerializedType.buffer,
      args: [32],
    );
  }

  @override
  int getCodecId() => codecIdBuff.buffer.asByteData().getInt8(0);

  Uint8List getCodecIdBuffer() => codecIdBuff;

  Uint8List getTxId() => txId;

  Uint8List getOutputIdx() => outputIdx;

  Uint8List getAssetId() => assetId;

  String getUTXOId() =>
      bufferToB58(Uint8List.fromList([...txId, ...outputIdx]));

  Output getOutput() => output;

  Uint8List toBuffer() {
    final outBuff = output.toBuffer();
    final outputIdBuffer = Uint8List(4);
    outputIdBuffer.buffer.asByteData().setUint32(0, output.getOutputId());
    return Uint8List.fromList([
      ...codecIdBuff,
      ...txId,
      ...outputIdx,
      ...assetId,
      ...outputIdBuffer,
      ...outBuff
    ]);
  }
}

abstract class StandardUTXOSet<UTXOClass extends StandardUTXO>
    extends Serializable {
  Map<String, UTXOClass> utxos = {};

  Map<String, Map<String, BigInt>> addressUTXOs = {};

  @override
  String get typeName => "StandardUTXOSet";

  UTXOClass parseUTXO(dynamic utxo);

  StandardUTXOSet clone();

  StandardUTXOSet create({Map<String, dynamic> args = const {}});

  @override
  dynamic serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    var fields = super.serialize(encoding: encoding);
    final Map<String, dynamic> utxos = {};
    for (final utxoId in this.utxos.keys) {
      final utxoIdCleaned = Serialization.instance.encoder(
          utxoId, encoding, SerializedType.base58, SerializedType.base58);
      utxos[utxoIdCleaned] = this.utxos[utxoId]!.serialize(encoding: encoding);
    }
    final Map<String, dynamic> addressUTXOs = {};
    for (final address in this.addressUTXOs.keys) {
      final addressCleaned = Serialization.instance.encoder(
          address, encoding, SerializedType.hex, SerializedType.base58);

      final Map<String, dynamic> utxoBalance = {};

      for (final utxoId in this.addressUTXOs[address]!.keys) {
        final utxoIdCleaned = Serialization.instance.encoder(
            utxoId, encoding, SerializedType.base58, SerializedType.base58);

        utxoBalance[utxoIdCleaned] = Serialization.instance.encoder(
            this.addressUTXOs[address]![utxoId]!,
            encoding,
            SerializedType.bn,
            SerializedType.decimalString);
      }
      addressUTXOs[addressCleaned] = utxoBalance;
    }

    return {...fields, "utxos": utxos, "addressUTXOs": addressUTXOs};
  }

  bool includes(dynamic utxo) {
    try {
      final utxoX = parseUTXO(utxo);
      final utxoId = utxoX.getUTXOId();
      return utxos.keys.contains(utxoId);
    } catch (e) {
      return false;
    }
  }

  UTXOClass? add(dynamic utxo, {bool overwrite = false}) {
    final UTXOClass utxovar;
    try {
      utxovar = parseUTXO(utxo);
    } catch (e) {
      return null;
    }
    final utxoId = utxovar.getUTXOId();
    if (!utxos.keys.contains(utxoId) || overwrite) {
      utxos[utxoId] = utxovar;
      final addresses = utxovar.getOutput().getAddresses();
      final lockTime = utxovar.getOutput().getLockTime();
      for (int i = 0; i < addresses.length; i++) {
        final address = hexEncode(addresses[i]);
        if (!addressUTXOs.keys.contains(address)) {
          addressUTXOs[address] = {};
        }
        addressUTXOs[address]![utxoId] = lockTime;
      }
      return utxovar;
    }
    return null;
  }

  List<UTXOClass> addArray(List<dynamic> utxos, {bool overwrite = false}) {
    final added = <UTXOClass>[];
    for (int i = 0; i < utxos.length; i++) {
      final result = add(utxos[i], overwrite: overwrite);
      if (result != null) {
        added.add(result);
      }
    }
    return added;
  }

  UTXOClass? remove(dynamic utxo) {
    final UTXOClass utxoVar;
    try {
      utxoVar = parseUTXO(utxo);
    } catch (e) {
      return null;
    }
    final utxoId = utxoVar.getUTXOId();
    if (!utxos.keys.contains(utxoId)) return null;
    utxos.remove(utxoId);
    final addresses = addressUTXOs.keys.toList();
    for (int i = 0; i < addresses.length; i++) {
      final utxos = addressUTXOs[addresses[i]];
      if (utxos != null && utxos.keys.contains(utxoId)) {
        utxos.remove(utxoId);
      }
    }
    return utxoVar;
  }

  List<UTXOClass> removeArray(List<dynamic> utxos) {
    final removed = <UTXOClass>[];
    for (int i = 0; i < utxos.length; i++) {
      final result = remove(utxos[i]);
      if (result != null) {
        removed.add(result);
      }
    }
    return removed;
  }

  UTXOClass? getUTXO(String utxoId) => utxos[utxoId];

  List<UTXOClass> getAllUTXOs({List<String>? utxoIds}) {
    final results = <UTXOClass>[];
    if (utxoIds != null) {
      for (int i = 0; i < utxoIds.length; i++) {
        final utxoId = utxoIds[i];
        final utxo = utxos[utxoId];
        if (utxo != null && !results.contains(utxo)) {
          results.add(utxo);
        }
      }
    } else {
      results.addAll(utxos.values);
    }
    return results;
  }

  List<String> getAllUTXOStrings({List<String>? utxoIds}) {
    final results = <String>[];
    final utxos = this.utxos.keys;
    if (utxoIds != null) {
      for (int i = 0; i < utxoIds.length; i++) {
        final utxoId = utxoIds[i];
        if (utxos.contains(utxoId)) {
          results.add(this.utxos[utxoId].toString());
        }
      }
    } else {
      for (final u in utxos) {
        results.add(this.utxos[u].toString());
      }
    }
    return results;
  }

  List<String> getUTXOIds({List<Uint8List>? addresses, bool spendable = true}) {
    if (addresses != null) {
      final results = <String>[];
      final now = unixNow();
      for (int i = 0; i < addresses.length; i++) {
        final address = hexEncode(addresses[i]);
        if (addressUTXOs.containsKey(address)) {
          final entries = addressUTXOs[address]!;
          for (final utxoId in entries.keys) {
            if ((!results.contains(utxoId) &&
                    spendable &&
                    entries[utxoId]! <= now) ||
                !spendable) {
              results.add(utxoId);
            }
          }
        }
      }
      return results;
    }
    return utxos.keys.toList();
  }

  List<Uint8List> getAddresses() {
    return addressUTXOs.keys
        .map((e) => Uint8List.fromList(hexDecode(e)))
        .toList();
  }

  BigInt getBalance(List<Uint8List> addresses, dynamic assetId,
      {BigInt? asOf}) {
    final utxoIds = getUTXOIds(addresses: addresses);
    final utxos = getAllUTXOs(utxoIds: utxoIds);
    var spend = BigInt.from(0);
    final Uint8List asset;
    if (assetId is String) {
      asset = cb58Decode(assetId);
    } else {
      asset = assetId;
    }
    for (int i = 0; i < utxos.length; i++) {
      final u = utxos[i];
      if (u.getOutput() is StandardAmountOutput &&
          hexEncode(u.getAssetId()) == hexEncode(asset) &&
          u.getOutput().meetsThreshold(addresses, asOf: asOf)) {
        spend += (u.getOutput() as StandardAmountOutput).getAmount();
      }
    }
    return spend;
  }

  List<Uint8List> getAssetIds({List<Uint8List>? addresses}) {
    final results = <Uint8List>[];
    final utxoIds = getUTXOIds(addresses: addresses);
    for (int i = 0; i < utxoIds.length; i++) {
      final utxoId = utxoIds[i];
      if (utxos.keys.contains(utxoId)) {
        final assetId = utxos[utxoId]!.getAssetId();
        if (!results.contains(assetId)) {
          results.add(assetId);
        }
      }
    }
    return results;
  }

  StandardUTXOSet filter(List<dynamic> args,
      bool Function(UTXOClass utxo, List<dynamic> largs) lambda) {
    final newSet = clone();
    final utxos = getAllUTXOs();
    for (int i = 0; i < utxos.length; i++) {
      final u = utxos[i];
      if (lambda(u, args)) {
        newSet.remove(u);
      }
    }
    return newSet;
  }

  StandardUTXOSet merge(StandardUTXOSet<UTXOClass> utxoSet,
      {List<String>? hasUTXOIDs}) {
    final results = create();
    final utxos1 = getAllUTXOs(utxoIds: hasUTXOIDs);
    final utxos2 = utxoSet.getAllUTXOs(utxoIds: hasUTXOIDs);
    process(UTXOClass utxo) => {results.add(utxo)};
    utxos1.forEach(process);
    utxos2.forEach(process);
    return results;
  }

  StandardUTXOSet intersection(StandardUTXOSet<UTXOClass> utxoSet) {
    final us1 = getUTXOIds();
    final us2 = utxoSet.getUTXOIds();
    final result = us1.where((element) => us2.contains(element)).toList();
    return merge(utxoSet, hasUTXOIDs: result);
  }

  StandardUTXOSet difference(StandardUTXOSet<UTXOClass> utxoSet) {
    final us1 = getUTXOIds();
    final us2 = utxoSet.getUTXOIds();
    final result = us1.where((element) => !us2.contains(element)).toList();
    return merge(utxoSet, hasUTXOIDs: result);
  }

  StandardUTXOSet symDifference(StandardUTXOSet<UTXOClass> utxoSet) {
    final us1 = getUTXOIds();
    final us2 = utxoSet.getUTXOIds();
    final result1 = us1.where((element) => !us2.contains(element));
    final result2 = us2.where((element) => !us1.contains(element));
    final result = [...result1, ...result2];
    return merge(utxoSet, hasUTXOIDs: result);
  }

  StandardUTXOSet union(StandardUTXOSet<UTXOClass> utxoSet) {
    return merge(utxoSet);
  }

  StandardUTXOSet mergeByRule(
      StandardUTXOSet<UTXOClass> utxoSet, MergeRule mergeRule) {
    switch (mergeRule) {
      case MergeRule.intersection:
        return intersection(utxoSet);
      case MergeRule.differenceSelf:
        return difference(utxoSet);
      case MergeRule.differenceNew:
        return utxoSet.difference(this);
      case MergeRule.symDifference:
        return symDifference(utxoSet);
      case MergeRule.union:
        return union(utxoSet);
      case MergeRule.unionMinusNew:
        {
          final uSet = union(utxoSet);
          return uSet.difference(utxoSet);
        }
      case MergeRule.unionMinusSelf:
        {
          final uSet = union(utxoSet);
          return uSet.difference(this);
        }
      case MergeRule.error:
        throw Exception("Error - StandardUTXOSet.mergeByRule: bad MergeRule");
    }
  }
}

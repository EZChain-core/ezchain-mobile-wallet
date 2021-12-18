import 'dart:typed_data';

import 'package:wallet/roi/sdk/common/credentials.dart';
import 'package:wallet/roi/sdk/common/input.dart';
import 'package:wallet/roi/sdk/common/keychain/base_key_chain.dart';
import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

abstract class StandardBaseTx<KPClass extends ROIKeyPair,
    KCClass extends ROIKeyChain> extends Serializable {
  var networkId = Uint8List(4);
  var blockchainId = Uint8List(32);
  var numOuts = Uint8List(4);
  var outs = <StandardTransferableOutput>[];
  var numIns = Uint8List(4);
  var ins = <StandardTransferableInput>[];
  var memo = Uint8List(0);

  @override
  String get typeName => "StandardBaseTx";

  StandardBaseTx(
      {int networkId = defaultNetworkId,
      Uint8List? blockchainId,
      List<StandardTransferableOutput>? outs,
      List<StandardTransferableInput>? ins,
      Uint8List? memo}) {
    this.networkId.buffer.asByteData().setUint32(0, networkId);
    if (blockchainId != null) {
      this.blockchainId = blockchainId;
    }
    if (memo != null) {
      this.memo = memo;
    }
    if (ins != null && outs != null) {
      numOuts.buffer.asByteData().setUint32(0, outs.length);
      this.outs = outs..sort(StandardParseableOutput.comparator());
      numIns.buffer.asByteData().setUint32(0, ins.length);
      this.ins = ins..sort(StandardParseableInput.comparator());
    }
  }

  int getTxType();

  List<StandardTransferableInput> getIns();

  List<StandardTransferableOutput> getOuts();

  List<StandardTransferableOutput> getTotalOuts();

  List<Credential> sign(Uint8List msg, KCClass kc);

  StandardBaseTx clone();

  StandardBaseTx create({Map<String, dynamic> args = const {}});

  StandardBaseTx select(int id, {Map<String, dynamic> args = const {}});

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "networkId": Serialization.instance.encoder(networkId, encoding,
          SerializedType.Buffer, SerializedType.decimalString),
      "blockchainId": Serialization.instance.encoder(
          blockchainId, encoding, SerializedType.Buffer, SerializedType.cb58),
      "outs": outs.map((e) => e.serialize(encoding: encoding)),
      "ins": ins.map((e) => e.serialize(encoding: encoding)),
      "memo": Serialization.instance
          .encoder(memo, encoding, SerializedType.Buffer, SerializedType.hex)
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    networkId = Serialization.instance.decoder(fields["networkId"], encoding,
        SerializedType.decimalString, SerializedType.Buffer,
        args: [4]);
    blockchainId = Serialization.instance.decoder(
        fields[""], encoding, SerializedType.cb58, SerializedType.Buffer,
        args: [32]);
    memo = Serialization.instance.decoder(
        fields["memo"], encoding, SerializedType.hex, SerializedType.Buffer);
  }

  @override
  String toString() => bufferToB58(toBuffer());

  int getNetworkId() => networkId.buffer.asByteData().getUint32(0);

  Uint8List getBlockchainId() => blockchainId;

  Uint8List getMemo() => memo;

  Uint8List toBuffer() {
    outs.sort(StandardParseableOutput.comparator());
    ins.sort(StandardParseableInput.comparator());
    numOuts.buffer.asByteData().setUint32(0, outs.length);
    numIns.buffer.asByteData().setUint32(0, ins.length);
    final barr = [networkId, blockchainId, numOuts];
    for (int i = 0; i < outs.length; i++) {
      final b = outs[i].toBuffer();
      barr.add(b);
    }
    barr.add(numIns);
    for (int i = 0; i < ins.length; i++) {
      final b = ins[i].toBuffer();
      barr.add(b);
    }
    final memoLen = Uint8List(4);
    memoLen.buffer.asByteData().setUint32(0, memo.length);
    barr.add(memoLen);
    barr.add(memo);
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }
}

abstract class StandardUnsignedTx<
    KPClass extends ROIKeyPair,
    KCClass extends ROIKeyChain,
    SBTx extends StandardBaseTx<KPClass, KCClass>> extends Serializable {
  var codecId = 0;
  late SBTx transaction;

  @override
  String get typeName => "StandardUnsignedTx";

  StandardUnsignedTx({SBTx? transaction, this.codecId = 0}) {
    if (transaction != null) {
      this.transaction = transaction;
    }
  }

  SBTx getTransaction();

  int fromBuffer(Uint8List bytes, {int? offset});

  StandardTx<KPClass, KCClass, StandardUnsignedTx<KPClass, KCClass, SBTx>> sign(
      KCClass kc);

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "codecId": Serialization.instance.encoder(codecId, encoding,
          SerializedType.number, SerializedType.decimalString,
          args: [2]),
      "transaction": transaction.serialize(encoding: encoding)
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    codecId = Serialization.instance.decoder(fields["txCodecId"], encoding,
        SerializedType.decimalString, SerializedType.number);
  }

  @override
  int getCodecId() => codecId;

  Uint8List getCodecIdBuffer() {
    return Uint8List(2)..buffer.asByteData().setUint16(0, codecId);
  }

  BigInt getInputTotal(Uint8List assetId) {
    final ins = getTransaction().getIns();
    final aIdHex = hexEncode(assetId);
    var total = BigInt.from(0);
    for (int i = 0; i < ins.length; i++) {
      final input = ins[i];
      if (input.getInput() is StandardAmountInput &&
          aIdHex == hexEncode(input.getAssetId())) {
        total += (input.getInput() as StandardAmountInput).getAmount();
      }
    }
    return total;
  }

  BigInt getOutputTotal(Uint8List assetId) {
    final outs = getTransaction().getTotalOuts();
    final aIdHex = hexEncode(assetId);
    var total = BigInt.from(0);
    for (int i = 0; i < outs.length; i++) {
      final output = outs[i];
      if (output.getOutput() is StandardAmountOutput &&
          aIdHex == hexEncode(output.getAssetId())) {
        total += (output.getOutput() as StandardAmountOutput).getAmount();
      }
    }
    return total;
  }

  BigInt getBurn(Uint8List assetId) {
    return getInputTotal(assetId) - getOutputTotal(assetId);
  }

  Uint8List toBuffer() {
    final codecBuff = Uint8List(2);
    codecBuff.buffer.asByteData().setUint16(0, transaction.getCodecId());
    final txType = Uint8List(4);
    txType.buffer.asByteData().setUint32(0, transaction.getTxType());
    final baseBuff = transaction.toBuffer();
    return Uint8List.fromList([...codecBuff, ...txType, ...baseBuff]);
  }
}

abstract class StandardTx<
    KPClass extends ROIKeyPair,
    KCClass extends ROIKeyChain,
    SUBTx extends StandardUnsignedTx<KPClass, KCClass,
        StandardBaseTx<KPClass, KCClass>>> extends Serializable {
  late SUBTx unsignedTx;
  List<Credential> credentials = [];

  @override
  String get typeName => "StandardTx";

  StandardTx({SUBTx? unsignedTx, List<Credential>? credentials}) {
    if (unsignedTx != null) {
      this.unsignedTx = unsignedTx;
    }
    if (credentials != null) {
      this.credentials = credentials;
    }
  }

  int fromBuffer(Uint8List bytes, {int? offset});

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "unsignedTx": unsignedTx.serialize(encoding: encoding),
      "credentials": credentials.map((e) => e.serialize(encoding: encoding))
    };
  }

  @override
  String toString() {
    return cb58Encode(toBuffer());
  }

  List<Credential> getCredentials() => credentials;

  SUBTx getUnsignedTx() => unsignedTx;

  int fromString(String serialized) {
    return fromBuffer(cb58Decode(serialized));
  }

  Uint8List toBuffer() {
    final tx = unsignedTx.getTransaction();
    final codecId = tx.getCodecId();
    final txBuff = unsignedTx.toBuffer();
    final credLen = Uint8List(4);
    credLen.buffer.asByteData().setUint32(0, credentials.length);
    final barr = <Uint8List>[txBuff, credLen];
    for (int i = 0; i < credentials.length; i++) {
      final credential = credentials[i];
      credential.setCodecID(codecId);
      final credId = Uint8List(4);
      credId.buffer.asByteData().setUint32(0, credential.getCredentialId());
      barr.add(credId);
      final credBuff = credential.toBuffer();
      barr.add(credBuff);
    }
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }
}

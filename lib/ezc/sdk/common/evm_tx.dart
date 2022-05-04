import 'dart:typed_data';

import 'package:wallet/ezc/sdk/common/credentials.dart';
import 'package:wallet/ezc/sdk/common/input.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/common/output.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

abstract class EvmStandardBaseTx<KPClass extends EZCKeyPair,
    KCClass extends EZCKeyChain> extends Serializable {
  var networkId = Uint8List(4);
  var blockchainId = Uint8List(32);

  @override
  String get typeName => "EvmStandardBaseTx";

  EvmStandardBaseTx(
      {int networkId = defaultNetworkId, Uint8List? blockchainId}) {
    this.networkId.buffer.asByteData().setUint32(0, networkId);
    if (blockchainId != null) {
      this.blockchainId = blockchainId;
    }
  }

  int getTxType();

  EvmStandardBaseTx clone();

  EvmStandardBaseTx create({Map<String, dynamic> args = const {}});

  EvmStandardBaseTx select(int id, {Map<String, dynamic> args = const {}});

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "networkId": Serialization.instance.encoder(
        networkId,
        encoding,
        SerializedType.buffer,
        SerializedType.decimalString,
      ),
      "blockchainId": Serialization.instance.encoder(
        blockchainId,
        encoding,
        SerializedType.buffer,
        SerializedType.cb58,
      )
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    networkId = Serialization.instance.decoder(
      fields["networkId"],
      encoding,
      SerializedType.decimalString,
      SerializedType.buffer,
      args: [4],
    );
    blockchainId = Serialization.instance.decoder(
      fields["blockchainId"],
      encoding,
      SerializedType.cb58,
      SerializedType.buffer,
      args: [32],
    );
  }

  @override
  String toString() => bufferToB58(toBuffer());

  int getNetworkId() => networkId.buffer.asByteData().getUint32(0);

  Uint8List getBlockchainId() => blockchainId;

  Uint8List toBuffer() {
    return Uint8List.fromList([...networkId, ...blockchainId]);
  }
}

abstract class EvmStandardUnsignedTx<
    KPClass extends EZCKeyPair,
    KCClass extends EZCKeyChain,
    SBTx extends EvmStandardBaseTx<KPClass, KCClass>> extends Serializable {
  var codecId = 0;
  late SBTx transaction;

  @override
  String get typeName => "EvmStandardUnsignedTx";

  EvmStandardUnsignedTx({SBTx? transaction, this.codecId = 0}) {
    if (transaction != null) {
      this.transaction = transaction;
    }
  }

  SBTx getTransaction();

  int fromBuffer(Uint8List bytes, {int? offset});

  EvmStandardTx<KPClass, KCClass, EvmStandardUnsignedTx<KPClass, KCClass, SBTx>>
      sign(KCClass kc);

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "codecId": Serialization.instance.encoder(
        codecId,
        encoding,
        SerializedType.number,
        SerializedType.decimalString,
        args: [2],
      ),
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
    final ins = <StandardTransferableInput>[];
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
    final outs = <StandardTransferableOutput>[];
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
    final codecBuff = getCodecIdBuffer();
    final txType = Uint8List(4);
    txType.buffer.asByteData().setUint32(0, transaction.getTxType());
    final baseBuff = transaction.toBuffer();
    return Uint8List.fromList([...codecBuff, ...txType, ...baseBuff]);
  }
}

abstract class EvmStandardTx<
    KPClass extends EZCKeyPair,
    KCClass extends EZCKeyChain,
    SUBTx extends EvmStandardUnsignedTx<KPClass, KCClass,
        EvmStandardBaseTx<KPClass, KCClass>>> extends Serializable {
  late SUBTx unsignedTx;
  List<Credential> credentials = [];

  @override
  String get typeName => "EvmStandardTx";

  EvmStandardTx({SUBTx? unsignedTx, List<Credential>? credentials}) {
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
    final txBuff = unsignedTx.toBuffer();
    final credLen = Uint8List(4);
    credLen.buffer.asByteData().setUint32(0, credentials.length);
    final barr = <Uint8List>[txBuff, credLen];
    for (int i = 0; i < credentials.length; i++) {
      final credential = credentials[i];
      final credId = Uint8List(4);
      credId.buffer.asByteData().setUint32(0, credential.getCredentialId());
      barr.add(credId);
      final credBuff = credential.toBuffer();
      barr.add(credBuff);
    }
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }
}

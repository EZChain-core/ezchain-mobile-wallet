import 'dart:typed_data';

import 'package:hash/hash.dart';
import 'package:wallet/roi/sdk/apis/avm/base_tx.dart';
import 'package:wallet/roi/sdk/apis/avm/constants.dart';
import 'package:wallet/roi/sdk/apis/avm/credentials.dart';
import 'package:wallet/roi/sdk/apis/avm/export_tx.dart';
import 'package:wallet/roi/sdk/apis/avm/import_tx.dart';
import 'package:wallet/roi/sdk/apis/avm/key_chain.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';
import 'package:wallet/roi/sdk/common/tx.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

AvmBaseTx selectTxClass(int inputId, {Map<String, dynamic> args = const {}}) {
  switch (inputId) {
    case BASETX:
      return AvmBaseTx.fromArgs(args);
    case IMPORTTX:
      return AvmImportTx.fromArgs(args);
    case EXPORTTX:
      return AvmExportTx.fromArgs(args);
    default:
      throw Exception("Error - SelectTxClass: unknown inputId = $inputId");
  }
}

class AvmUnsignedTx
    extends StandardUnsignedTx<AvmKeyPair, AvmKeyChain, AvmBaseTx> {
  @override
  String get typeName => "AvmUnsignedTx";

  AvmUnsignedTx({AvmBaseTx? transaction, int txCodecId = 0})
      : super(transaction: transaction, codecId: txCodecId);

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    transaction = selectTxClass(fields["transaction"]["typeId"]);
    transaction.deserialize(fields["transaction"], encoding: encoding);
  }

  @override
  int fromBuffer(Uint8List bytes, {int? offset}) {
    offset ??= 0;
    codecId =
        bytes.sublist(offset, offset + 2).buffer.asByteData().getUint16(0);
    offset += 2;
    final txType =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    transaction = selectTxClass(txType);
    return transaction.fromBuffer(bytes, offset: offset);
  }

  @override
  AvmBaseTx getTransaction() {
    return transaction;
  }

  @override
  AvmTx sign(AvmKeyChain kc) {
    final txBuff = toBuffer();
    final msg = SHA256().update(txBuff).digest();
    final signatures = transaction.sign(msg, kc);
    return AvmTx(unsignedTx: this, credentials: signatures);
  }
}

class AvmTx extends StandardTx<AvmKeyPair, AvmKeyChain, AvmUnsignedTx> {
  @override
  String get typeName => "AvmTx";

  AvmTx({AvmUnsignedTx? unsignedTx, List<Credential>? credentials})
      : super(unsignedTx: unsignedTx, credentials: credentials);

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    unsignedTx = AvmUnsignedTx();
    unsignedTx.deserialize(fields["unsignedTx"], encoding: encoding);
    credentials.clear();
    for (int i = 0;
        i < (fields["credentials"] as List<Credential>).length;
        i++) {
      final cred = selectCredentialClass(fields["credentials"][i]["typeId"]);
      cred.deserialize(fields["credentials"][i], encoding: encoding);
      credentials.add(cred);
    }
  }

  @override
  int fromBuffer(Uint8List bytes, {int? offset}) {
    offset ??= 0;
    unsignedTx = AvmUnsignedTx();
    offset = unsignedTx.fromBuffer(bytes, offset: offset);
    final numCreds =
        bytes.sublist(offset, offset + 4).buffer.asByteData().getUint32(0);
    offset += 4;
    credentials.clear();
    for (int i = 0; i < numCreds; i++) {
      final credId =
          bytes.sublist(offset!, offset + 4).buffer.asByteData().getUint32(0);
      offset += 4;
      final cred = selectCredentialClass(credId);
      offset = cred.fromBuffer(bytes, offset: offset);
      credentials.add(cred);
    }
    return offset!;
  }
}

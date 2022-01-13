import 'dart:typed_data';

import 'package:hash/hash.dart';
import 'package:wallet/roi/sdk/apis/pvm/base_tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/constants.dart';
import 'package:wallet/roi/sdk/apis/pvm/credentials.dart';
import 'package:wallet/roi/sdk/apis/pvm/export_tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/import_tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/pvm/validation_tx.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';
import 'package:wallet/roi/sdk/common/tx.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

PvmBaseTx selectTxClass(int inputId, {Map<String, dynamic> args = const {}}) {
  switch (inputId) {
    case BASETX:
      return PvmBaseTx.fromArgs(args);
    case IMPORTTX:
      return PvmImportTx.fromArgs(args);
    case EXPORTTX:
      return PvmExportTx.fromArgs(args);
    case ADDDELEGATORTX:
      return PvmAddDelegatorTx.fromArgs(args);
    case ADDVALIDATORTX:
      return PvmAddValidatorTx.fromArgs(args);
    default:
      throw Exception("Error - SelectTxClass: unknown inputId = $inputId");
  }
}

class PvmUnsignedTx
    extends StandardUnsignedTx<PvmKeyPair, PvmKeyChain, PvmBaseTx> {
  @override
  String get typeName => "PvmUnsignedTx";

  PvmUnsignedTx({PvmBaseTx? transaction, int txCodecId = 0})
      : super(transaction: transaction, codecId: txCodecId);

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    transaction = selectTxClass(fields["transaction"]["_typeId"]);
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
  PvmBaseTx getTransaction() {
    return transaction;
  }

  @override
  PvmTx sign(PvmKeyChain kc) {
    final txBuff = toBuffer();
    final msg = SHA256().update(txBuff).digest();
    final signatures = transaction.sign(msg, kc);
    return PvmTx(unsignedTx: this, credentials: signatures);
  }
}

class PvmTx extends StandardTx<PvmKeyPair, PvmKeyChain, PvmUnsignedTx> {
  @override
  String get typeName => "PvmTx";

  PvmTx({PvmUnsignedTx? unsignedTx, List<Credential>? credentials})
      : super(unsignedTx: unsignedTx, credentials: credentials);

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    unsignedTx = PvmUnsignedTx();
    unsignedTx.deserialize(fields["unsignedTx"], encoding: encoding);
    credentials.clear();
    for (int i = 0;
        i < (fields["credentials"] as List<Credential>).length;
        i++) {
      final cred = selectCredentialClass(fields["credentials"][i]["_typeId"]);
      cred.deserialize(fields["credentials"][i], encoding: encoding);
      credentials.add(cred);
    }
  }

  @override
  int fromBuffer(Uint8List bytes, {int? offset}) {
    offset ??= 0;
    unsignedTx = PvmUnsignedTx();
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

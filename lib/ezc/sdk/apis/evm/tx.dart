import 'dart:typed_data';

import 'package:hash/hash.dart';
import 'package:wallet/ezc/sdk/apis/evm/base_tx.dart';
import 'package:wallet/ezc/sdk/apis/evm/constants.dart';
import 'package:wallet/ezc/sdk/apis/evm/credentials.dart';
import 'package:wallet/ezc/sdk/apis/evm/export_tx.dart';
import 'package:wallet/ezc/sdk/apis/evm/import_tx.dart';
import 'package:wallet/ezc/sdk/common/credentials.dart';
import 'package:wallet/ezc/sdk/common/evm_tx.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

EvmBaseTx selectTxClass(
  int txType, {
  Map<String, dynamic> args = const {},
}) {
  switch (txType) {
    case IMPORTTX:
      return EvmImportTx.fromArgs(args);
    case EXPORTTX:
      return EvmExportTx.fromArgs(args);
    default:
      throw Exception("Error - SelectTxClass: unknown txType = $txType");
  }
}

class EvmUnsignedTx
    extends EvmStandardUnsignedTx<EZCKeyPair, EZCKeyChain, EvmBaseTx> {
  @override
  String get typeName => "EvmUnsignedTx";

  EvmUnsignedTx({EvmBaseTx? transaction, int txCodecId = 0})
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
  EvmBaseTx getTransaction() {
    return transaction;
  }

  @override
  EvmTx sign(EZCKeyChain kc) {
    final txBuff = toBuffer();
    final msg = SHA256().update(txBuff).digest();
    final signatures = transaction.sign(msg, kc);
    return EvmTx(unsignedTx: this, credentials: signatures);
  }
}

class EvmTx extends EvmStandardTx<EZCKeyPair, EZCKeyChain, EvmUnsignedTx> {
  @override
  String get typeName => "EvmTx";

  EvmTx({EvmUnsignedTx? unsignedTx, List<Credential>? credentials})
      : super(unsignedTx: unsignedTx, credentials: credentials);

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    unsignedTx = EvmUnsignedTx();
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
    unsignedTx = EvmUnsignedTx();
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

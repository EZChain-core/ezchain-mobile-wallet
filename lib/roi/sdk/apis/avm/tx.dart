import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/avm/base_tx.dart';
import 'package:wallet/roi/sdk/apis/avm/constants.dart';
import 'package:wallet/roi/sdk/apis/avm/key_chain.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';
import 'package:wallet/roi/sdk/common/tx.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';

AvmBaseTx selectTxClass(int inputId, {List<dynamic> args = const []}) {
  switch (inputId) {
    case BASETX:
      return AvmBaseTx(
        networkId: args.getOrNull(0),
        blockchainId: args.getOrNull(1),
        outs: args.getOrNull(2),
        ins: args.getOrNull(3),
        memo: args.getOrNull(4),
      );
    default:
      throw Exception("Error - SelectOutputClass: unknown inputId = $inputId");
  }
}

class AvmUnsignedTx
    extends StandardUnsignedTx<AvmKeyPair, AvmKeyChain, AvmBaseTx> {
  AvmUnsignedTx(AvmBaseTx transaction, {int txCodecId = 0})
      : super(txCodecId, transaction);

  @override
  String get typeName => "SECPTransferInput";

  @override
  int fromBuffer(Uint8List bytes, {int? offset}) {
    // TODO: implement fromBuffer
    throw UnimplementedError();
  }

  @override
  AvmBaseTx getTransaction() {
    // TODO: implement getTransaction
    throw UnimplementedError();
  }

  @override
  AvmTx sign(AvmKeyChain kc) {
    // TODO: implement sign
    throw UnimplementedError();
  }
}

class AvmTx extends StandardTx<AvmKeyPair, AvmKeyChain, AvmUnsignedTx> {
  AvmTx(
      {required AvmUnsignedTx unsignedTx,
      required List<Credential> credentials})
      : super(unsignedTx: unsignedTx, credentials: credentials);

  @override
  int fromBuffer(Uint8List bytes, {int? offset}) {
    // TODO: implement fromBuffer
    throw UnimplementedError();
  }
}

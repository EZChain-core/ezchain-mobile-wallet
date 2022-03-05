import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/evm/key_chain.dart';
import 'package:wallet/ezc/sdk/apis/evm/tx.dart';
import 'package:wallet/ezc/sdk/common/credentials.dart';
import 'package:wallet/ezc/sdk/common/evm_tx.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';

class EvmBaseTx extends EvmStandardBaseTx<EvmKeyPair, EvmKeyChain> {
  @override
  String get typeName => "EvmBaseTx";

  EvmBaseTx({int networkId = defaultNetworkId, Uint8List? blockchainId})
      : super(networkId: networkId, blockchainId: blockchainId);

  factory EvmBaseTx.fromArgs(Map<String, dynamic> args) {
    return EvmBaseTx(
      networkId: args["networkId"] ?? defaultNetworkId,
      blockchainId: args["blockchainId"],
    );
  }

  @override
  EvmStandardBaseTx<EZCKeyPair, EZCKeyChain> clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  EvmBaseTx create({Map<String, dynamic> args = const {}}) {
    return EvmBaseTx.fromArgs(args);
  }

  @override
  int getTxType() {
    return super.getTypeId();
  }

  @override
  EvmStandardBaseTx<EZCKeyPair, EZCKeyChain> select(int id,
      {Map<String, dynamic> args = const {}}) {
    return selectTxClass(id, args: args);
  }

  List<Credential> sign(Uint8List msg, EvmKeyChain kc) {
    return <Credential>[];
  }

  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    networkId = bytes.sublist(offset, offset + 4);
    offset += 4;
    blockchainId = bytes.sublist(offset, offset + 32);
    offset += 32;
    return offset;
  }
}

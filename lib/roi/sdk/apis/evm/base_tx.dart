import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/evm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/evm/tx.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';
import 'package:wallet/roi/sdk/common/evm_tx.dart';
import 'package:wallet/roi/sdk/common/keychain/roi_key_chain.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';

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
  EvmStandardBaseTx<ROIKeyPair, ROIKeyChain> clone() {
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
  EvmStandardBaseTx<ROIKeyPair, ROIKeyChain> select(int id,
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

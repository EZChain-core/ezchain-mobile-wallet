import 'dart:typed_data';

import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/ezc.dart';

abstract class EZCApi {
  late EZCNetwork ezcNetwork;

  EZCKeyChain get keyChain;

  EZCKeyChain newKeyChain();

  String? getBlockchainAlias();

  String getBlockchainId();

  String addressFromBuffer(Uint8List address);

  Uint8List parseAddress(String address);
}

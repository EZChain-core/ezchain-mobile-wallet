import 'dart:convert';
import 'dart:typed_data';
import 'package:hdkey/hdkey.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';

class HDNode {
  Uint8List? get publicKey => _publicKey;

  Uint8List? get privateKey => _privateKey;

  String? get privateKeyCB58 => _privateKeyCB58;

  Uint8List? get chainCode => _chainCode;

  String? get privateExtendedKey => _privateExtendedKey;

  String? get publicExtendedKey => _publicExtendedKey;

  late HDKey _hdKey;
  late Uint8List? _publicKey;
  late Uint8List? _privateKey;
  late String? _privateKeyCB58;
  late Uint8List? _chainCode;
  late String? _privateExtendedKey;
  late String? _publicExtendedKey;

  HDNode({required dynamic from}) {
    if (from is String) {
      if (from.substring(0, 2) == "xp") {
        _hdKey = HDKey.fromExtendedKey(from);
      } else {
        _hdKey = HDKey.fromMasterSeed(Uint8List.fromList(utf8.encode(from)));
      }
    } else if (from is Uint8List) {
      _hdKey = HDKey.fromMasterSeed(from);
    } else {
      throw ArgumentError("@param from seed String or key Uint8List");
    }
    _publicKey = _hdKey.publicKey;
    _privateKey = _hdKey.privateKey;
    final privateKey = _privateKey;
    if (privateKey != null) {
      _privateKeyCB58 = bufferToPrivateKeyString(privateKey);
    } else {
      _privateExtendedKey = null;
    }
    _chainCode = _hdKey.chainCode;
    _publicExtendedKey = _hdKey.publicExtendedKey;
    _privateExtendedKey = _hdKey.privateExtendedKey;
  }

  HDNode derive(String path) {
    final hdKey = _hdKey.derive(path);
    final HDNode node;
    if (hdKey.privateExtendedKey != null) {
      node = HDNode(from: hdKey.privateExtendedKey);
    } else {
      node = HDNode(from: hdKey.publicExtendedKey);
    }
    return node;
  }

  Uint8List sign(Uint8List hash) {
    return _hdKey.sign(hash);
  }

  bool verify(Uint8List hash, Uint8List signature) {
    return _hdKey.verify(hash, signature);
  }

  void wipePrivateData() {
    _privateKey = null;
    _privateExtendedKey = null;
    _privateKeyCB58 = null;
    _hdKey.wipePrivateData();
  }
}

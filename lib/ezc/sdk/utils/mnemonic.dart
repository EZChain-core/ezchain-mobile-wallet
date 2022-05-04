import 'dart:typed_data';

import 'package:bip39/bip39.dart' as bip39;

class Mnemonic {
  static const mnemonicLength = 24;

  Mnemonic._privateConstructor();

  static final Mnemonic _instance = Mnemonic._privateConstructor();

  static Mnemonic get instance => _instance;

  String generateMnemonic({int strength = 256}) {
    return bip39.generateMnemonic(strength: strength);
  }

  bool validateMnemonic(String mnemonic) {
    return bip39.validateMnemonic(mnemonic);
  }

  String entropyToMnemonic(String entropy) {
    return bip39.entropyToMnemonic(entropy);
  }

  String mnemonicToEntropy(String mnemonic) {
    return bip39.mnemonicToEntropy(mnemonic);
  }

  Uint8List mnemonicToSeed(String mnemonic, {String passphrase = ""}) {
    return bip39.mnemonicToSeed(mnemonic, passphrase: passphrase);
  }

  String mnemonicToSeedHex(String mnemonic, {String passphrase = ""}) {
    return bip39.mnemonicToSeedHex(mnemonic, passphrase: passphrase);
  }
}

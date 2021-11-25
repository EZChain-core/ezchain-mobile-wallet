import 'dart:convert';
import 'dart:typed_data';
import 'package:fast_base58/fast_base58.dart';
import "package:hex/hex.dart";
import "package:pointycastle/export.dart";
import 'package:pointycastle/block/modes/gcm.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';

const textToEncrypt =
    "solar ordinary sentence pelican trim ring indicate cake ordinary water size improve impose gentle frown sound know siren sick elder wait govern tortoise unit";

const passphrase = '111111111';

const aesSize = 256;

const salt_V6 = "2NgqFaoYSe5foo8oEtcdB658c7Eb";

const iv_V6 = "TQei93ehgGWgUKXkLha8Ef";

const key_V6 =
    "KJYzUxFzn2EFazvAkfEgkbdJ7L2qeUTG5jTHUa9MunaNZWzNREd1GvYbwbUDdUsEu9Z5vB4kKW6x3farGCjtDHJ6c4nRCEnJKTUmFsBZ6CZqQ4MfXCMBXPvzvvDuv3VhYeE1LkiQHQRhEfKQGVaY282xDRifx3xyeT8ar18LxF3UPDNjX1D1EDLX4bTvbT4cChc8EPj9ufwXrov1y7Fcw3krJ5H87GnkwCZezzTxUeas1eTztZ";

void main() {
  final salt = Base58Decode(salt_V6);
  final key = passphraseToKey(passphrase, salt: salt_V6, bitLength: aesSize);
  final iv = Base58Decode(iv_V6);

  print("key = ${utf8.decode(key)}");

  final decryptedBytes = aesGcmDecrypt(
    passphraseToKey(passphrase, salt: salt_V6, bitLength: aesSize),
    Uint8List.fromList(iv),
    Uint8List.fromList(key),
  );
  print("decryptedText = ${utf8.decode(decryptedBytes)}");
  // final randomSalt = latin1.decode(generateRandomBytes(16));
  // Uint8List key =
  //     passphraseToKey(passphrase, salt: randomSalt, bitLength: aesSize);
  // final iv = generateRandomBytes(12);
  // final plaintext = Uint8List.fromList(utf8.encode(textToEncrypt));
  // final cipherText = aesGcmEncrypt(key, iv, plaintext);
  // // print("encryptedBytes = ${utf8.decode(cipherText)}");
  // print("encryptedBytes = ${Base58Encode(cipherText)}");
  //
  // final decryptedBytes = aesGcmDecrypt(
  //     passphraseToKey(passphrase, salt: randomSalt, bitLength: aesSize),
  //     iv,
  //     cipherText);
  // // final decryptedBytes = unpad(paddedDecryptedBytes);
  // print("decryptedText = ${utf8.decode(decryptedBytes)}");
}

Uint8List aesGcmEncrypt(
    Uint8List key, Uint8List iv, Uint8List paddedPlaintext) {
  if (![128, 192, 256].contains(key.length * 8)) {
    throw ArgumentError.value(key, 'key', 'invalid key length for AES');
  }

  // Create a CBC block cipher with AES, and initialize with key and IV

  final gcm = GCMBlockCipher(AESEngine())
    ..init(true, ParametersWithIV(KeyParameter(key), iv)); // true=encrypt

  // Encrypt the plaintext block-by-block

  final cipherText = Uint8List(paddedPlaintext.length); // allocate space

  var offset = 0;
  while (offset < paddedPlaintext.length) {
    offset += gcm.processBlock(paddedPlaintext, offset, cipherText, offset);
  }
  assert(offset == paddedPlaintext.length);

  return cipherText;
}

Uint8List aesGcmDecrypt(Uint8List key, Uint8List iv, Uint8List cipherText) {
  if (![128, 192, 256].contains(key.length * 8)) {
    throw ArgumentError.value(key, 'key', 'invalid key length for AES');
  }
  // Create a CBC block cipher with AES, and initialize with key and IV

  final gcm = GCMBlockCipher(AESEngine())
    ..init(false, ParametersWithIV(KeyParameter(key), iv)); // false=decrypt

  // Decrypt the cipherText block-by-block

  final paddedPlainText = Uint8List(cipherText.length); // allocate space

  var offset = 0;
  while (offset < cipherText.length) {
    offset += gcm.processBlock(cipherText, offset, paddedPlainText, offset);
  }
  assert(offset == cipherText.length);

  return paddedPlainText;
}

Uint8List passphraseToKey(String passPhrase,
    {String salt = '', int iterations = 200000, required int bitLength}) {
  if (![128, 192, 256].contains(bitLength)) {
    throw ArgumentError.value(bitLength, 'bitLength', 'invalid for AES');
  }
  final numBytes = bitLength ~/ 8;

  final kd = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64)) // 64 for SHA-256
    ..init(Pbkdf2Parameters(
        utf8.encode(salt) as Uint8List, iterations, bitLength));

  return kd.process(utf8.encode(passPhrase) as Uint8List);
}

Uint8List generateRandomBytes(int numBytes) {
  final secureRandom = SecureRandom('Fortuna');
  secureRandom.seed(
      KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));
  return secureRandom.nextBytes(numBytes);
}

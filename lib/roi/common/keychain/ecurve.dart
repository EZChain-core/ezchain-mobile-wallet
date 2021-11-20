import 'dart:typed_data';

import "package:pointycastle/ecc/curves/secp256k1.dart";
import "package:pointycastle/api.dart"
    show PrivateKeyParameter, PublicKeyParameter;
import 'package:pointycastle/ecc/api.dart'
    show ECPrivateKey, ECPublicKey, ECSignature, ECPoint;
import "package:pointycastle/signers/ecdsa_signer.dart";
import 'package:pointycastle/macs/hmac.dart';
import "package:pointycastle/digests/sha256.dart";

/// https://github.com/shareven/wallet_hd/blob/master/lib/src/ecurve.dart
final _secp256k1 = ECCurve_secp256k1();

final _n = _secp256k1.n;
BigInt _nDiv2 = _n >> 1;

Uint8List sign(Uint8List hash, Uint8List privateKeyBytes) {
  ECSignature sig = _deterministicGenerateK(hash, privateKeyBytes);
  Uint8List buffer = Uint8List(64);
  buffer.setRange(0, 32, _encodeBigInt(sig.r));
  BigInt s;
  if (sig.s.compareTo(_nDiv2) > 0) {
    s = _n - sig.s;
  } else {
    s = sig.s;
  }
  buffer.setRange(32, 64, _encodeBigInt(s));
  return Uint8List.fromList([...buffer, 00]);
}

bool verify(Uint8List hash, Uint8List publicKeyBytes, Uint8List signature) {
  ECPoint? Q = _decodeFrom(publicKeyBytes);
  if (Q == null) return false;
  BigInt r = _fromBuffer(signature.sublist(0, 32));
  BigInt s = _fromBuffer(signature.sublist(32, 64));

  final signer = ECDSASigner(null, HMac(SHA256Digest(), 64));
  signer.init(false, PublicKeyParameter(ECPublicKey(Q, _secp256k1)));
  return signer.verifySignature(hash, ECSignature(r, s));
}

ECSignature _deterministicGenerateK(Uint8List hash, Uint8List privateKeyBytes) {
  final signer = ECDSASigner(null, HMac(SHA256Digest(), 64));
  var pkp = PrivateKeyParameter(
      ECPrivateKey(_decodeBigInt(privateKeyBytes), _secp256k1));
  signer.init(true, pkp);
  return signer.generateSignature(hash) as ECSignature;
}

/// Decode a BigInt from bytes in big-endian encoding.
BigInt _decodeBigInt(List<int> bytes) {
  BigInt result = BigInt.from(0);
  for (int i = 0; i < bytes.length; i++) {
    result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
  }
  return result;
}

var _byteMask = BigInt.from(0xff);

/// Encode a BigInt into bytes using big-endian encoding.
Uint8List _encodeBigInt(BigInt number) {
  // Not handling negative numbers. Decide how you want to do that.
  int size = (number.bitLength + 7) >> 3;
  var result = Uint8List(size);
  for (int i = 0; i < size; i++) {
    result[size - i - 1] = (number & _byteMask).toInt();
    number = number >> 8;
  }
  return result;
}

BigInt _fromBuffer(Uint8List d) {
  return _decodeBigInt(d);
}

Uint8List _toBuffer(BigInt d) {
  return _encodeBigInt(d);
}

ECPoint? _decodeFrom(Uint8List publicKeyBytes) {
  return _secp256k1.curve.decodePoint(publicKeyBytes);
}

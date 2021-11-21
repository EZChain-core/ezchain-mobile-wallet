import 'dart:typed_data';

import 'package:elliptic/elliptic.dart';
import "package:pointycastle/ecc/curves/secp256k1.dart";
import "package:pointycastle/api.dart"
    show PrivateKeyParameter, PublicKeyParameter;

import 'package:pointycastle/ecc/api.dart'
    show
        ECDomainParameters,
        ECPrivateKey,
        ECPublicKey,
        ECSignature,
        ECPoint,
        ECCurve;

import "package:pointycastle/signers/ecdsa_signer.dart";
import 'package:pointycastle/macs/hmac.dart';
import "package:pointycastle/digests/sha256.dart";

// ignore: implementation_imports
import 'package:pointycastle/src/utils.dart' as pointycastle_utils;
import 'package:wallet/roi/crypto/signature_options.dart';

/// https://github.com/bcgit/pc-dart
/// https://github.com/shareven/wallet_hd/blob/master/lib/src/ecurve.dart
/// https://github.com/ethereumdart/ethereum_util/blob/master/lib/src/signature.dart
/// https://github.com/simolus3/web3dart/blob/master/lib/src/crypto/secp256k1.dart#L97
final ellipticCurve = getSecp256k1();
final ECDomainParameters params = ECCurve_secp256k1();
final BigInt _halfCurveOrder = params.n >> 1;

PrivateKey generatePrivateKey() {
  return ellipticCurve.generatePrivateKey();
}

PrivateKey fromBytes(Uint8List privateKeyBytes) {
  return PrivateKey.fromBytes(ellipticCurve, privateKeyBytes);
}

Uint8List sign(Uint8List messageHash, Uint8List privateKeyBytes) {
  final digest = SHA256Digest();
  final signer = ECDSASigner(null, HMac(digest, 64));
  final d = pointycastle_utils.decodeBigIntWithSign(1, privateKeyBytes);
  final key = ECPrivateKey(d, params);
  signer.init(true, PrivateKeyParameter(key));
  var sig = signer.generateSignature(messageHash) as ECSignature;

  if (sig.s.compareTo(_halfCurveOrder) > 0) {
    sig = ECSignature(sig.r, params.n - sig.s);
  }

  Uint8List buffer = Uint8List(SignatureOptions.signatureSize);
  buffer.setRange(
      0, SignatureOptions.rEnd, pointycastle_utils.encodeBigInt(sig.r));
  buffer.setRange(SignatureOptions.rEnd, SignatureOptions.sEnd,
      pointycastle_utils.encodeBigInt(sig.s));

  final publicKeyBytes = _privateKeyToPublicKey(privateKeyBytes);
  var recoveryId = -1;
  for (var i = 0; i < 2; i++) {
    final options = SignatureOptions(r: sig.r, s: sig.s, recoveryId: i);
    if (verify(messageHash, publicKeyBytes, options)) {
      recoveryId = i;
      break;
    }
  }

  if (recoveryId == -1) {
    throw Exception(
        'Could not construct a recoverable key. This should never happen');
  }

  buffer.setRange(
      SignatureOptions.sEnd, SignatureOptions.signatureSize, [recoveryId]);

  return buffer;
}

Uint8List recover(Uint8List hash, SignatureOptions signOptions) {
  if (!signOptions.isValidSigRecovery) {
    throw ArgumentError("invalid signature v value");
  }
  final n = params.n;
  final i = BigInt.from(signOptions.recoveryId ~/ 2);
  final x = signOptions.r + (i * n);

  if (x.compareTo(ellipticCurve.p) >= 0) return Uint8List.fromList([]);

  final R = _decompressKey(x, (signOptions.recoveryId & 1) == 1, params.curve);
  final ECPoint? ecPoint = R * n;
  if (ecPoint == null || !ecPoint.isInfinity) return Uint8List.fromList([]);

  final e = pointycastle_utils.decodeBigInt(hash);

  final eInv = (BigInt.zero - e) % n;
  final rInv = signOptions.r.modInverse(n);
  final srInv = (rInv * signOptions.s) % n;
  final eInvrInv = (rInv * eInv) % n;

  final q = (params.G * eInvrInv)! + (R * srInv);
  return q!.getEncoded(true);
}

bool verify(Uint8List messageHash, Uint8List publicKeyBytes,
    SignatureOptions signOptions) {
  if (!signOptions.isValidSigRecovery) {
    throw ArgumentError("invalid signature v value");
  }
  ECPoint? Q = params.curve.decodePoint(publicKeyBytes);
  if (Q == null) return false;
  final signer = ECDSASigner(null, HMac(SHA256Digest(), 64));
  signer.init(false, PublicKeyParameter(ECPublicKey(Q, params)));
  return signer.verifySignature(
      messageHash, ECSignature(signOptions.r, signOptions.s));
}

ECPoint _decompressKey(BigInt xBN, bool yBit, ECCurve c) {
  List<int> x9IntegerToBytes(BigInt s, int qLength) {
    final bytes = pointycastle_utils.encodeBigInt(s);
    if (qLength < bytes.length) {
      return bytes.sublist(0, bytes.length - qLength);
    } else if (qLength > bytes.length) {
      final tmp = List<int>.filled(qLength, 0);

      final offset = qLength - bytes.length;
      for (var i = 0; i < bytes.length; i++) {
        tmp[i + offset] = bytes[i];
      }
      return tmp;
    }

    return bytes;
  }

  final compEnc = x9IntegerToBytes(xBN, 1 + ((c.fieldSize + 7) ~/ 8));
  compEnc[0] = yBit ? 0x03 : 0x02;
  return c.decodePoint(compEnc)!;
}

Uint8List _privateKeyToPublicKey(Uint8List privateKey) {
  final privateKeyNum = pointycastle_utils.decodeBigInt(privateKey);
  final p = params.G * privateKeyNum;
  return p!.getEncoded(true);
}

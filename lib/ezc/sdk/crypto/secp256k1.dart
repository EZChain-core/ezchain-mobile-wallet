import 'dart:typed_data';

import 'package:elliptic/elliptic.dart';
import "package:pointycastle/ecc/curves/secp256k1.dart";
import "package:pointycastle/api.dart"
    show PrivateKeyParameter, PublicKeyParameter;

import 'package:pointycastle/ecc/api.dart'
    show ECDomainParameters, ECPrivateKey, ECPublicKey, ECPoint, ECCurve;

import 'package:pointycastle/macs/hmac.dart';
import "package:pointycastle/digests/sha256.dart";

// ignore: implementation_imports
import 'package:wallet/ezc/sdk/crypto/ecdsa_signer.dart';
import 'package:wallet/ezc/sdk/crypto/key_pair.dart';
import 'package:wallet/ezc/sdk/utils/bigint.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';

/// https://github.com/bcgit/pc-dart
/// https://github.com/shareven/wallet_hd/blob/master/lib/src/ecurve.dart
/// https://github.com/ethereumdart/ethereum_util/blob/master/lib/src/signature.dart
/// https://github.com/simolus3/web3dart/blob/master/lib/src/crypto/secp256k1.dart#L97
final ellipticCurve = getSecp256k1();
final ECDomainParameters params = ECCurve_secp256k1();

KeyPair generateKeyPair() {
  final privateKey = ellipticCurve.generatePrivateKey();
  return _fromPrivateKey(privateKey);
}

KeyPair fromPrivateKey(Uint8List privateKeyBytes) {
  final privateKey = PrivateKey.fromBytes(ellipticCurve, privateKeyBytes);
  return _fromPrivateKey(privateKey);
}

KeyPair _fromPrivateKey(PrivateKey privateKey) {
  final publicKey = privateKey.publicKey;
  return KeyPair(
      privateKey: Uint8List.fromList(privateKey.bytes),
      publicKey: Uint8List.fromList(hexDecode(publicKey.toCompressedHex())));
}

Uint8List sign(Uint8List messageHash, Uint8List privateKeyBytes) {
  final digest = SHA256Digest();
  final signer = EzcECDSASigner(null, HMac(digest, 64));
  final d = decodeBigInt(privateKeyBytes);
  final key = ECPrivateKey(d, params);
  signer.init(true, PrivateKeyParameter(key));
  var sig = signer.generateSignature(messageHash) as EzcECSignature;

  if (sig.recoveryId == -1) {
    throw Exception(
        'Could not construct a recoverable key. This should never happen');
  }

  Uint8List buffer = Uint8List(EzcECSignature.signatureSize);
  buffer.setRange(
      0, EzcECSignature.rEnd, encodeBigInt(sig.r, length: EzcECSignature.rEnd));
  buffer.setRange(EzcECSignature.rEnd, EzcECSignature.sEnd,
      encodeBigInt(sig.s, length: EzcECSignature.sEnd - EzcECSignature.rEnd));

  buffer.setRange(
      EzcECSignature.sEnd, EzcECSignature.signatureSize, [sig.recoveryId]);

  return buffer;
}

Uint8List recover(Uint8List hash, EzcECSignature signature) {
  if (!signature.isValidSignatureRecovery) {
    throw ArgumentError("invalid signature v value");
  }
  final n = params.n;
  final i = BigInt.from(signature.recoveryId ~/ 2);
  final x = signature.r + (i * n);

  if (x.compareTo(ellipticCurve.p) >= 0) return Uint8List.fromList([]);

  final R = _decompressKey(x, (signature.recoveryId & 1) == 1, params.curve);
  final ECPoint? ecPoint = R * n;
  if (ecPoint == null || !ecPoint.isInfinity) return Uint8List.fromList([]);

  final e = decodeBigInt(hash);

  final eInv = (BigInt.zero - e) % n;
  final rInv = signature.r.modInverse(n);
  final srInv = (rInv * signature.s) % n;
  final eInvrInv = (rInv * eInv) % n;

  final q = (params.G * eInvrInv)! + (R * srInv);
  return q!.getEncoded(true);
}

bool verify(
    Uint8List messageHash, Uint8List publicKeyBytes, EzcECSignature signature) {
  ECPoint? Q = params.curve.decodePoint(publicKeyBytes);
  if (Q == null) return false;
  final signer = EzcECDSASigner(null, HMac(SHA256Digest(), 64));
  signer.init(false, PublicKeyParameter(ECPublicKey(Q, params)));
  return signer.verifySignature(messageHash, signature);
}

ECPoint _decompressKey(BigInt xBN, bool yBit, ECCurve c) {
  List<int> x9IntegerToBytes(BigInt s, int qLength) {
    final bytes = encodeBigInt(s);
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

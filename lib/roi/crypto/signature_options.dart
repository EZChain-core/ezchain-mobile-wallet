import 'dart:typed_data';

// ignore: implementation_imports
import 'package:pointycastle/src/utils.dart' as pointycastle_utils;

class SignatureOptions {
  static const int signatureSize = 65;
  static const int rEnd = 32;
  static const int sEnd = signatureSize - 1;

  final BigInt r;
  final BigInt s;
  final int recoveryId;

  const SignatureOptions(
      {required this.r, required this.s, required this.recoveryId});

  factory SignatureOptions.fromSignature(Uint8List signature) {
    BigInt r = pointycastle_utils.decodeBigInt(signature.sublist(0, rEnd));
    BigInt s = pointycastle_utils.decodeBigInt(signature.sublist(rEnd, sEnd));
    int recoveryId = signature.sublist(sEnd, signatureSize).first;
    return SignatureOptions(r: r, s: s, recoveryId: recoveryId);
  }

  bool get isValidSigRecovery {
    return recoveryId == 0 || recoveryId == 1;
  }
}

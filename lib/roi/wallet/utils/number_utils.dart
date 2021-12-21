import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';

Decimal bnToDecimal(BigInt bn, {int denomination = 0}) {
  final value = bn.toDecimal() / Decimal.fromInt(10).pow(denomination);
  return value.toDecimal();
}

BigInt avaxCtoX(BigInt amount) {
  final tens = BigInt.from(10).pow(9);
  return amount ~/ tens;
}

BigInt avaxXtoC(BigInt amount) {
  final tens = BigInt.from(10).pow(9);
  return amount * tens;
}

BigInt avaxPtoC(BigInt amount) {
  return avaxXtoC(amount);
}

Decimal bnToDecimalAvaxX(BigInt value) {
  return bnToDecimal(value, denomination: 9);
}

Decimal bnToDecimalAvaxP(BigInt value) {
  return bnToDecimalAvaxX(value);
}

Decimal bnToDecimalAvaxC(BigInt value) {
  return bnToDecimal(value, denomination: 18);
}

String bnToAvaxC(BigInt value) {
  return bnToLocaleString(value, decimals: 18);
}

String bnToAvaxX(BigInt value) {
  return bnToLocaleString(value, decimals: 9);
}

String bnToAvaxP(BigInt value) {
  return bnToAvaxX(value);
}

BigInt numberToBN(dynamic value, int decimals) {
  final BigInt valBigInt;
  if (value is String) {
    valBigInt = BigInt.tryParse(value) ?? BigInt.zero;
  } else {
    valBigInt = BigInt.from(value);
  }
  final Decimal valBig = Decimal.fromBigInt(valBigInt);
  final tens = Decimal.fromInt(10).pow(decimals);
  final rawStr = (valBig * tens).toStringAsFixed(0);
  return BigInt.tryParse(rawStr) ?? BigInt.zero;
}

BigInt numberToBNAvaxX(dynamic value) {
  return numberToBN(value, 9);
}

BigInt numberToBNAvaxP(dynamic value) {
  return numberToBN(value, 9);
}

BigInt numberToBNAvaxC(dynamic value) {
  return numberToBN(value, 18);
}

String bnToLocaleString(BigInt value, {int decimals = 9}) {
  final bigVal = bnToDecimal(value, denomination: decimals);
  return decimalToLocaleString(bigVal, decimals: decimals);
}

String decimalToLocaleString(Decimal bigValue, {int decimals = 9}) {
  final fixedStr = bigValue.toStringAsFixed(decimals);
  final split = fixedStr.split(".");
  var formatter = NumberFormat.decimalPattern("en_US");
  final wholeStr = formatter.format(int.parse(split[0]));
  if (split.length == 1) {
    return wholeStr;
  } else {
    try {
      var remainderStr = split[1];
      var lastChar = remainderStr[remainderStr.length - 1];
      while (lastChar == "0") {
        remainderStr = remainderStr.substring(0, remainderStr.length - 1);
        lastChar = remainderStr[remainderStr.length - 1];
      }
      final trimmed = remainderStr.substring(0, decimals);
      return "$wholeStr.$trimmed";
    } catch (e) {
      return wholeStr;
    }
  }
}

BigInt stringToBn(String value, int decimals) {
  final big = Decimal.tryParse(value);
  if (big == null) return BigInt.zero;
  final tens = Decimal.fromInt(10).pow(decimals);
  final rawStr = (big * tens).toStringAsFixed(0);
  return BigInt.tryParse(rawStr) ?? BigInt.zero;
}

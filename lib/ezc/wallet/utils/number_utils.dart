import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';

extension BigIntUtils on BigInt {
  Decimal toAvaxDecimal({int denomination = 0}) {
    final value = toDecimal() / Decimal.fromInt(10).pow(denomination);
    return value.toDecimal();
  }

  BigInt avaxCtoX() {
    final tens = BigInt.from(10).pow(9);
    return this ~/ tens;
  }

  BigInt avaxXtoC() {
    final tens = BigInt.from(10).pow(9);
    return this * tens;
  }

  BigInt avaxPtoC() {
    return avaxXtoC();
  }

  Decimal toDecimalAvaxX() {
    return toAvaxDecimal(denomination: 9);
  }

  Decimal toDecimalAvaxP() {
    return toDecimalAvaxX();
  }

  Decimal toDecimalAvaxC() {
    return toAvaxDecimal(denomination: 18);
  }

  String toAvaxC() {
    return toLocaleString(denomination: 18);
  }

  String toAvaxX() {
    return toLocaleString(denomination: 9);
  }

  String toAvaxP() {
    return toAvaxX();
  }

  String toLocaleString({
    int denomination = 9,
    int decimals = 9,
  }) {
    final decimal = toAvaxDecimal(denomination: denomination);
    return decimal.toLocaleString(decimals: decimals);
  }
}

extension DecimalUtils on Decimal {
  BigInt toBNAvaxX() {
    return toBN(denomination: 9);
  }

  BigInt toBNAvaxP() {
    return toBNAvaxX();
  }

  BigInt toBNAvaxC() {
    return toBN(denomination: 18);
  }

  BigInt toBN({int denomination = 0}) {
    final bnBig = this * Decimal.fromInt(10).pow(denomination);
    final bnString = bnBig.toStringAsFixed(0);
    return BigInt.tryParse(bnString) ?? BigInt.zero;
  }

  String toLocaleString({int decimals = 9}) {
    final fixedStr = toStringAsFixed(decimals);
    final split = fixedStr.split(".");
    var formatter = NumberFormat.decimalPattern("en_US");
    var wholeStr = formatter.format(double.tryParse(split[0]) ?? 0);
    if (this < Decimal.zero && wholeStr == "0") {
      wholeStr = "-0";
    }
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
        final String trimmed;
        if (decimals >= remainderStr.length) {
          trimmed = remainderStr;
        } else {
          trimmed = remainderStr.substring(0, decimals);
        }
        return "$wholeStr.$trimmed";
      } catch (e) {
        return wholeStr;
      }
    }
  }
}

extension StringUtils on String {
  BigInt toBN(int decimals) {
    final big = Decimal.tryParse(this);
    if (big == null) return BigInt.zero;
    final tens = Decimal.fromInt(10).pow(decimals);
    final rawStr = (big * tens).toStringAsFixed(0);
    return BigInt.tryParse(rawStr) ?? BigInt.zero;
  }
}

BigInt numberToBN(dynamic value, int decimals) {
  final BigInt valBigInt;
  if (value is String) {
    valBigInt = BigInt.tryParse(value) ?? BigInt.zero;
  } else if (value is num) {
    valBigInt = BigInt.from(value);
  } else {
    valBigInt = value;
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

import 'dart:convert' as dart_convert;

void main() {
  const payload = "123a!";
  final regExp = RegExp(r'^[0-9A-Fa-f]+$');
  print("result: ${!payload.startsWith("0x") && regExp.hasMatch(payload)}");
}

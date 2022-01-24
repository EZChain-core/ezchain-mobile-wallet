import 'dart:convert';

String parseMemo(String? memo) {
  if (memo == null) return "";
  final memoText = utf8.decode(base64.decode(memo));
  // Bug that sets memo to empty string (AAAAAA==) for some tx types
  if (memo == 'AAAAAA==') return "";
  return memoText;
}

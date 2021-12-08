import 'dart:typed_data';

import 'package:hex/hex.dart';
import 'package:test/test.dart';

void main() {
  var codecId = Uint8List(2);
  codecId[0] = 222;
  print("codecId = ${HEX.encode(codecId)}");
}

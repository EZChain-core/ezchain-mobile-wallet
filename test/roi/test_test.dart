import 'dart:convert';
import 'dart:typed_data';
import 'package:test/test.dart';

void main() {

  final test = TestImpl();
  test.test();

  print("kien = ${test.getKien()}");
}

abstract class Test {
  var kien = 0;

  int getKien() {
    return kien;
  }
}

class TestImpl extends Test {
  void test() {
    super.kien = 1;
  }
}

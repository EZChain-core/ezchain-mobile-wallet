import 'dart:convert';
import 'dart:typed_data';
import 'package:test/test.dart';

void main() {
  var ids = ["1", "4", "4", "4", "5", "6", "6"];
  var distinctIds = ids.toSet().toList();
  print("distinctIds = $distinctIds");
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:wallet/ezc/sdk/utils/payload.dart';

void main() {
  const payload =
      "GHsiYXZhbGFuY2hlIjp7InZlcnNpb24iOjEsInR5cGUiOiJnZW5lcmljIiwidGl0bGUiOiJLSUVOIiwiaW1nIjoiaHR0cHM6Ly9pbWFnZS0xLmdhcG93b3JrLnZuL2ltYWdlcy9mZDFhNTNkZS04MGE3LTQ1N2YtOTE2Mi03YTk2NTI4MzhmZTYuanBlZyIsImRlc2MiOiIifX0=";
  var payloadBuff = base64Decode(payload);
  final lengthBuff = Uint8List(4)
    ..buffer.asByteData().setUint8(0, payloadBuff.length);
  payloadBuff = Uint8List.fromList([...lengthBuff, ...payloadBuff]);
  final typeId = PayloadTypes.instance.getTypeId(payloadBuff);
  final content = PayloadTypes.instance.getContent(payloadBuff);
  print("typeId = $typeId, content = ${utf8.decode(content)}");
}

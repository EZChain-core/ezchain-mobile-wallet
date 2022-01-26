import 'package:test/test.dart';
import 'package:wallet/roi/sdk/apis/avm/credentials.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';
import 'package:wallet/roi/sdk/utils/bintools.dart';

void main() {
  test("credential", () {
    final credential = AvmSECPCredential();
    credential.addSignature(Signature()
      ..fromString(
          "Ew5cXF8STEfxt8uRa99JxeA712BGCxULWuqorBsztZd3Fu5aMxgv7JKL6jamZvwPheuS75CdwbZtDV3a8EBLnzm6P"));
    credential.addSignature(Signature()
      ..fromString(
          "KGVWE5XA3CSLg2UAminLaUwsDaeoA31e629jVysB3kcGHUWEHWZiALK5qQjtYd4uW7zwtvsWFt2hJ94ttz5UPD6Md"));
    credential.addSignature(Signature()
      ..fromString(
          "HcV6WQZFeu16hHebnhGDhZWDsXG1mMkYe5YQJXrTz26w2VFiihkCP36qqNhaTjG7v7Bs68EkLT4bmB9CMgx1s7KEw"));

    final tempCredential = AvmSECPCredential();
    tempCredential.fromBuffer(credential.toBuffer());

    expect(
        hexEncode(credential.toBuffer()), hexEncode(tempCredential.toBuffer()));
  });
}

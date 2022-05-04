import 'package:test/test.dart';

import 'package:wallet/ezc/sdk/utils/mnemonic.dart';

final mnemonic = Mnemonic.instance;

const m =
    "exhaust depend submit tornado unaware sleep kit lab edge artwork join faith fold sister silent bus prevent river wonder undo day hole tail donkey";

void main() {
  test("mnemonic", () {
    String randomMnemonic = mnemonic.generateMnemonic();
    expect(randomMnemonic.split(" ").length, 24);
  });

  test("valid mnemonic", () {
    final isValid = mnemonic.validateMnemonic(m);
    expect(isValid, true);
  });
}

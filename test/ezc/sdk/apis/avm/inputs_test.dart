import 'dart:typed_data';

import 'package:hash/hash.dart';
import 'package:test/test.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/inputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/common/input.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';

void main() {
  group("Inputs", () {
    late AvmUTXOSet set;
    late EZCKeyChain keymgr1;
    late EZCKeyChain keymgr2;
    final List<Uint8List> addrs1 = [];
    final List<Uint8List> addrs2 = [];
    final List<AvmUTXO> utxos = [];
    const hrp = "tests";
    const amnt = 10000;
    const codecID_zero = 0;
    const codecID_one = 1;

    setUp(() {
      set = AvmUTXOSet();
      keymgr1 = EZCKeyChain(chainId: "X", hrp: hrp);
      keymgr2 = EZCKeyChain(chainId: "X", hrp: hrp);
      addrs1.clear();
      addrs2.clear();
      utxos.clear();
      for (int i = 0; i < 3; i++) {
        addrs1.add(keymgr1.makeKey().getAddress());
        addrs2.add(keymgr2.makeKey().getAddress());
      }
      final amount = BigInt.from(amnt);
      final addresses = keymgr1.getAddresses();
      final locktime = BigInt.from(54321);
      const threshold = 3;

      for (int i = 0; i < 3; i++) {
        final txid = SHA256()
            .update(fromBNToBuffer(BigInt.from(i), length: 32))
            .digest();
        final txidx = fromBNToBuffer(BigInt.from(i), length: 4);
        final assetId = SHA256().update(txidx).digest();
        final out = AvmSECPTransferOutput(
            amount: amount + BigInt.from(i),
            addresses: addresses,
            lockTime: locktime,
            threshold: threshold);
        final xferout = AvmTransferableOutput(assetId: assetId, output: out);
        final u = AvmUTXO(
            codecId: LATESTCODEC,
            txId: txid,
            outputIdx: txidx,
            assetId: assetId,
            output: out);
        u.fromBuffer(Uint8List.fromList([
          ...u.getCodecIdBuffer(),
          ...txid,
          ...txidx,
          ...xferout.toBuffer()
        ]));
        utxos.add(u);
      }
      set.addArray(utxos);
    });

    test("SECPInput", () {
      final u = utxos[0];
      final txid = u.getTxId();
      final txidx = u.getOutputIdx();
      final asset = u.getAssetId();
      final amount = BigInt.from(amnt);
      final input = AvmSECPTransferInput(amount: amount);
      final xferinput = AvmTransferableInput(
          input: input, txId: txid, outputIdx: txidx, assetId: asset);

      expect(xferinput.getUTXOId(), u.getUTXOId());
      expect(input.getInputId(), SECPINPUTID);

      input.addSignatureIdx(0, addrs2[0]);
      input.addSignatureIdx(1, addrs2[1]);

      final newin = AvmSECPTransferInput();
      newin.fromBuffer(b58ToBuffer(input.toString()));
      expect(hexEncode(newin.toBuffer()), hexEncode(input.toBuffer()));
      expect(newin.getSigIdxs().toString(), input.getSigIdxs().toString());
    });

    test("Input comparator", () {
      final inpt1 = AvmSECPTransferInput(
          amount: (utxos[0].getOutput() as AvmAmountOutput).getAmount());

      final inpt2 = AvmSECPTransferInput(
          amount: (utxos[1].getOutput() as AvmAmountOutput).getAmount());

      final inpt3 = AvmSECPTransferInput(
          amount: (utxos[2].getOutput() as AvmAmountOutput).getAmount());

      final cmp = Input.comparator();
      expect(cmp(inpt1, inpt2), -1);
      expect(cmp(inpt1, inpt3), -1);
      expect(cmp(inpt1, inpt1), 0);
      expect(cmp(inpt2, inpt2), 0);
      expect(cmp(inpt3, inpt3), 0);
    });

    test("SECPTransferIn input codecIDs", () {
      final input = AvmSECPTransferInput(
          amount: (utxos[0].getOutput() as AvmAmountOutput).getAmount());

      expect(input.getCodecId(), codecID_zero);
      expect(input.getInputId(), SECPINPUTID);

      input.setCodecId(codecID_one);
      expect(input.getCodecId(), codecID_one);
      expect(input.getInputId(), SECPINPUTID_CODECONE);

      input.setCodecId(codecID_zero);
      expect(input.getCodecId(), codecID_zero);
      expect(input.getInputId(), SECPINPUTID);
    });

    test("Invalid SECPTransferInput codecID", () {
      final input = AvmSECPTransferInput(
          amount: (utxos[0].getOutput() as AvmAmountOutput).getAmount());

      expect(
          () => input.setCodecId(2), throwsA(predicate((e) => e is Exception)));
    });
  });
}

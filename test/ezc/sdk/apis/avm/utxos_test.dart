import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

void main() {
  group("Inputs", () {
    const utxohex =
        "000038d1b9f1138672da6fb6c35125539276a9acc2a668d63bea6ba3c795e2edb0f5000000013e07e38e2f23121be8756412c18db7246a16d26ee9936f3cba28be149cfd3558000000070000000000004dd500000000000000000000000100000001a36fd0c2dbcab311731dde7ef1514bd26fcdc74d";
    const outputidx = "00000001";
    const outtxid =
        "38d1b9f1138672da6fb6c35125539276a9acc2a668d63bea6ba3c795e2edb0f5";
    const outaid =
        "3e07e38e2f23121be8756412c18db7246a16d26ee9936f3cba28be149cfd3558";
    final utxobuff = hexDecode(utxohex);

    final OPUTXOstr = cb58Encode(utxobuff);

    test("Creation", () {
      final u1 = AvmUTXO();
      u1.fromBuffer(utxobuff);
      final u1hex = hexEncode(u1.toBuffer());
      expect(u1hex, utxohex);
    });

    test("Empty Creation", () {
      final u1 = AvmUTXO();
      expect(() => u1.toBuffer(), throwsA(predicate((e) => true)));
    });

    test("Creation of Type", () {
      final u1 = AvmUTXO();
      u1.fromString(OPUTXOstr);
      expect(u1.getOutput().getOutputId(), 7);
    });

    group("Funtionality", () {
      final u1 = AvmUTXO();
      u1.fromBuffer(utxobuff);
      test("getAssetID NonCA", () {
        final assetId = u1.getAssetId();
        expect(hexEncode(assetId), outaid);
      });

      test("getTxID", () {
        final txid = u1.getTxId();
        expect(hexEncode(txid), outtxid);
      });

      test("getOutputIdx", () {
        final txidx = u1.getOutputIdx();
        expect(hexEncode(txidx), outputidx);
      });

      test("getUTXOID", () {
        final txid = hexDecode(outtxid);
        final txidx = hexDecode(outputidx);
        final utxoid = bufferToB58(Uint8List.fromList([...txid, ...txidx]));
        expect(u1.getUTXOId(), utxoid);
      });

      test("toString", () {
        final serialized = u1.toString();
        expect(serialized, cb58Encode(utxobuff));
      });
    });
  });

  group("UTXOSet", () {
    final utxostrs = [
      cb58Encode(hexDecode(
          "000038d1b9f1138672da6fb6c35125539276a9acc2a668d63bea6ba3c795e2edb0f5000000013e07e38e2f23121be8756412c18db7246a16d26ee9936f3cba28be149cfd3558000000070000000000004dd500000000000000000000000100000001a36fd0c2dbcab311731dde7ef1514bd26fcdc74d")),
      cb58Encode(hexDecode(
          "0000c3e4823571587fe2bdfc502689f5a8238b9d0ea7f3277124d16af9de0d2d9911000000003e07e38e2f23121be8756412c18db7246a16d26ee9936f3cba28be149cfd355800000007000000000000001900000000000000000000000100000001e1b6b6a4bad94d2e3f20730379b9bcd6f176318e")),
      cb58Encode(hexDecode(
          "0000f29dba61fda8d57a911e7f8810f935bde810d3f8d495404685bdb8d9d8545e86000000003e07e38e2f23121be8756412c18db7246a16d26ee9936f3cba28be149cfd355800000007000000000000001900000000000000000000000100000001e1b6b6a4bad94d2e3f20730379b9bcd6f176318e")),
    ];
    final addrs = [
      cb58Decode("FuB6Lw2D62NuM8zpGLA4Avepq7eGsZRiG"),
      cb58Decode("MaTvKGccbYzCxzBkJpb2zHW7E1WReZqB8")
    ];

    test("Creation", () {
      final set = AvmUTXOSet();
      set.add(utxostrs[0]);
      final utxo = AvmUTXO();
      utxo.fromString(utxostrs[0]);
      final setArray = set.getAllUTXOs();
      expect(utxo.toString(), setArray[0].toString());
    });

    test("Bad Creation", () {
      final set = AvmUTXOSet();
      final bad = cb58Encode(hexDecode("abcd"));
      set.add(bad);
      final utxo = AvmUTXO();
      expect(() => utxo.fromString(bad), throwsA(predicate((e) => true)));
    });

    test("Mutliple add", () {
      final set = AvmUTXOSet();
      for (int i = 0; i < utxostrs.length; i++) {
        set.add(utxostrs[i]);
      }
      for (int i = 0; i < utxostrs.length; i++) {
        expect(set.includes(utxostrs[i]), true);
        final utxo = AvmUTXO();
        utxo.fromString(utxostrs[i]);
        final veriutxo = set.getUTXO(utxo.getUTXOId()) as AvmUTXO;
        expect(veriutxo.toString(), utxostrs[i]);
      }
    });

    test("addArray", () {
      final set = AvmUTXOSet();
      set.addArray(utxostrs);
      for (int i = 0; i < utxostrs.length; i++) {
        final e1 = AvmUTXO();
        e1.fromString(utxostrs[i]);
        expect(set.includes(e1), true);
        final utxo = AvmUTXO();
        utxo.fromString(utxostrs[i]);
        final veriutxo = set.getUTXO(utxo.getUTXOId()) as AvmUTXO;
        expect(veriutxo.toString(), utxostrs[i]);
      }

      set.addArray(set.getAllUTXOs());
      for (int i = 0; i < utxostrs.length; i++) {
        final utxo = AvmUTXO();
        utxo.fromString(utxostrs[i]);
        expect(set.includes(utxo), true);

        final veriutxo = set.getUTXO(utxo.getUTXOId()) as AvmUTXO;
        expect(veriutxo.toString(), utxostrs[i]);
      }

      final o = set.serialize(encoding: SerializedEncoding.hex);
      final s = AvmUTXOSet();
      s.deserialize(o);

      final t = set.serialize(encoding: SerializedEncoding.display);
      final r = AvmUTXOSet();
      r.deserialize(t);
    });

    test("overwriting UTXO", () {
      final set = AvmUTXOSet();
      set.addArray(utxostrs);
      final testutxo = AvmUTXO();
      testutxo.fromString(utxostrs[0]);
      expect(set.add(utxostrs[0], overwrite: true).toString(),
          testutxo.toString());
      expect(set.add(utxostrs[0], overwrite: false) == null, true);
      expect(set.addArray(utxostrs, overwrite: true).length, 3);
      expect(set.addArray(utxostrs, overwrite: false).length, 0);
    });

    group("Functionality", () {
      late AvmUTXOSet set;
      late List<AvmUTXO> utxos;
      setUp(() {
        set = AvmUTXOSet();
        set.addArray(utxostrs);
        utxos = set.getAllUTXOs();
      });

      test("remove", () {
        final testutxo = AvmUTXO();
        testutxo.fromString(utxostrs[0]);
        expect(set.remove(utxostrs[0]).toString(), testutxo.toString());
        expect(set.remove(utxostrs[0]) == null, true);
        expect(set.add(utxostrs[0], overwrite: false).toString(),
            testutxo.toString());
        expect(set.remove(utxostrs[0]).toString(), testutxo.toString());
      });

      test("removeArray", () {
        final testutxo = AvmUTXO();
        testutxo.fromString(utxostrs[0]);
        expect(set.removeArray(utxostrs).length, 3);
        expect(set.removeArray(utxostrs).length, 0);
        expect(set.add(utxostrs[0], overwrite: false).toString(),
            testutxo.toString());
        expect(set.removeArray(utxostrs).length, 1);
        expect(set.addArray(utxostrs, overwrite: false).length, 3);
        expect(set.removeArray(utxostrs).length, 3);
      });

      test("getUTXOIDs", () {
        final uids = set.getUTXOIds();
        for (int i = 0; i < utxos.length; i++) {
          expect(uids.contains(utxos[i].getUTXOId()), true);
        }
      });

      test("getAllUTXOs", () {
        final allutxos = set.getAllUTXOs();
        final ustrs = <String>[];
        for (int i = 0; i < allutxos.length; i++) {
          ustrs.add(allutxos[i].toString());
        }
        for (int i = 0; i < utxostrs.length; i++) {
          expect(ustrs.contains(utxostrs[i]), true);
        }
        final uids = set.getUTXOIds();
        final allutxos2 = set.getAllUTXOs(utxoIds: uids);
        final ustrs2 = <String>[];
        for (int i = 0; i < allutxos.length; i++) {
          ustrs2.add(allutxos2[i].toString());
        }
        for (int i = 0; i < utxostrs.length; i++) {
          expect(ustrs2.contains(utxostrs[i]), true);
        }
      });

      test("getUTXOIDs By Address", () {
        var utxoids = <String>[];
        utxoids = set.getUTXOIds(addresses: [addrs[0]]);
        expect(utxoids.length, 1);
        utxoids = set.getUTXOIds(addresses: addrs);
        expect(utxoids.length, 3);
        utxoids = set.getUTXOIds(addresses: addrs, spendable: false);
        expect(utxoids.length, 3);
      });

      test("getAllUTXOStrings", () {
        final ustrs = set.getAllUTXOStrings();
        for (int i = 0; i < utxostrs.length; i++) {
          expect(ustrs.contains(utxostrs[i]), true);
        }
        final uids = set.getUTXOIds();
        final ustrs2 = set.getAllUTXOStrings(utxoIds: uids);
        for (int i = 0; i < utxostrs.length; i++) {
          expect(ustrs2.contains(utxostrs[i]), true);
        }
      });

      test("getAddresses", () {
        expect(set.getAddresses()..sortBuffer(), addrs..sortBuffer());
      });

      test("getBalance", () {
        var balance1 = BigInt.zero;
        var balance2 = BigInt.zero;
        for (int i = 0; i < utxos.length; i++) {
          final assetId = utxos[i].getAssetId();
          balance1 += set.getBalance(addrs, assetId);
          balance2 += (utxos[i].getOutput() as AvmAmountOutput).getAmount();
        }
        expect(balance1, BigInt.from(59925));
        expect(balance2, BigInt.from(19975));

        balance1 = BigInt.zero;
        balance2 = BigInt.zero;
        final now = unixNow();
        for (int i = 0; i < utxos.length; i++) {
          final assetId = cb58Encode(utxos[i].getAssetId());
          balance1 = balance1 + set.getBalance(addrs, assetId, asOf: now);
          balance2 =
              balance2 + (utxos[i].getOutput() as AvmAmountOutput).getAmount();
        }
        expect(balance1, BigInt.from(59925));
        expect(balance2, BigInt.from(19975));
      });

      test("getAssetIDs", () {
        final assetIds = set.getAssetIds();
        for (int i = 0; i < utxos.length; i++) {
          expect(assetIds.contains(utxos[i].getAssetId()), true);
        }
        final addresses = set.getAddresses();
        expect(set.getAssetIds(addresses: addresses), set.getAssetIds());
      });
    });
  });
}

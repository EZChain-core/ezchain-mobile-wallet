import 'dart:convert';
import 'dart:typed_data';

import 'package:hash/hash.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';
import 'package:wallet/ezc/sdk/apis/avm/api.dart';
import 'package:wallet/ezc/sdk/apis/avm/base_tx.dart';
import 'package:wallet/ezc/sdk/apis/avm/constants.dart';
import 'package:wallet/ezc/sdk/apis/avm/inputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/key_chain.dart';
import 'package:wallet/ezc/sdk/apis/avm/model/get_asset_description.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/tx.dart';
import 'package:wallet/ezc/sdk/apis/avm/utxos.dart';
import 'package:wallet/ezc/sdk/common/rpc/rpc_response.dart';
import 'package:wallet/ezc/sdk/ezc.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/helper_functions.dart';

const _headers = {
  "Content-Type": "application/json",
};

void main() {
  group("Transactions", () {
    late MockWebServer _server;
    late EZC ezc;
    late AvmApi api;
    const netid = 12345;
    const protocol = "http";
    final bID = networks[netid]!.x.blockchainId;
    final assetID = SHA256()
        .update(utf8.encode(
            "Well, now, don't you tell me to smile, you stick around I'll make it worth your while."))
        .digest();
    const alias = "X";
    const amnt = 10000;

    late AvmUTXOSet set;
    late AvmKeyChain keymgr1;
    late AvmKeyChain keymgr2;
    late AvmKeyChain keymgr3;
    late List<Uint8List> addrs1;
    late List<Uint8List> addrs2;
    late List<Uint8List> addrs3;
    late List<AvmUTXO> utxos;
    late List<AvmTransferableInput> inputs;
    late List<AvmTransferableOutput> outputs;
    late List<AvmTransferableInput> importIns;
    late List<AvmUTXO> importUTXOs;
    late List<AvmTransferableOutput> exportOuts;
    late List<AvmUTXO> fungutxos;
    late List<String> exportUTXOIDS;
    const codecID_zero = 0;
    const codecID_one = 1;
    late BigInt amount;
    late List<Uint8List> addresses;
    late List<Uint8List> fallAddresses;
    late BigInt locktime;
    late BigInt fallLocktime;
    late int threshold;
    late int fallThreshold;
    const name = "Mortycoin is the dumb as a sack of hammers.";
    const symbol = "morT";
    const denomination = 8;
    final blockchainID = cb58Decode(bID);
    late Uint8List avaxAssetID;

    setUpAll(() async {
      _server = MockWebServer();
      await _server.start();

      ezc = EZC.create(
          host: _server.host,
          port: _server.port,
          protocol: protocol,
          networkId: netid,
          skipInit: true);

      api = AvmApi.create(
          ezcNetwork: ezc as EZCNetwork,
          endPoint: "/ext/bc/avm",
          blockChainId: bID);

      _server.enqueue(
          httpCode: 200,
          body: json.encode(RpcResponse(
                  result: GetAssetDescriptionResponse(
                      assetId: cb58Encode(assetID),
                      name: name,
                      symbol: symbol,
                      denomination: denomination.toString()))
              .toJson((value) => value.toJson())),
          headers: _headers);

      avaxAssetID = (await api.getAVAXAssetId())!;
    });

    tearDownAll(() {
      _server.shutdown();
    });

    setUp(() {
      set = AvmUTXOSet();
      keymgr1 = AvmKeyChain(chainId: alias, hrp: ezc.getHRP());
      keymgr2 = AvmKeyChain(chainId: alias, hrp: ezc.getHRP());
      keymgr3 = AvmKeyChain(chainId: alias, hrp: ezc.getHRP());
      addrs1 = [];
      addrs2 = [];
      addrs3 = [];
      utxos = [];
      inputs = [];
      outputs = [];
      importIns = [];
      importUTXOs = [];
      exportOuts = [];
      fungutxos = [];
      exportUTXOIDS = [];
      for (int i = 0; i < 3; i++) {
        addrs1.add(keymgr1.makeKey().getAddress());
        addrs2.add(keymgr2.makeKey().getAddress());
        addrs3.add(keymgr3.makeKey().getAddress());
      }
      amount = ONEAVAX * BigInt.from(amnt);
      addresses = keymgr1.getAddresses();
      fallAddresses = keymgr2.getAddresses();
      locktime = BigInt.from(54321);
      fallLocktime = locktime + BigInt.from(50);
      threshold = 3;
      fallThreshold = 1;

      final payload = Uint8List.fromList(utf8.encode(
          "All you Trekkies and TV addicts, Don't mean to diss don't mean to bring static."));

      for (int i = 0; i < 5; i++) {
        var txid = SHA256()
            .update(fromBNToBuffer(BigInt.from(i), length: 32))
            .digest();
        var txidx = fromBNToBuffer(BigInt.from(i), length: 4);
        final out = AvmSECPTransferOutput(
            amount: amount,
            addresses: addresses,
            lockTime: locktime,
            threshold: threshold);
        final xferout = AvmTransferableOutput(assetId: assetID, output: out);
        outputs.add(xferout);

        final u = AvmUTXO(
            codecId: LATESTCODEC,
            txId: txid,
            outputIdx: txidx,
            assetId: assetID,
            output: out);

        utxos.add(u);
        fungutxos.add(u);
        importUTXOs.add(u);

        txid = u.getTxId();
        txidx = u.getOutputIdx();

        final input = AvmSECPTransferInput(amount: amount);
        final xferin = AvmTransferableInput(
            txId: txid, outputIdx: txidx, assetId: assetID, input: input);
        inputs.add(xferin);
      }

      for (int i = 1; i < 4; i++) {
        importIns.add(inputs[i]);
        exportOuts.add(outputs[i]);
        exportUTXOIDS.add(fungutxos[i].getUTXOId());
      }
      set.addArray(utxos);
    });

    test("BaseTx codecIDs", () {
      final baseTx = AvmBaseTx();
      expect(baseTx.getCodecId(), codecID_zero);
      expect(baseTx.getTypeId(), BASETX);
      baseTx.setCodecId(codecID_one);
      expect(baseTx.getCodecId(), codecID_one);
      expect(baseTx.getTypeId(), BASETX_CODECONE);
      baseTx.setCodecId(codecID_zero);
      expect(baseTx.getCodecId(), codecID_zero);
      expect(baseTx.getTypeId(), BASETX);
    });

    test("Invalid BaseTx codecID", () {
      final baseTx = AvmBaseTx();
      expect(() => baseTx.setCodecId(2),
          throwsA(predicate((e) => e is Exception)));
    });

    test("Creation UnsignedTx", () {
      final baseTx = AvmBaseTx(
          networkId: netid,
          blockchainId: blockchainID,
          outs: outputs,
          ins: inputs);

      final txu = AvmUnsignedTx(transaction: baseTx);
      final txins = txu.getTransaction().getIns();
      final txouts = txu.getTransaction().getOuts();

      expect(txins.length, inputs.length);
      expect(txouts.length, outputs.length);
      expect(txu.getTransaction().getTxType(), 0);
      expect(txu.getTransaction().getNetworkId(), 12345);
      expect(hexEncode(txu.getTransaction().getBlockchainId()),
          hexEncode(blockchainID));

      final a = <String>[];
      final b = <String>[];
      for (int i = 0; i < txins.length; i++) {
        a.add(txins[i].toString());
        b.add(inputs[i].toString());
      }
      expect(a..sort(), b..sort());

      a.clear();
      b.clear();

      for (int i = 0; i < txouts.length; i++) {
        a.add(txouts[i].toString());
        b.add(outputs[i].toString());
      }

      expect(a..sort(), b..sort());
      final txunew = AvmUnsignedTx();
      txunew.fromBuffer(txu.toBuffer());

      expect(hexEncode(txunew.toBuffer()), hexEncode(txu.toBuffer()));
      expect(txunew.toString(), txu.toString());
    });

    test("Creation Tx1 with asof, locktime, threshold", () {
      final txu = set.buildBaseTx(
        netid,
        blockchainID,
        BigInt.from(9000),
        assetID,
        addrs3,
        addrs1,
        changeAddresses: addrs1,
        asOf: unixNow(),
        lockTime: unixNow() + BigInt.from(50),
        threshold: 1,
      );

      final tx = txu.sign(keymgr1);
      final tx2 = AvmTx();
      tx2.fromString(tx.toString());

      expect(hexEncode(tx2.toBuffer()), hexEncode(tx.toBuffer()));
      expect(tx2.toString(), tx.toString());
    });

    test("Creation Tx2 without asof, locktime, threshold", () {
      final txu = set.buildBaseTx(
        netid,
        blockchainID,
        BigInt.from(9000),
        assetID,
        addrs3,
        addrs1,
        changeAddresses: addrs1,
      );

      final txu2 = AvmUnsignedTx();
      txu2.fromBuffer(txu.toBuffer());
      expect(hexEncode(txu2.toBuffer()), hexEncode(txu.toBuffer()));

      final tx = txu.sign(keymgr1);
      final tx2 = AvmTx();
      final txBuffer = tx.toBuffer();
      tx2.fromBuffer(txBuffer);

      expect(hexEncode(tx2.toBuffer()), hexEncode(tx.toBuffer()));
      expect(tx2.toString(), tx.toString());
    });
  });
}

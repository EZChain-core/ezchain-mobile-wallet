import 'dart:convert';
import 'dart:typed_data';

import 'package:hash/hash.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';
import 'package:wallet/ezc/sdk/apis/pvm/api.dart';
import 'package:wallet/ezc/sdk/apis/pvm/constants.dart';
import 'package:wallet/ezc/sdk/apis/pvm/inputs.dart';
import 'package:wallet/ezc/sdk/apis/pvm/key_chain.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_staking_asset_id.dart';
import 'package:wallet/ezc/sdk/apis/pvm/outputs.dart';
import 'package:wallet/ezc/sdk/apis/pvm/tx.dart';
import 'package:wallet/ezc/sdk/apis/pvm/utxos.dart';
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
    late PvmApi api;
    const netid = 12345;
    const protocol = "http";
    final bID = networks[netid]!.x.blockchainId;
    final assetID = SHA256()
        .update(utf8.encode(
            "Well, now, don't you tell me to smile, you stick around I'll make it worth your while."))
        .digest();
    const alias = "X";
    const amnt = 10000;

    late PvmUTXOSet set;
    late PvmKeyChain keymgr1;
    late PvmKeyChain keymgr2;
    late PvmKeyChain keymgr3;
    late List<Uint8List> addrs1;
    late List<Uint8List> addrs2;
    late List<Uint8List> addrs3;
    late List<PvmUTXO> utxos;
    late List<PvmTransferableInput> inputs;
    late List<PvmTransferableOutput> outputs;
    late List<PvmTransferableInput> importIns;
    late List<PvmUTXO> importUTXOs;
    late List<PvmTransferableOutput> exportOuts;
    late List<PvmUTXO> fungutxos;
    late List<String> exportUTXOIDS;
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

      api = PvmApi.create(ezcNetwork: ezc as EZCNetwork, endPoint: "/ext/bc/P");

      _server.enqueue(
          httpCode: 200,
          body: json.encode(RpcResponse(
                  result:
                      GetStakingAssetIdResponse(assetId: cb58Encode(assetID)))
              .toJson((value) => value.toJson())),
          headers: _headers);

      avaxAssetID = (await api.getAVAXAssetId())!;
    });

    tearDownAll(() {
      _server.shutdown();
    });

    setUp(() {
      set = PvmUTXOSet();
      keymgr1 = PvmKeyChain(chainId: alias, hrp: ezc.getHRP());
      keymgr2 = PvmKeyChain(chainId: alias, hrp: ezc.getHRP());
      keymgr3 = PvmKeyChain(chainId: alias, hrp: ezc.getHRP());
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
      amount = BigInt.from(amnt);
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
        final out = PvmSECPTransferOutput(
            amount: amount,
            addresses: addresses,
            lockTime: locktime,
            threshold: threshold);
        final xferout = PvmTransferableOutput(assetId: assetID, output: out);
        outputs.add(xferout);

        final u = PvmUTXO(
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

        final input = PvmSECPTransferInput(amount: amount);
        final xferin = PvmTransferableInput(
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

    test("Creation Tx4 using ImportTx", () {
      final txu = set.buildImportTx(
        netid,
        blockchainID,
        importUTXOs,
        addrs3,
        addrs1,
        changeAddresses: addrs2,
        sourceChain: cb58Decode(platformChainId),
        fee: BigInt.from(90),
        feeAssetId: assetID,
        memo: Uint8List.fromList([
          ...Uint8List(1)..buffer.asByteData().setUint8(0, 0),
          ...utf8.encode("hello world")
        ]),
        asOf: unixNow(),
      );

      final tx = txu.sign(keymgr1);
      final tx2 = PvmTx();
      tx2.fromBuffer(tx.toBuffer());
      expect(hexEncode(tx2.toBuffer()), hexEncode(tx.toBuffer()));
    });

    test("Creation Tx5 using ExportTx", () {
      final txu = set.buildExportTx(
        netid,
        blockchainID,
        BigInt.from(90),
        avaxAssetID,
        cb58Decode(platformChainId),
        addrs3,
        addrs1,
        changeAddresses: addrs2,
        memo: Uint8List.fromList([
          ...Uint8List(1)..buffer.asByteData().setUint8(0, 0),
          ...utf8.encode("hello world")
        ]),
        asOf: unixNow(),
      );

      final tx = txu.sign(keymgr1);
      final tx2 = PvmTx();
      tx2.fromBuffer(tx.toBuffer());
      expect(hexEncode(tx2.toBuffer()), hexEncode(tx.toBuffer()));
    });
  });
}

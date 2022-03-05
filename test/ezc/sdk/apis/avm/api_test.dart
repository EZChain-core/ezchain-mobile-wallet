import 'dart:convert';
import 'dart:typed_data';

import 'package:hash/hash.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';
import 'package:wallet/ezc/sdk/apis/avm/api.dart';
import 'package:wallet/ezc/sdk/apis/avm/inputs.dart';
import 'package:wallet/ezc/sdk/apis/avm/key_chain.dart';
import 'package:wallet/ezc/sdk/apis/avm/model/get_asset_description.dart';
import 'package:wallet/ezc/sdk/apis/avm/outputs.dart';
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
    late AvmApi avm;
    const networkId = 12345;
    final blockChainId = networks[networkId]!.x.blockchainId;
    const protocol = "http";

    late String addrA;
    late String addrB;
    late String addrC;
    late String alias;
    late Uint8List avaxAssetID;
    final assetID =
        SHA256().update(utf8.encode("mary had a little lamb")).digest();
    const name = "Mortycoin is the dumb as a sack of hammers.";
    const symbol = "morT";
    const denomination = 8;

    setUpAll(() async {
      _server = MockWebServer();
      await _server.start();

      ezc = EZC.create(
          host: _server.host,
          port: _server.port,
          protocol: protocol,
          networkId: networkId,
          skipInit: true);

      final ezcNetwork = ezc as EZCNetwork;

      avm = AvmApi.create(
          ezcNetwork: ezcNetwork,
          endPoint: "/ext/bc/X",
          blockChainId: blockChainId);

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

      avaxAssetID = (await avm.getAVAXAssetId())!;

      alias = avm.getBlockchainAlias()!;

      addrA = addressToString(
          "X", ezcNetwork.hrp, cb58Decode("B6D4v1VtPYLbiUvYXtW4Px8oE9imC2vGW"));
      addrB = addressToString(
          "X", ezcNetwork.hrp, cb58Decode("P5wdRuZeaDt28eHMP5S3w9ZdoBfo7wuzF"));
      addrC = addressToString(
          "X", ezcNetwork.hrp, cb58Decode("6Y3kysjF9jnHnYkdS9yGAuoHyae2eNmeV"));
    });

    tearDownAll(() {
      _server.shutdown();
    });

    late AvmUTXOSet set;
    late AvmKeyChain keymgr2;
    late AvmKeyChain keymgr3;
    late List<String> addrs1;
    late List<String> addrs2;
    late List<String> addrs3;
    late List<AvmUTXO> utxos;
    late List<AvmTransferableInput> inputs;
    late List<AvmTransferableOutput> outputs;
    const amnt = 10000;

    late List<String> fungutxoids;
    late List<String> addresses;
    late List<Uint8List> addressBuffs;

    setUp(() async {
      set = AvmUTXOSet();
      avm.newKeyChain();
      keymgr2 = AvmKeyChain(chainId: alias, hrp: ezc.getHRP());
      keymgr3 = AvmKeyChain(chainId: alias, hrp: ezc.getHRP());
      addrs1 = [];
      addrs2 = [];
      addrs3 = [];
      utxos = [];
      inputs = [];
      outputs = [];
      fungutxoids = [];
      for (int i = 0; i < 3; i++) {
        addrs1.add(avm.addressFromBuffer(avm.keyChain.makeKey().getAddress()));
        addrs2.add(avm.addressFromBuffer(keymgr2.makeKey().getAddress()));
        addrs3.add(avm.addressFromBuffer(keymgr3.makeKey().getAddress()));
      }
      addressBuffs = avm.keyChain.getAddresses();
      addresses = addressBuffs.map((a) => avm.addressFromBuffer(a)).toList();

      final amount = ONEAVAX * BigInt.from(amnt);
      final locktime = BigInt.from(54321);
      const threshold = 3;

      for (int i = 0; i < 5; i++) {
        var txid = SHA256()
            .update(fromBNToBuffer(BigInt.from(i), length: 32))
            .digest();
        var txidx = Uint8List(4);
        txidx.buffer.asByteData().setUint32(0, i);

        final out = AvmSECPTransferOutput(
            amount: amount,
            addresses: addressBuffs,
            lockTime: locktime,
            threshold: threshold);
        final xferout = AvmTransferableOutput(assetId: assetID, output: out);
        outputs.add(xferout);

        final u = AvmUTXO();
        u.fromBuffer(Uint8List.fromList([
          ...u.getCodecIdBuffer(),
          ...txid,
          ...txidx,
          ...xferout.toBuffer()
        ]));

        fungutxoids.add(u.getUTXOId());
        utxos.add(u);

        txid = u.getTxId();
        txidx = u.getOutputIdx();

        final input = AvmSECPTransferInput(amount: amount);
        final xferin = AvmTransferableInput(
            txId: txid, outputIdx: txidx, assetId: assetID, input: input);
        inputs.add(xferin);
      }
      set.addArray(utxos);
    });

    test("buildBaseTx1", () async {
      final txu1 = await avm.buildBaseTx(
          set, BigInt.from(amnt), cb58Encode(assetID), addrs3, addrs1, addrs1,
          memo: Uint8List.fromList(utf8.encode("hello world")));

      final memoBuff = Uint8List.fromList(utf8.encode("hello world"));

      final txu2 = set.buildBaseTx(
          networkId,
          cb58Decode(blockChainId),
          BigInt.from(amnt),
          assetID,
          addrs3.map((a) => avm.parseAddress(a)).toList(),
          addrs1.map((a) => avm.parseAddress(a)).toList(),
          changeAddresses: addrs1.map((a) => avm.parseAddress(a)).toList(),
          fee: avm.getTxFee(),
          feeAssetId: assetID,
          memo: memoBuff,
          asOf: unixNow(),
          lockTime: BigInt.zero,
          threshold: 1);

      expect(hexEncode(txu2.toBuffer()), hexEncode(txu1.toBuffer()));
      expect(txu2.toString(), txu1.toString());
    });

    test("issueTx Serialized", () async {
      final txu = await avm.buildBaseTx(
          set, BigInt.from(amnt), cb58Encode(assetID), addrs3, addrs1, addrs1);
      final tx = txu.sign(avm.keyChain as AvmKeyChain);
      final txId = avm.issueTx(tx);
    });
  });
}

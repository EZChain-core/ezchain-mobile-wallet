import 'dart:convert';
import 'dart:typed_data';

import 'package:hash/hash.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';
import 'package:wallet/ezc/sdk/apis/pvm/api.dart';
import 'package:wallet/ezc/sdk/apis/pvm/inputs.dart';
import 'package:wallet/ezc/sdk/apis/pvm/model/get_staking_asset_id.dart';
import 'package:wallet/ezc/sdk/apis/pvm/outputs.dart';
import 'package:wallet/ezc/sdk/apis/pvm/utxos.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
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
    late PvmApi pvm;
    const networkId = 12345;
    final blockChainId = networks[networkId]!.x.blockchainId;
    const protocol = "http";

    const nodeID = "NodeID-B6D4v1VtPYLbiUvYXtW4Px8oE9imC2vGW";
    final startTime = unixNow() + BigInt.from(60 * 5);
    final endTime = startTime + BigInt.from(1209600);

    late String addrA;
    late String addrB;
    late String addrC;
    late String alias;
    late Uint8List avaxAssetID;
    final assetID =
        SHA256().update(utf8.encode("mary had a little lamb")).digest();
    const name = "Mortycoin is the dumb as a sack of hammers.";
    const symbol = "morT";
    const fee = 10;
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

      pvm = PvmApi.create(ezcNetwork: ezcNetwork);

      _server.enqueue(
          httpCode: 200,
          body: json.encode(RpcResponse(
                  result:
                      GetStakingAssetIdResponse(assetId: cb58Encode(assetID)))
              .toJson((value) => value.toJson())),
          headers: _headers);

      avaxAssetID = (await pvm.getAVAXAssetId())!;

      alias = pvm.getBlockchainAlias()!;

      addrA = addressToString(
          "P", ezcNetwork.hrp, cb58Decode("B6D4v1VtPYLbiUvYXtW4Px8oE9imC2vGW"));
      addrB = addressToString(
          "P", ezcNetwork.hrp, cb58Decode("P5wdRuZeaDt28eHMP5S3w9ZdoBfo7wuzF"));
      addrC = addressToString(
          "P", ezcNetwork.hrp, cb58Decode("6Y3kysjF9jnHnYkdS9yGAuoHyae2eNmeV"));
    });

    tearDownAll(() {
      _server.shutdown();
    });

    late PvmUTXOSet set;
    late PvmUTXOSet lset;
    late EZCKeyChain keymgr2;
    late EZCKeyChain keymgr3;
    late List<String> addrs1;
    late List<String> addrs2;
    late List<String> addrs3;
    late List<PvmUTXO> utxos;
    late List<PvmUTXO> lutxos;
    late List<PvmTransferableInput> inputs;
    late List<PvmTransferableOutput> outputs;
    const amnt = 10000;
    late PvmSECPTransferOutput secpbase1;
    late PvmSECPTransferOutput secpbase2;
    late PvmSECPTransferOutput secpbase3;
    late List<String> fungutxoids;
    late List<String> addresses;
    late List<Uint8List> addressbuffs;

    setUp(() async {
      set = PvmUTXOSet();
      lset = PvmUTXOSet();
      pvm.newKeyChain();
      keymgr2 = EZCKeyChain(chainId: alias, hrp: ezc.getHRP());
      keymgr3 = EZCKeyChain(chainId: alias, hrp: ezc.getHRP());
      addrs1 = [];
      addrs2 = [];
      addrs3 = [];
      utxos = [];
      lutxos = [];
      inputs = [];
      outputs = [];
      fungutxoids = [];
      for (int i = 0; i < 3; i++) {
        addrs1.add(pvm.addressFromBuffer(pvm.keyChain.makeKey().getAddress()));
        addrs2.add(pvm.addressFromBuffer(keymgr2.makeKey().getAddress()));
        addrs3.add(pvm.addressFromBuffer(keymgr3.makeKey().getAddress()));
      }
      addressbuffs = pvm.keyChain.getAddresses();
      addresses = addressbuffs.map((a) => pvm.addressFromBuffer(a)).toList();

      final amount = ONEAVAX * BigInt.from(amnt);
      final locktime = BigInt.from(54321);
      const threshold = 3;

      for (int i = 0; i < 5; i++) {
        var txid = SHA256()
            .update(fromBNToBuffer(BigInt.from(i), length: 32))
            .digest();
        var txidx = Uint8List(4);
        txidx.buffer.asByteData().setUint32(0, i);

        final out = PvmSECPTransferOutput(
            amount: amount,
            addresses: addressbuffs,
            lockTime: locktime,
            threshold: threshold);
        final xferout = PvmTransferableOutput(assetId: assetID, output: out);
        outputs.add(xferout);

        final u = PvmUTXO();
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
        final asset = u.getAssetId();

        final input = PvmSECPTransferInput(amount: amount);
        final xferin = PvmTransferableInput(
            txId: txid, outputIdx: txidx, assetId: assetID, input: input);
        inputs.add(xferin);
      }
      set.addArray(utxos);

      // for (var i = 0; i < 4; i++) {
      //   var txid = SHA256()
      //       .update(fromBNToBuffer(BigInt.from(i), length: 32))
      //       .digest();
      //   var txidx = Uint8List(4);
      //   txidx.buffer.asByteData().setUint32(0, i);
      //
      //   final out = PvmSECPTransferOutput(
      //     amount: ONEAVAX * BigInt.from(5),
      //     addresses: addressbuffs,
      //     lockTime: locktime,
      //     threshold: 1,
      //   );
      //   final pout = PvmParseableOutput(output: out);
      //   final lockout = PvmStakeableLockOut(
      //     amount: ONEAVAX * BigInt.from(5),
      //     addresses: addressbuffs,
      //     lockTime: locktime,
      //     threshold: 1,
      //     stakeableLockTime: locktime * BigInt.from(86400),
      //     transferableOutput: pout,
      //   );
      //   final xferout = PvmTransferableOutput(
      //     assetId: assetID,
      //     output: lockout,
      //   );
      //
      //   final u = PvmUTXO();
      //   u.fromBuffer(Uint8List.fromList([
      //     ...u.getCodecIdBuffer(),
      //     ...txid,
      //     ...txidx,
      //     ...xferout.toBuffer()
      //   ]));
      //   lutxos.add(u);
      // }
      //
      // lset.addArray(lutxos);
      // lset.addArray(set.getAllUTXOs());
      //
      // secpbase1 = PvmSECPTransferOutput(
      //   amount: BigInt.from(777),
      //   addresses: addrs3.map((a) => pvm.parseAddress(a)).toList(),
      //   lockTime: unixNow(),
      //   threshold: 1,
      // );
      // secpbase2 = PvmSECPTransferOutput(
      //   amount: BigInt.from(888),
      //   addresses: addrs2.map((a) => pvm.parseAddress(a)).toList(),
      //   lockTime: unixNow(),
      //   threshold: 1,
      // );
      // secpbase3 = PvmSECPTransferOutput(
      //   amount: BigInt.from(999),
      //   addresses: addrs2.map((a) => pvm.parseAddress(a)).toList(),
      //   lockTime: unixNow(),
      //   threshold: 1,
      // );
    });

    test("buildAddDelegatorTx 1", () async {
      final addrbuff1 = addrs1.map((a) => pvm.parseAddress(a)).toList();
      final addrbuff2 = addrs2.map((a) => pvm.parseAddress(a)).toList();
      final addrbuff3 = addrs3.map((a) => pvm.parseAddress(a)).toList();
      final amount = networks[networkId]!.p.minDelegationStake;

      final locktime = BigInt.from(54321);
      const threshold = 2;

      pvm.setMinStake(
        networks[networkId]!.p.minStake,
        networks[networkId]!.p.minDelegationStake,
      );

      final txu1 = await pvm.buildAddDelegatorTx(
        set,
        addrs3,
        addrs1,
        addrs2,
        nodeID,
        startTime,
        endTime,
        amount,
        addrs3,
        rewardLockTime: locktime,
        rewardThreshold: threshold,
        memo: Uint8List.fromList([
          ...Uint8List(1)..buffer.asByteData().setUint8(0, 0),
          ...utf8.encode("hello world")
        ]),
        asOf: unixNow(),
      );

      final txu2 = set.buildAddDelegatorTx(
        networkId,
        cb58Decode(blockChainId),
        assetID,
        addrbuff3,
        addrbuff1,
        addrbuff2,
        nodeIdStringToBuffer(nodeID),
        startTime,
        endTime,
        amount,
        locktime,
        threshold,
        addrbuff3,
        fee: BigInt.zero,
        feeAssetId: assetID,
        memo: Uint8List.fromList([
          ...Uint8List(1)..buffer.asByteData().setUint8(0, 0),
          ...utf8.encode("hello world")
        ]),
        asOf: unixNow(),
      );

      expect(txu1.toString(), txu2.toString());
    });
  });
}

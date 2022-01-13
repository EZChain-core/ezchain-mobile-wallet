import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/pvm/base_tx.dart';
import 'package:wallet/roi/sdk/apis/pvm/constants.dart';
import 'package:wallet/roi/sdk/apis/pvm/outputs.dart';
import 'package:wallet/roi/sdk/common/input.dart';
import 'package:wallet/roi/sdk/common/output.dart';
import 'package:wallet/roi/sdk/utils/bindtools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/helper_functions.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

abstract class PvmValidatorTx extends PvmBaseTx {
  @override
  String get typeName => "PvmValidatorTx";

  Uint8List nodeId = Uint8List(20);
  Uint8List startTime = Uint8List(8);
  Uint8List endTime = Uint8List(8);

  PvmValidatorTx({
    int networkId = defaultNetworkId,
    Uint8List? blockchainId,
    List<StandardTransferableOutput>? outs,
    List<StandardTransferableInput>? ins,
    Uint8List? memo,
    Uint8List? nodeId,
    BigInt? startTime,
    BigInt? endTime,
  }) : super(
            networkId: networkId,
            blockchainId: blockchainId,
            outs: outs,
            ins: ins,
            memo: memo) {
    if (nodeId != null) {
      this.nodeId;
    }
    if (startTime != null) {
      this.startTime = fromBNToBuffer(startTime, length: 8);
    }
    if (endTime != null) {
      this.endTime = fromBNToBuffer(endTime, length: 8);
    }
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "nodeId": Serialization.instance.encoder(
        nodeId,
        encoding,
        SerializedType.Buffer,
        SerializedType.nodeId,
      ),
      "startTime": Serialization.instance.encoder(
        startTime,
        encoding,
        SerializedType.Buffer,
        SerializedType.decimalString,
      ),
      "endTime": Serialization.instance.encoder(
        endTime,
        encoding,
        SerializedType.Buffer,
        SerializedType.decimalString,
      ),
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    nodeId = Serialization.instance.decoder(
      fields["nodeId"],
      encoding,
      SerializedType.nodeId,
      SerializedType.Buffer,
      args: [20],
    );
    startTime = Serialization.instance.decoder(
      fields["startTime"],
      encoding,
      SerializedType.decimalString,
      SerializedType.Buffer,
      args: [8],
    );
    endTime = Serialization.instance.decoder(
      fields["endTime"],
      encoding,
      SerializedType.decimalString,
      SerializedType.Buffer,
      args: [8],
    );
  }

  Uint8List getNodeId() => nodeId;

  String getNodeIdString() => bufferToNodeIdString(nodeId);

  BigInt getStartTime() => fromBufferToBN(startTime);

  BigInt getEndTime() => fromBufferToBN(endTime);

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    offset = super.fromBuffer(bytes, offset: offset);
    nodeId = bytes.sublist(offset, offset + 20);
    offset += 20;
    startTime = bytes.sublist(offset, offset + 8);
    offset += 8;
    endTime = bytes.sublist(offset, offset + 8);
    offset += 8;
    return offset;
  }

  @override
  Uint8List toBuffer() {
    final superBuff = super.toBuffer();
    return Uint8List.fromList([
      ...superBuff,
      ...nodeId,
      ...startTime,
      ...endTime,
    ]);
  }
}

abstract class PvmWeightedValidatorTx extends PvmValidatorTx {
  @override
  String get typeName => "PvmWeightedValidatorTx";

  Uint8List weight = Uint8List(8);

  PvmWeightedValidatorTx({
    int networkId = defaultNetworkId,
    Uint8List? blockchainId,
    List<StandardTransferableOutput>? outs,
    List<StandardTransferableInput>? ins,
    Uint8List? memo,
    Uint8List? nodeId,
    BigInt? startTime,
    BigInt? endTime,
    BigInt? weight,
  }) : super(
            networkId: networkId,
            blockchainId: blockchainId,
            outs: outs,
            ins: ins,
            memo: memo,
            nodeId: nodeId,
            startTime: startTime,
            endTime: endTime) {
    if (weight != null) {
      this.weight = fromBNToBuffer(weight, length: 8);
    }
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "weight": Serialization.instance.encoder(
        weight,
        encoding,
        SerializedType.Buffer,
        SerializedType.decimalString,
      ),
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    weight = Serialization.instance.decoder(
      fields["weight"],
      encoding,
      SerializedType.decimalString,
      SerializedType.Buffer,
      args: [8],
    );
  }

  BigInt getWeight() => fromBufferToBN(weight);

  Uint8List getWeightBuffer() => weight;

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    offset = super.fromBuffer(bytes, offset: offset);
    weight = bytes.sublist(offset, offset + 8);
    offset += 8;
    return offset;
  }

  @override
  Uint8List toBuffer() {
    final superBuff = super.toBuffer();
    return Uint8List.fromList([...superBuff, ...weight]);
  }
}

class PvmAddDelegatorTx extends PvmWeightedValidatorTx {
  @override
  String get typeName => "PvmValidatorTx";

  final stakeOuts = <PvmTransferableOutput>[];
  late PvmParseableOutput rewardOwners;

  PvmAddDelegatorTx({
    int networkId = defaultNetworkId,
    Uint8List? blockchainId,
    List<StandardTransferableOutput>? outs,
    List<StandardTransferableInput>? ins,
    Uint8List? memo,
    Uint8List? nodeId,
    BigInt? startTime,
    BigInt? endTime,
    BigInt? stakeAmount,
    List<PvmTransferableOutput>? stakeOuts,
    PvmParseableOutput? rewardOwners,
  }) : super(
            networkId: networkId,
            blockchainId: blockchainId,
            outs: outs,
            ins: ins,
            memo: memo,
            nodeId: nodeId,
            startTime: startTime,
            endTime: endTime,
            weight: stakeAmount) {
    setTypeId(ADDDELEGATORTX);
  }

  factory PvmAddDelegatorTx.fromArgs(Map<String, dynamic> args) {
    return PvmAddDelegatorTx(
      networkId: args["networkId"] ?? defaultNetworkId,
      blockchainId: args["blockchainId"],
      outs: args["outs"],
      ins: args["ins"],
      memo: args["memo"],
      nodeId: args["nodeId"],
      startTime: args["startTime"],
      endTime: args["endTime"],
      stakeAmount: args["stakeAmount"],
      stakeOuts: args["stakeOuts"],
      rewardOwners: args["rewardOwners"],
    );
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "stakeOuts": stakeOuts.map((e) => e.serialize(encoding: encoding)),
      "rewardOwners": rewardOwners.serialize(encoding: encoding)
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    final stakeOuts = (fields["stakeOuts"] as List<dynamic>).map((e) {
      final xFerout = PvmTransferableOutput();
      xFerout.deserialize(e, encoding: encoding);
      return xFerout;
    });
    this.stakeOuts.clear();
    this.stakeOuts.addAll(stakeOuts);
    rewardOwners = PvmParseableOutput();
    rewardOwners.deserialize(fields["rewardOwners"], encoding: encoding);
  }

  @override
  int getTxType() => getTypeId();

  BigInt getStakeAmount() => getWeight();

  Uint8List getStakeAmountBuffer() => weight;

  List<PvmTransferableOutput> getStakeOuts() => stakeOuts;

  BigInt getStakeOutsTotal() {
    var value = BigInt.zero;
    for (int i = 0; i < stakeOuts.length; i++) {
      final output = stakeOuts[i].getOutput() as PvmAmountOutput;
      value += output.getAmount();
    }
    return value;
  }

  PvmParseableOutput getRewardOwners() => rewardOwners;

  @override
  List<PvmTransferableOutput> getTotalOuts() {
    return List.from([...getOuts(), ...getStakeOuts()]);
  }

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    offset = super.fromBuffer(bytes, offset: offset);
    final numStakeouts = bytes.sublist(offset, offset + 4);
    offset += 4;
    final outCount = numStakeouts.buffer.asByteData().getUint32(0);
    stakeOuts.clear();
    for (int i = 0; i < outCount; i++) {
      final xFerout = PvmTransferableOutput();
      offset = xFerout.fromBuffer(bytes, offset: offset);
      stakeOuts.add(xFerout);
    }
    rewardOwners = PvmParseableOutput();
    offset = rewardOwners.fromBuffer(bytes, offset: offset);
    return offset;
  }

  @override
  Uint8List toBuffer() {
    final superBuff = super.toBuffer();
    final numOuts = Uint8List(4);
    numOuts.buffer.asByteData().setUint32(0, stakeOuts.length);
    final barr = [superBuff, numOuts];
    stakeOuts.sort(StandardParseableOutput.comparator());
    for (int i = 0; i < stakeOuts.length; i++) {
      final out = stakeOuts[i].toBuffer();
      barr.add(out);
    }
    final ro = rewardOwners.toBuffer();
    barr.add(ro);
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  @override
  PvmAddDelegatorTx clone() {
    return PvmAddDelegatorTx()..fromBuffer(toBuffer());
  }

  @override
  PvmBaseTx create({Map<String, dynamic> args = const {}}) {
    return PvmAddDelegatorTx.fromArgs(args);
  }
}

class PvmAddValidatorTx extends PvmAddDelegatorTx {
  @override
  String get typeName => "PvmAddValidatorTx";

  num delegationFee = 0;
  int delegatorMultiplier = 10000;

  PvmAddValidatorTx(
      {int networkId = defaultNetworkId,
      Uint8List? blockchainId,
      List<StandardTransferableOutput>? outs,
      List<StandardTransferableInput>? ins,
      Uint8List? memo,
      Uint8List? nodeId,
      BigInt? startTime,
      BigInt? endTime,
      BigInt? stakeAmount,
      List<PvmTransferableOutput>? stakeOuts,
      PvmParseableOutput? rewardOwners,
      num? delegationFee})
      : super(
            networkId: networkId,
            blockchainId: blockchainId,
            outs: outs,
            ins: ins,
            memo: memo,
            nodeId: nodeId,
            startTime: startTime,
            endTime: endTime,
            stakeAmount: stakeAmount,
            stakeOuts: stakeOuts,
            rewardOwners: rewardOwners) {
    setTypeId(ADDVALIDATORTX);
    if (delegationFee != null) {
      if (delegationFee >= 0 && delegationFee <= 100) {
        this.delegationFee = double.parse(delegationFee.toStringAsFixed(4));
      } else {
        throw Exception(
            "AddValidatorTx.constructor -- delegationFee must be in the range of 0 and 100, inclusively.");
      }
    }
  }

  factory PvmAddValidatorTx.fromArgs(Map<String, dynamic> args) {
    return PvmAddValidatorTx(
      networkId: args["networkId"] ?? defaultNetworkId,
      blockchainId: args["blockchainId"],
      outs: args["outs"],
      ins: args["ins"],
      memo: args["memo"],
      nodeId: args["nodeId"],
      startTime: args["startTime"],
      endTime: args["endTime"],
      stakeAmount: args["stakeAmount"],
      stakeOuts: args["stakeOuts"],
      rewardOwners: args["rewardOwners"],
      delegationFee: args["delegationFee"],
    );
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "delegationFee": Serialization.instance.encoder(
        delegationFee,
        encoding,
        SerializedType.Buffer,
        SerializedType.decimalString,
        args: [4],
      ),
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    final dBuff = Serialization.instance.decoder(
      fields["delegationFee"],
      encoding,
      SerializedType.decimalString,
      SerializedType.Buffer,
      args: [4],
    ) as Uint8List;
    delegationFee =
        dBuff.buffer.asByteData().getUint32(0) / delegatorMultiplier;
  }

  @override
  int getTxType() => getTypeId();

  num getDelegationFee() => delegationFee;

  Uint8List getDelegationFeeBuffer() {
    final dBuff = Uint8List(4);
    final buffNum =
        double.parse(delegationFee.toStringAsFixed(4)) * delegatorMultiplier;
    dBuff.buffer.asByteData().setUint32(0, buffNum.toInt());
    return dBuff;
  }

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    offset = super.fromBuffer(bytes, offset: offset);
    final dBuff = bytes.sublist(offset, offset + 4);
    offset += 4;
    delegationFee =
        dBuff.buffer.asByteData().getUint32(0) / delegatorMultiplier;
    return offset;
  }

  @override
  Uint8List toBuffer() {
    final superBuff = super.toBuffer();
    final feeBuff = getDelegationFeeBuffer();
    return Uint8List.fromList([...superBuff, ...feeBuff]);
  }
}

import 'dart:typed_data';

import 'package:wallet/roi/sdk/apis/evm/base_tx.dart';
import 'package:wallet/roi/sdk/apis/evm/constants.dart';
import 'package:wallet/roi/sdk/apis/evm/credentials.dart';
import 'package:wallet/roi/sdk/apis/evm/inputs.dart';
import 'package:wallet/roi/sdk/apis/evm/key_chain.dart';
import 'package:wallet/roi/sdk/apis/evm/outputs.dart';
import 'package:wallet/roi/sdk/common/credentials.dart';
import 'package:wallet/roi/sdk/utils/bintools.dart';
import 'package:wallet/roi/sdk/utils/constants.dart';
import 'package:wallet/roi/sdk/utils/serialization.dart';

class EvmExportTx extends EvmBaseTx {
  @override
  String get typeName => "EvmExportTx";

  var destinationChain = Uint8List(32);
  var numInputs = Uint8List(4);
  var inputs = <EvmInput>[];
  var numExportedOutputs = Uint8List(4);
  var exportedOutputs = <EvmTransferableOutput>[];

  EvmExportTx(
      {int networkId = defaultNetworkId,
      Uint8List? blockchainId,
      Uint8List? destinationChain,
      List<EvmInput>? inputs,
      List<EvmTransferableOutput>? exportedOutputs})
      : super(networkId: networkId, blockchainId: blockchainId) {
    setTypeId(EXPORTTX);
    if (destinationChain != null) {
      this.destinationChain = destinationChain;
    }
    if (inputs != null) {
      if (inputs.length > 1) {
        inputs.sort(EvmOutput.comparator());
      }
      this.inputs = inputs;
    }
    if (exportedOutputs != null) {
      this.exportedOutputs = exportedOutputs;
    }
  }

  factory EvmExportTx.fromArgs(Map<String, dynamic> args) {
    return EvmExportTx(
      networkId: args["networkId"] ?? defaultNetworkId,
      blockchainId: args["blockchainId"],
      destinationChain: args["destinationChain"],
      inputs: args["inputs"],
      exportedOutputs: args["exportedOutputs"],
    );
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "destinationChain": Serialization.instance.encoder(
        destinationChain,
        encoding,
        SerializedType.Buffer,
        SerializedType.cb58,
      ),
      "exportedOutputs": exportedOutputs.map(
        (e) => e.serialize(encoding: encoding),
      )
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    destinationChain = Serialization.instance.decoder(
      fields["destinationChain"],
      encoding,
      SerializedType.cb58,
      SerializedType.Buffer,
      args: [32],
    );
    exportedOutputs = (fields["exportedOutputs"] as List<dynamic>)
        .map((e) => EvmTransferableOutput()..deserialize(e, encoding: encoding))
        .toList();
    numExportedOutputs.buffer.asByteData().setUint32(0, exportedOutputs.length);
  }

  @override
  Uint8List toBuffer() {
    numInputs.buffer.asByteData().setUint32(0, inputs.length);
    numExportedOutputs.buffer.asByteData().setUint32(0, exportedOutputs.length);
    final barr = [super.toBuffer(), destinationChain, numInputs];
    for (int i = 0; i < inputs.length; i++) {
      barr.add(inputs[i].toBuffer());
    }
    barr.add(numExportedOutputs);
    for (int i = 0; i < exportedOutputs.length; i++) {
      barr.add(exportedOutputs[i].toBuffer());
    }
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    offset = super.fromBuffer(bytes, offset: offset);
    destinationChain = bytes.sublist(offset, offset + 32);
    offset += 32;
    numInputs = bytes.sublist(offset, offset + 4);
    offset += 4;
    final inputLength = numInputs.buffer.asByteData().getUint32(0);
    inputs.clear();
    for (int i = 0; i < inputLength; i++) {
      final anIn = EvmInput();
      offset = anIn.fromBuffer(bytes, offset: offset);
      inputs.add(anIn);
    }
    numExportedOutputs = bytes.sublist(offset, offset + 4);
    offset += 4;
    final outputLength = numExportedOutputs.buffer.asByteData().getUint32(0);
    for (int i = 0; i < outputLength; i++) {
      final anOut = EvmTransferableOutput();
      offset = anOut.fromBuffer(bytes, offset: offset);
      exportedOutputs.add(anOut);
    }
    return offset;
  }

  @override
  String toString() => bufferToB58(toBuffer());

  @override
  List<Credential> sign(Uint8List msg, EvmKeyChain kc) {
    final signs = <Credential>[];
    for (int i = 0; i < inputs.length; i++) {
      final input = inputs[i];
      final credential = selectCredentialClass(input.getCredentialId());
      final signIdxs = input.getSigIdxs();
      for (int j = 0; j < signIdxs.length; j++) {
        final keyPair = kc.getKey(signIdxs[j].getSource());
        final signVal = keyPair!.sign(msg);
        final signature = Signature()..fromBuffer(signVal);
        credential.addSignature(signature);
      }
      signs.add(credential);
    }
    return signs;
  }

  Uint8List getDestinationChain() => destinationChain;

  List<EvmInput> getInputs() => inputs;

  List<EvmTransferableOutput> getExportedOutputs() => exportedOutputs;
}

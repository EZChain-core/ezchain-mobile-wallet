import 'dart:typed_data';

import 'package:wallet/ezc/sdk/apis/avm/credentials.dart';
import 'package:wallet/ezc/sdk/apis/evm/base_tx.dart';
import 'package:wallet/ezc/sdk/apis/evm/constants.dart';
import 'package:wallet/ezc/sdk/apis/evm/inputs.dart';
import 'package:wallet/ezc/sdk/apis/evm/outputs.dart';
import 'package:wallet/ezc/sdk/common/credentials.dart';
import 'package:wallet/ezc/sdk/common/input.dart';
import 'package:wallet/ezc/sdk/common/keychain/ezc_key_chain.dart';
import 'package:wallet/ezc/sdk/utils/bintools.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/sdk/utils/serialization.dart';

class EvmImportTx extends EvmBaseTx {
  @override
  String get typeName => "EvmImportTx";

  var sourceChain = Uint8List(32);
  var numIns = Uint8List(4);
  var importIns = <EvmTransferableInput>[];
  var numOuts = Uint8List(4);
  var outs = <EvmOutput>[];

  EvmImportTx(
      {int networkId = defaultNetworkId,
      Uint8List? blockchainId,
      Uint8List? sourceChain,
      List<EvmTransferableInput>? importIns,
      List<EvmOutput>? outs,
      BigInt? fee})
      : super(networkId: networkId, blockchainId: blockchainId) {
    setTypeId(IMPORTTX);
    if (sourceChain != null) {
      this.sourceChain = sourceChain;
    }
    var inputsPassed = false;
    var outputsPassed = false;
    if (importIns != null && importIns.isNotEmpty) {
      inputsPassed = true;
      this.importIns = importIns;
    }
    if (outs != null && outs.isNotEmpty) {
      if (outs.length > 1) {
        outs.sort(EvmOutput.comparator());
      }
      outputsPassed = true;
      this.outs = outs;
    }
    if (inputsPassed && outputsPassed) {
      _validateOuts(fee ?? BigInt.zero);
    }
  }

  factory EvmImportTx.fromArgs(Map<String, dynamic> args) {
    return EvmImportTx(
      networkId: args["networkId"] ?? defaultNetworkId,
      blockchainId: args["blockchainId"],
      sourceChain: args["sourceChain"],
      importIns: args["importIns"],
      outs: args["outs"],
      fee: args["fee"],
    );
  }

  @override
  serialize({SerializedEncoding encoding = SerializedEncoding.hex}) {
    final fields = super.serialize(encoding: encoding);
    return {
      ...fields,
      "sourceChain": Serialization.instance.encoder(
        sourceChain,
        encoding,
        SerializedType.buffer,
        SerializedType.cb58,
      ),
      "importIns": importIns.map((e) => e.serialize(encoding: encoding))
    };
  }

  @override
  void deserialize(dynamic fields,
      {SerializedEncoding encoding = SerializedEncoding.hex}) {
    super.deserialize(fields, encoding: encoding);
    sourceChain = Serialization.instance.decoder(
      fields["sourceChain"],
      encoding,
      SerializedType.cb58,
      SerializedType.buffer,
      args: [32],
    );
    importIns = (fields["importIns"] as List<dynamic>)
        .map((e) => EvmTransferableInput()..deserialize(e, encoding: encoding))
        .toList();
    numIns.buffer.asByteData().setUint32(0, importIns.length);
  }

  @override
  int getTxType() => getTypeId();

  @override
  int fromBuffer(Uint8List bytes, {int offset = 0}) {
    offset = super.fromBuffer(bytes, offset: offset);
    sourceChain = bytes.sublist(offset, offset + 32);
    offset += 32;
    numIns = bytes.sublist(offset, offset + 4);
    offset += 4;
    final numInsNumber = numIns.buffer.asByteData().getUint32(0);
    for (int i = 0; i < numInsNumber; i++) {
      final anIn = EvmTransferableInput();
      offset = anIn.fromBuffer(bytes, offset: offset);
      importIns.add(anIn);
    }
    numOuts = bytes.sublist(offset, offset + 4);
    offset += 4;
    final numOutsNumber = numOuts.buffer.asByteData().getUint32(0);
    for (int i = 0; i < numOutsNumber; i++) {
      final anOut = EvmOutput();
      offset = anOut.fromBuffer(bytes, offset: offset);
      outs.add(anOut);
    }
    return offset;
  }

  @override
  Uint8List toBuffer() {
    numIns.buffer.asByteData().setUint32(0, importIns.length);
    numOuts.buffer.asByteData().setUint32(0, outs.length);
    final barr = [super.toBuffer(), sourceChain, numIns];
    importIns.sort(StandardParseableInput.comparator());
    for (int i = 0; i < importIns.length; i++) {
      barr.add(importIns[i].toBuffer());
    }
    barr.add(numOuts);
    for (int i = 0; i < outs.length; i++) {
      barr.add(outs[i].toBuffer());
    }
    return Uint8List.fromList(barr.expand((element) => element).toList());
  }

  @override
  EvmImportTx clone() {
    return create()..fromBuffer(toBuffer());
  }

  @override
  EvmImportTx create({Map<String, dynamic> args = const {}}) {
    return EvmImportTx.fromArgs(args);
  }

  @override
  List<Credential> sign(Uint8List msg, EZCKeyChain kc) {
    final signs = <Credential>[];
    for (int i = 0; i < importIns.length; i++) {
      final input = importIns[i];
      final credential =
          selectCredentialClass(input.getInput().getCredentialId());
      final signIdxs = input.getInput().getSigIdxs();
      for (int j = 0; j < signIdxs.length; j++) {
        final keyPair = kc.getKey(signIdxs[j].getSource());
        if (keyPair == null) continue;
        final signVal = keyPair.sign(msg);
        final signature = Signature()..fromBuffer(signVal);
        credential.addSignature(signature);
      }
      signs.add(credential);
    }
    return signs;
  }

  List<EvmTransferableInput> getImportInputs() => importIns;

  List<EvmOutput> getOuts() => outs;

  void _validateOuts(BigInt fee) {
    final seenAssetSends = <String, List<String>>{};
    for (int i = 0; i < outs.length; i++) {
      final output = outs[i];
      final address = output.getAddressString();
      final assetId = cb58Encode(output.getAssetId());
      if (seenAssetSends.keys.contains(address)) {
        final assetsSendToAddress = seenAssetSends[address]!;
        if (assetsSendToAddress.contains(assetId)) {
          throw Exception(
              "Error - EvmImportTx: duplicate (address, assetId) pair found in outputs: (0x$address, $assetId)");
        }
        assetsSendToAddress.add(assetId);
      } else {
        seenAssetSends[address] = [assetId];
      }
    }
    final selectedNetwork = getNetworkId();
    var feeDiff = BigInt.zero;
    final avaxAssetId = networks[selectedNetwork]!.x.avaxAssetId;
    for (int i = 0; i < importIns.length; i++) {
      final input = importIns[i];
      if (input.getInput() is StandardAmountInput &&
          avaxAssetId == cb58Encode(input.getAssetId())) {
        final i = input.getInput() as StandardAmountInput;
        feeDiff += i.getAmount();
      }
    }
    for (int i = 0; i < outs.length; i++) {
      final output = outs[i];
      if (avaxAssetId == cb58Encode(output.getAssetId())) {
        feeDiff -= output.getAmount();
      }
    }
    if (feeDiff < fee) {
      throw Exception(
          "Error - $fee nAVAX required for fee and only $feeDiff nAVAX provided");
    }
  }
}

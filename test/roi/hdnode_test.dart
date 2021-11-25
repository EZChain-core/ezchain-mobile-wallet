import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';
import 'dart:convert';

import 'package:wallet/roi/roi.dart';
import 'package:wallet/roi/utils/hdnode.dart';
import 'package:wallet/roi/utils/mnemonic.dart';

const xPriv =
    "xprv9s21ZrQH143K4RH1nRkHwuVz3qGREBLobwUoUBowLDucQXm4do8jvz12agvjHrAwjJXtq9BZ87WBPUPScDBnjKvBKVQ5xbS7GQwJKW7vXLD";
const childXPriv =
    "xprvA7X7udsZk3q9mNMcGnN8PKHv5eHm6JA3TRzW2HsWnrYHbccXh5YMnRLA83VCPKWQUFmKf9AfCXSmoFs7HJ8Yr1LK52wJDVk262vGFszM4nb";
const xPub =
    "xpub661MyMwAqRbcFSdAk5S6UECmA6MFQWiRBfPU5AsVcmrKY5HoFKPNYrKEq7isvaZVfNxhkrv5oXxFpQc6AVEcVW5NxeamKD6LyLUDMntbnq7";
const seed =
    "a0c42a9c3ac6abf2ba6a9946ae83af18f51bf1c9fa7dacc4c92513cc4dd015834341c775dcd4c0fac73547c5662d81a9e9361a0aac604a73a321bd9103bce8af";
const msg = "bb413645935a9bf1ecf0c3d30df2d573";
const m =
    "immune year obscure laptop wage diamond join glue ecology envelope box fade mixed cradle athlete absorb stick rival punch dinosaur skin blind benefit pretty";
const addrs = [
  "X-avax15qwuklmrfcmfw78yvka9pjsukjeevl4aveehq0",
  "X-avax13wqaxm6zgjq5qwzuyyxyl9yrz3edcgwgfht6gt",
  "X-avax1z3dn3vczxttts8dsdjfgtnkekf8nvqhhsj5stl",
  "X-avax1j6kze9n7r3e8wq6jta5mf6pd3fwnu0v9wygc8p",
  "X-avax1ngasfmvl8g63lzwznp0374myz7ajt4746g750m",
  "X-avax1pr7pzcggtrk6uap58sfsrlnhqhayly2gtlux9l",
  "X-avax1wwtn3gx7ke4ge2c29eg5sun36nyj55u4dle9gn",
  "X-avax13527pvlnxa4wrfgt0h8ya7nkjawqq29sv5s89x",
  "X-avax1gw6agtcsz969ugpqh2zx2lmjchg6npklvp43qq",
  "X-avax10agjetvj0a0vf6wtlh7s6ctr8ha8ch8km8z567"
];

final roi = ROI.create(host: "localhost", port: 9650, protocol: "http");
final keyChain = roi.avmApi.keyChain;

void main() {
  test("derive", () {
    final hdNode = HDNode(from: seed);
    const path = "m/9000'/2614666'/4849181'/4660'/2'/1/3";
    final child = hdNode.derive(path);
    expect(child.privateExtendedKey, childXPriv);
  });

  test("fromMasterSeedBuffer", () {
    final hdNode = HDNode(from: Uint8List.fromList(utf8.encode(seed)));
    expect(hdNode.privateExtendedKey, xPriv);
  });

  test("fromMasterSeedString", () {
    final hdNode = HDNode(from: seed);
    expect(hdNode.privateExtendedKey, xPriv);
  });

  test("fromXPriv", () {
    final hdNode = HDNode(from: xPriv);
    expect(hdNode.privateExtendedKey, xPriv);
  });

  test("fromXPub", () {
    final hdNode = HDNode(from: xPub);
    expect(hdNode.publicExtendedKey, xPub);
  });

  test("sign", () {
    final hdNode = HDNode(from: xPriv);
    final sig = hdNode.sign(Uint8List.fromList(utf8.encode(msg)));
    expect(sig.isNotEmpty, true);
  });

  test("verify", () {
    final hdNode = HDNode(from: xPriv);
    final sig = hdNode.sign(Uint8List.fromList(utf8.encode(msg)));
    final verify = hdNode.verify(Uint8List.fromList(utf8.encode(msg)), sig);
    expect(verify, verify);
  });

  test("wipePrivateData", () {
    final hdNode = HDNode(from: xPriv);
    hdNode.wipePrivateData();
    expect(hdNode.privateKey == null, true);
  });

  test("BIP44", () {
    final seed = Mnemonic.instance.mnemonicToSeed(m);
    final hdNode = HDNode(from: seed);
    final child = hdNode.derive("m/44'/9000'/0'/0/0");
    expect(child.privateKeyCB58 != null, true);
    final privateKeyCB58 = child.privateKeyCB58!;
    final keyPair = keyChain.importKey(privateKeyCB58);
    final firstXAddress = keyPair.getAddressString();
    expect(firstXAddress, addrs.first);
  });
}

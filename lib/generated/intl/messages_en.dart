// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) => "Welcome ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accessMnemonicKeyDes": MessageLookupByLibrary.simpleMessage(
            "Hit ‘SPACE’ after every successful word entry."),
        "accessMnemonicKeyTitle":
            MessageLookupByLibrary.simpleMessage("Mnemonic Key Phrase"),
        "accessMnemonicKeyWarning": MessageLookupByLibrary.simpleMessage(
            "Invalid mnemonic phrase. Make sure your mnemonic is all lowercase."),
        "accessPrivateKeyWarning":
            MessageLookupByLibrary.simpleMessage("Invalid Private Key"),
        "accessPrivateKeyYourPrivateKey":
            MessageLookupByLibrary.simpleMessage("Your Private Key"),
        "accessPrivateKeyYourPrivateKeyHint":
            MessageLookupByLibrary.simpleMessage("Type your private key"),
        "accessWalletOptionsDontHaveWallet":
            MessageLookupByLibrary.simpleMessage("Don’t have a wallet?"),
        "accessWalletOptionsKeystoreFile":
            MessageLookupByLibrary.simpleMessage("Keystore File"),
        "accessWalletOptionsMnemonic":
            MessageLookupByLibrary.simpleMessage("Mnemonic Key Phrase"),
        "accessWalletOptionsTitle": MessageLookupByLibrary.simpleMessage(
            "How do you want to access your wallet?"),
        "appName": MessageLookupByLibrary.simpleMessage("ROI Wallet"),
        "createWalletConfirmDes": MessageLookupByLibrary.simpleMessage(
            "Confirm your passphrase backup"),
        "createWalletDes": MessageLookupByLibrary.simpleMessage(
            "Store this key phrase in a secure location. Anyone with this key phrase can access your ROIChain wallet. there is no way to recover lost key phrase"),
        "createWalletKeptKey":
            MessageLookupByLibrary.simpleMessage("Yes, I kept them  safe"),
        "createWalletPassphraseToRestore":
            MessageLookupByLibrary.simpleMessage("Passphrase to restore"),
        "dashboardCross": MessageLookupByLibrary.simpleMessage("Cross"),
        "dashboardEarn": MessageLookupByLibrary.simpleMessage("Earn"),
        "dashboardSetting": MessageLookupByLibrary.simpleMessage("Setting"),
        "dashboardWallet": MessageLookupByLibrary.simpleMessage("Wallet"),
        "onBoardCreateWallet":
            MessageLookupByLibrary.simpleMessage("Create Wallet"),
        "pageHomeWelcome": m0,
        "pinCodeDes": MessageLookupByLibrary.simpleMessage(
            "Set up your PIN code to unlock the wallet, confirm transactions and other activities tha require your permission"),
        "pinCodeSetNewPin":
            MessageLookupByLibrary.simpleMessage(" or Set new PIN code"),
        "pinCodeTitle": MessageLookupByLibrary.simpleMessage("PIN code"),
        "pinCodeWrong": MessageLookupByLibrary.simpleMessage(
            "PIN Code doesn’t match! Try Again"),
        "sharedAccessWallet":
            MessageLookupByLibrary.simpleMessage("Access Wallet"),
        "sharedCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "sharedConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "sharedPrivateKey": MessageLookupByLibrary.simpleMessage("Private Key")
      };
}

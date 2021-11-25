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
        "accessPrivateKeyYourPrivateKey":
            MessageLookupByLibrary.simpleMessage("Your Private Key"),
        "accessPrivateKeyYourPrivateKeyHint":
            MessageLookupByLibrary.simpleMessage("Type your private key"),
        "accessWalletOptionsDontHaveWallet":
            MessageLookupByLibrary.simpleMessage("Don’t have a wallet?"),
        "accessWalletOptionsMnemonic":
            MessageLookupByLibrary.simpleMessage("Mnemonic Key Phrase"),
        "accessWalletOptionsTitle": MessageLookupByLibrary.simpleMessage(
            "How do you want to access your wallet?"),
        "appName": MessageLookupByLibrary.simpleMessage("ROI Wallet"),
        "onBoardCreateWallet":
            MessageLookupByLibrary.simpleMessage("Create Wallet"),
        "pageHomeWelcome": m0,
        "sharedAccessWallet":
            MessageLookupByLibrary.simpleMessage("Access Wallet"),
        "sharedCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "sharedPrivateKey": MessageLookupByLibrary.simpleMessage("Private Key")
      };
}

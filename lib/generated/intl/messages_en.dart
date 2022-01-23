// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) => "Welcome ${name}";

  static String m1(count) =>
      "${Intl.plural(count, one: '1 hour ago', other: '${count} hours ago')}";

  static String m2(count) =>
      "${Intl.plural(count, one: '1 minute ago', other: '${count} minutes ago')}";

  static String m3(balance) => "Balance: ${balance}";

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
        "appName": MessageLookupByLibrary.simpleMessage("EZC Wallet"),
        "createWalletConfirmDes": MessageLookupByLibrary.simpleMessage(
            "Confirm your passphrase backup"),
        "createWalletDes": MessageLookupByLibrary.simpleMessage(
            "Store this key phrase in a secure location. Anyone with this key phrase can access your EZChain wallet. there is no way to recover lost key phrase"),
        "createWalletKeptKey":
            MessageLookupByLibrary.simpleMessage("Yes, I kept them safe"),
        "createWalletPassphraseToRestore":
            MessageLookupByLibrary.simpleMessage("Passphrase to restore"),
        "crossFee":
            MessageLookupByLibrary.simpleMessage("Fee (export + import)"),
        "crossId": MessageLookupByLibrary.simpleMessage("ID:"),
        "crossStatus": MessageLookupByLibrary.simpleMessage("Status:"),
        "crossTransferCompleted":
            MessageLookupByLibrary.simpleMessage("Transfer Completed"),
        "crossTransferCompletedDes": MessageLookupByLibrary.simpleMessage(
            "You have successfully transferred\nbetween chains."),
        "crossTransferIncomplete":
            MessageLookupByLibrary.simpleMessage("Transfer Incomplete"),
        "crossTransferWrong":
            MessageLookupByLibrary.simpleMessage("Something went wrong"),
        "crossTransferring":
            MessageLookupByLibrary.simpleMessage("Transferring..."),
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
        "settingAboutEZC":
            MessageLookupByLibrary.simpleMessage("About EZChain"),
        "settingChangePin": MessageLookupByLibrary.simpleMessage("Change PIN"),
        "settingConfirmNewPin":
            MessageLookupByLibrary.simpleMessage("Please confirm new PIN"),
        "settingConfirmNewPinWrong":
            MessageLookupByLibrary.simpleMessage("PIN Code doesn’t match!"),
        "settingEnterNewPin":
            MessageLookupByLibrary.simpleMessage("Please enter new PIN"),
        "settingEnterOldPin":
            MessageLookupByLibrary.simpleMessage("Please enter old PIN"),
        "settingGeneral":
            MessageLookupByLibrary.simpleMessage("General Setting"),
        "settingGeneralDeactivateAccount":
            MessageLookupByLibrary.simpleMessage("Deactivate Account"),
        "settingGeneralRemoveWallet":
            MessageLookupByLibrary.simpleMessage("Remove Wallet"),
        "settingOldPinWrong":
            MessageLookupByLibrary.simpleMessage("PIN Code Wrong!"),
        "settingSecurityCPrivateKey":
            MessageLookupByLibrary.simpleMessage("C Chain Private Key"),
        "settingSecurityPrivateKeyNote": MessageLookupByLibrary.simpleMessage(
            "Never disclose this key. Anyone with your private keys can steal any assets held in your wallet."),
        "settingSecurityWalletAddress":
            MessageLookupByLibrary.simpleMessage("Wallet Address"),
        "settingTouchId": MessageLookupByLibrary.simpleMessage("Touch ID"),
        "settingWalletSecurity":
            MessageLookupByLibrary.simpleMessage("Wallet Security"),
        "sharedAccepted": MessageLookupByLibrary.simpleMessage("Accepted"),
        "sharedAccessWallet":
            MessageLookupByLibrary.simpleMessage("Access Wallet"),
        "sharedAmount": MessageLookupByLibrary.simpleMessage("Amount"),
        "sharedAvailable": MessageLookupByLibrary.simpleMessage("Available"),
        "sharedBalance": MessageLookupByLibrary.simpleMessage("Balance"),
        "sharedBlockchain": MessageLookupByLibrary.simpleMessage("Blockchain"),
        "sharedBurned": MessageLookupByLibrary.simpleMessage("Burned"),
        "sharedCChain": MessageLookupByLibrary.simpleMessage("C chain"),
        "sharedCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "sharedConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "sharedCopy": MessageLookupByLibrary.simpleMessage("Copy"),
        "sharedCurrency": MessageLookupByLibrary.simpleMessage("Currency"),
        "sharedDestination":
            MessageLookupByLibrary.simpleMessage("Destination"),
        "sharedEZChain": MessageLookupByLibrary.simpleMessage("EZChain"),
        "sharedError": MessageLookupByLibrary.simpleMessage("Error"),
        "sharedExport": MessageLookupByLibrary.simpleMessage("Export"),
        "sharedHourAgo": m1,
        "sharedImport": MessageLookupByLibrary.simpleMessage("Import"),
        "sharedInput": MessageLookupByLibrary.simpleMessage("Input"),
        "sharedInvalidAddress":
            MessageLookupByLibrary.simpleMessage("Invalid Address"),
        "sharedInvalidAmount":
            MessageLookupByLibrary.simpleMessage("Invalid Amount"),
        "sharedJustNow": MessageLookupByLibrary.simpleMessage("Just now"),
        "sharedLanguage": MessageLookupByLibrary.simpleMessage("Language"),
        "sharedLock": MessageLookupByLibrary.simpleMessage("Lock"),
        "sharedLockStakeable":
            MessageLookupByLibrary.simpleMessage("Lock Stakeable"),
        "sharedMemo": MessageLookupByLibrary.simpleMessage("Memo"),
        "sharedMinuteAgo": m2,
        "sharedOutput": MessageLookupByLibrary.simpleMessage("Output"),
        "sharedPChain": MessageLookupByLibrary.simpleMessage("P chain"),
        "sharedPassphrase": MessageLookupByLibrary.simpleMessage("Passphrase"),
        "sharedPasteAddress":
            MessageLookupByLibrary.simpleMessage("Paste Address"),
        "sharedPrivateKey": MessageLookupByLibrary.simpleMessage("Private Key"),
        "sharedProcessing": MessageLookupByLibrary.simpleMessage("Processing"),
        "sharedReceive": MessageLookupByLibrary.simpleMessage("Receive"),
        "sharedSend": MessageLookupByLibrary.simpleMessage("Send"),
        "sharedSendTo": MessageLookupByLibrary.simpleMessage("Send to"),
        "sharedSendTransaction":
            MessageLookupByLibrary.simpleMessage("Send Transaction"),
        "sharedSetAmount": MessageLookupByLibrary.simpleMessage("Set amount"),
        "sharedShare": MessageLookupByLibrary.simpleMessage("Share"),
        "sharedSource": MessageLookupByLibrary.simpleMessage("Source"),
        "sharedStartAgain": MessageLookupByLibrary.simpleMessage("Start Again"),
        "sharedToken": MessageLookupByLibrary.simpleMessage("Token"),
        "sharedTotal": MessageLookupByLibrary.simpleMessage("Total"),
        "sharedTransaction":
            MessageLookupByLibrary.simpleMessage("Transaction"),
        "sharedTransactionDetail":
            MessageLookupByLibrary.simpleMessage("Transaction Detail"),
        "sharedTransactionFee":
            MessageLookupByLibrary.simpleMessage("Transaction fee"),
        "sharedTransactionSent":
            MessageLookupByLibrary.simpleMessage("Transaction Sent"),
        "sharedTransfer": MessageLookupByLibrary.simpleMessage("Transfer"),
        "sharedValue": MessageLookupByLibrary.simpleMessage("Value"),
        "sharedXChain": MessageLookupByLibrary.simpleMessage("X chain"),
        "transactionsForm": MessageLookupByLibrary.simpleMessage("Form:"),
        "transactionsNoRecord":
            MessageLookupByLibrary.simpleMessage("No transaction record"),
        "transactionsSignature":
            MessageLookupByLibrary.simpleMessage("Signature:"),
        "transactionsTo": MessageLookupByLibrary.simpleMessage("To:"),
        "walletReceiveBitcoin":
            MessageLookupByLibrary.simpleMessage("Bitcoin(BTC)"),
        "walletReceiveSendOnly":
            MessageLookupByLibrary.simpleMessage("Send only "),
        "walletReceiveSetAmount":
            MessageLookupByLibrary.simpleMessage("Set Amount"),
        "walletReceiveToThis": MessageLookupByLibrary.simpleMessage(
            " to this address\nSending any other coins my result in permanent loss"),
        "walletSendBalance": m3,
        "walletSendCChainErrorAddress": MessageLookupByLibrary.simpleMessage(
            "Invalid C Chain address. Make sure your address begins with \"0x\" or \"C-0x\""),
        "walletSendGasGWEI": MessageLookupByLibrary.simpleMessage("GWEI"),
        "walletSendGasLimit": MessageLookupByLibrary.simpleMessage("Gas Limit"),
        "walletSendGasLimitNote": MessageLookupByLibrary.simpleMessage(
            "Gas Limit will be automatically calculated after you click Confirm."),
        "walletSendGasPrice": MessageLookupByLibrary.simpleMessage("Gas Price"),
        "walletSendGasPriceGWEI":
            MessageLookupByLibrary.simpleMessage("Gas Price (GWEI)"),
        "walletSendGasPriceNote": MessageLookupByLibrary.simpleMessage(
            "Adjusted automatically according to network load."),
        "walletSendMemo":
            MessageLookupByLibrary.simpleMessage("Memo (optional)")
      };
}

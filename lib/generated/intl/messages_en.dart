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

  static String m0(balance) => "Balance: ${balance}";

  static String m1(name) => "Welcome ${name}";

  static String m2(dayCount, hourCount, minuteCount) =>
      "${Intl.plural(dayCount, one: '1 day', other: '${dayCount} days')} ${Intl.plural(hourCount, one: '1 hour', other: '${hourCount} hours')} ${Intl.plural(minuteCount, one: '1 minute', other: '${minuteCount} minutes')}";

  static String m3(count) =>
      "${Intl.plural(count, one: '1 day', other: '${count} days')}";

  static String m4(count) =>
      "${Intl.plural(count, one: '1 hour ago', other: '${count} hours ago')}";

  static String m5(count) =>
      "${Intl.plural(count, one: '1 hour', other: '${count} hours')}";

  static String m6(count) =>
      "${Intl.plural(count, one: 'in a day', other: 'in ${count} days')}";

  static String m7(count) =>
      "${Intl.plural(count, one: 'in a year', other: 'in ${count} years')}";

  static String m8(count) =>
      "${Intl.plural(count, one: '1 minute ago', other: '${count} minutes ago')}";

  static String m9(count) =>
      "${Intl.plural(count, one: '1 minute', other: '${count} minutes')}";

  static String m10(balance) => "Balance: ${balance}";

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
        "dashboardNft": MessageLookupByLibrary.simpleMessage("My NFT"),
        "dashboardSetting": MessageLookupByLibrary.simpleMessage("Setting"),
        "dashboardWallet": MessageLookupByLibrary.simpleMessage("Wallet"),
        "earnCrossTransfer":
            MessageLookupByLibrary.simpleMessage("Cross Chain Transfer"),
        "earnCustomAddress":
            MessageLookupByLibrary.simpleMessage("Custom Address"),
        "earnDelegateAdd":
            MessageLookupByLibrary.simpleMessage("Add Delegator"),
        "earnDelegateBackToEarn":
            MessageLookupByLibrary.simpleMessage("Back to Earn"),
        "earnDelegateConfirmStartDate": MessageLookupByLibrary.simpleMessage(
            "Your validation will start at least 5 minutes after you submit this form."),
        "earnDelegateDescription": MessageLookupByLibrary.simpleMessage(
            "You do not own an EZChain node, but you want to stake using another node."),
        "earnDelegateInvalidAddress": MessageLookupByLibrary.simpleMessage(
            "Invalid address. Reward address must be a valid P chain address."),
        "earnDelegateInvalidEndDate":
            MessageLookupByLibrary.simpleMessage("Invalid end date"),
        "earnDelegateValidMess": MessageLookupByLibrary.simpleMessage(
            "You must have at least 1 EZC on the P chain to become a validator."),
        "earnDelegation": MessageLookupByLibrary.simpleMessage("Delegation"),
        "earnDelegationFee":
            MessageLookupByLibrary.simpleMessage("Delegation Fee"),
        "earnEstimateRewardsEmpty":
            MessageLookupByLibrary.simpleMessage("Empty Estimate Rewards"),
        "earnEstimateRewardsEmptyDes":
            MessageLookupByLibrary.simpleMessage("Rewards will appear here"),
        "earnEstimatedReward":
            MessageLookupByLibrary.simpleMessage("Estimated Reward"),
        "earnEstimatedRewards":
            MessageLookupByLibrary.simpleMessage("Estimated Rewards"),
        "earnRewardAddress":
            MessageLookupByLibrary.simpleMessage("Reward Address"),
        "earnStakeAmount": MessageLookupByLibrary.simpleMessage("Stake Amount"),
        "earnStakeBalance": m0,
        "earnStakingAmount":
            MessageLookupByLibrary.simpleMessage("Staking Amount"),
        "earnStakingDuration":
            MessageLookupByLibrary.simpleMessage("Staking Duration"),
        "earnStakingEndDate":
            MessageLookupByLibrary.simpleMessage("Staking End Date"),
        "earnStakingEndDateNote": MessageLookupByLibrary.simpleMessage(
            "Your EZC tokens will be locked until this date."),
        "earnTotalRewards":
            MessageLookupByLibrary.simpleMessage("Total Rewards"),
        "earnUseYourWallet":
            MessageLookupByLibrary.simpleMessage("Use your wallet"),
        "earnValidatorAddress":
            MessageLookupByLibrary.simpleMessage("Validator Address "),
        "earnValidatorStake":
            MessageLookupByLibrary.simpleMessage("Validator Stake"),
        "nftAboutCollectible":
            MessageLookupByLibrary.simpleMessage("About collectible"),
        "nftBackMyNFT": MessageLookupByLibrary.simpleMessage("Back to My NFT"),
        "nftChooseTitle": MessageLookupByLibrary.simpleMessage("Choose tittle"),
        "nftCreateFamily":
            MessageLookupByLibrary.simpleMessage("Create Family"),
        "nftFamilyName": MessageLookupByLibrary.simpleMessage("Family Name"),
        "nftHttps": MessageLookupByLibrary.simpleMessage("https://"),
        "nftImageUrl": MessageLookupByLibrary.simpleMessage("Image URL"),
        "nftJson": MessageLookupByLibrary.simpleMessage("JSON"),
        "nftJsonPayload": MessageLookupByLibrary.simpleMessage(
            "JSON Payload (MAX 1024 characters)"),
        "nftMint": MessageLookupByLibrary.simpleMessage("Mint"),
        "nftMintCollectible":
            MessageLookupByLibrary.simpleMessage("Mint Collectible"),
        "nftMintCollectibleDesc": MessageLookupByLibrary.simpleMessage(
            "You do not own an EZChain node, but you want to stake using another node."),
        "nftName": MessageLookupByLibrary.simpleMessage("Name"),
        "nftNameEmptyError":
            MessageLookupByLibrary.simpleMessage("You must provide a name."),
        "nftNewFamily": MessageLookupByLibrary.simpleMessage("New Family"),
        "nftNewFamilyDesc": MessageLookupByLibrary.simpleMessage(
            "Create a new set of collectibles with a name and symbol."),
        "nftNumberLengthError": MessageLookupByLibrary.simpleMessage(
            "Number of groups must be at least 1."),
        "nftNumberOfGroups":
            MessageLookupByLibrary.simpleMessage("Number of Groups"),
        "nftPayload": MessageLookupByLibrary.simpleMessage(
            "Payload (MAX 1024 characters)"),
        "nftStartDate": MessageLookupByLibrary.simpleMessage("Start Date"),
        "nftStartDateDesc": MessageLookupByLibrary.simpleMessage(
            "Sart at least 5 minutes after you submit this form."),
        "nftSymbol": MessageLookupByLibrary.simpleMessage("Symbol"),
        "nftSymbolEmptyError":
            MessageLookupByLibrary.simpleMessage("You must provide a symbol."),
        "nftSymbolLengthError": MessageLookupByLibrary.simpleMessage(
            "Symbol must be 4 characters max."),
        "nftTxId": MessageLookupByLibrary.simpleMessage("TxID"),
        "nftUrl": MessageLookupByLibrary.simpleMessage("URL"),
        "nftUtf8": MessageLookupByLibrary.simpleMessage("UTF-8"),
        "onBoardCreateWallet":
            MessageLookupByLibrary.simpleMessage("Create Wallet"),
        "pageHomeWelcome": m1,
        "pinCodeConfirm":
            MessageLookupByLibrary.simpleMessage("Confirm your PIN"),
        "pinCodeConfirmWrong":
            MessageLookupByLibrary.simpleMessage("PIN Code Wrong!"),
        "pinCodeDes": MessageLookupByLibrary.simpleMessage(
            "Set up your PIN code to unlock the wallet, confirm transactions and other activities tha require your permission"),
        "pinCodeSetNewPin":
            MessageLookupByLibrary.simpleMessage(" or Set new PIN code"),
        "pinCodeTitle": MessageLookupByLibrary.simpleMessage("PIN code"),
        "pinCodeWrong": MessageLookupByLibrary.simpleMessage(
            "PIN Code doesn’t match! Try Again"),
        "settingAboutEZC":
            MessageLookupByLibrary.simpleMessage("About EZChain"),
        "settingBiometricSystemsNotEnabled":
            MessageLookupByLibrary.simpleMessage(
                "Biometric systems is not enabled"),
        "settingChangePin": MessageLookupByLibrary.simpleMessage("Change PIN"),
        "settingConfirmNewPin":
            MessageLookupByLibrary.simpleMessage("Please confirm new PIN"),
        "settingConfirmNewPinWrong":
            MessageLookupByLibrary.simpleMessage("PIN Code doesn’t match!"),
        "settingEnterNewPin":
            MessageLookupByLibrary.simpleMessage("Please enter new PIN"),
        "settingEnterOldPin":
            MessageLookupByLibrary.simpleMessage("Please enter old PIN"),
        "settingEzcMainnet":
            MessageLookupByLibrary.simpleMessage("EZChain Mainnet"),
        "settingEzcTestnet":
            MessageLookupByLibrary.simpleMessage("EZChain Testnet"),
        "settingGeneral":
            MessageLookupByLibrary.simpleMessage("General Setting"),
        "settingGeneralDeactivateAccount":
            MessageLookupByLibrary.simpleMessage("Deactivate Account"),
        "settingGeneralRemoveWallet":
            MessageLookupByLibrary.simpleMessage("Remove Wallet"),
        "settingNetworkConnected":
            MessageLookupByLibrary.simpleMessage("Network connected"),
        "settingOldPinWrong":
            MessageLookupByLibrary.simpleMessage("PIN Code Wrong!"),
        "settingSecurityCPrivateKey":
            MessageLookupByLibrary.simpleMessage("C Chain Private Key"),
        "settingSecurityPrivateKeyNote": MessageLookupByLibrary.simpleMessage(
            "Never disclose this key. Anyone with your private keys can steal any assets held in your wallet."),
        "settingSecurityWalletAddress":
            MessageLookupByLibrary.simpleMessage("Wallet Address"),
        "settingSwitchNetworks":
            MessageLookupByLibrary.simpleMessage("Switch Networks"),
        "settingTouchId": MessageLookupByLibrary.simpleMessage("Touch ID"),
        "settingWalletSecurity":
            MessageLookupByLibrary.simpleMessage("Wallet Security"),
        "sharedAccepted": MessageLookupByLibrary.simpleMessage("Accepted"),
        "sharedAccessWallet":
            MessageLookupByLibrary.simpleMessage("Access Wallet"),
        "sharedAmount": MessageLookupByLibrary.simpleMessage("Amount"),
        "sharedAvailable": MessageLookupByLibrary.simpleMessage("Available"),
        "sharedBalance": MessageLookupByLibrary.simpleMessage("Balance"),
        "sharedBlock": MessageLookupByLibrary.simpleMessage("Block"),
        "sharedBlockchain": MessageLookupByLibrary.simpleMessage("Blockchain"),
        "sharedBurned": MessageLookupByLibrary.simpleMessage("Burned"),
        "sharedCChain": MessageLookupByLibrary.simpleMessage("C chain"),
        "sharedCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "sharedCommitted": MessageLookupByLibrary.simpleMessage("Committed"),
        "sharedCommonError": MessageLookupByLibrary.simpleMessage(
            "Something went wrong, please try again later!"),
        "sharedCompleteBiometrics": MessageLookupByLibrary.simpleMessage(
            "Please complete the biometrics to proceed."),
        "sharedConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "sharedConfirmed": MessageLookupByLibrary.simpleMessage("Confirmed"),
        "sharedCopied": MessageLookupByLibrary.simpleMessage("Copied"),
        "sharedCopy": MessageLookupByLibrary.simpleMessage("Copy"),
        "sharedCurrency": MessageLookupByLibrary.simpleMessage("Currency"),
        "sharedCustom": MessageLookupByLibrary.simpleMessage("Custom"),
        "sharedDateDuration": m2,
        "sharedDays": m3,
        "sharedDelegate": MessageLookupByLibrary.simpleMessage("Delegate"),
        "sharedDelegator": MessageLookupByLibrary.simpleMessage("Delegator"),
        "sharedDescription":
            MessageLookupByLibrary.simpleMessage("Description"),
        "sharedDestination":
            MessageLookupByLibrary.simpleMessage("Destination"),
        "sharedEZChain": MessageLookupByLibrary.simpleMessage("EZChain"),
        "sharedEndDate": MessageLookupByLibrary.simpleMessage("End date"),
        "sharedEndTime": MessageLookupByLibrary.simpleMessage("End Time"),
        "sharedError": MessageLookupByLibrary.simpleMessage("Error"),
        "sharedExport": MessageLookupByLibrary.simpleMessage("Export"),
        "sharedFail": MessageLookupByLibrary.simpleMessage("Fail"),
        "sharedFee": MessageLookupByLibrary.simpleMessage("Fee"),
        "sharedFrom": MessageLookupByLibrary.simpleMessage("Form"),
        "sharedGasLimit": MessageLookupByLibrary.simpleMessage("Gas Limit"),
        "sharedGasPrice": MessageLookupByLibrary.simpleMessage("Gas Price"),
        "sharedGeneric": MessageLookupByLibrary.simpleMessage("Generic"),
        "sharedHourAgo": m4,
        "sharedHours": m5,
        "sharedImport": MessageLookupByLibrary.simpleMessage("Import"),
        "sharedInDays": m6,
        "sharedInYears": m7,
        "sharedInput": MessageLookupByLibrary.simpleMessage("Input"),
        "sharedInvalidAddress":
            MessageLookupByLibrary.simpleMessage("Invalid Address"),
        "sharedInvalidAmount":
            MessageLookupByLibrary.simpleMessage("Invalid Amount"),
        "sharedInvalidUrlMess":
            MessageLookupByLibrary.simpleMessage("Not a valid image URL."),
        "sharedJustNow": MessageLookupByLibrary.simpleMessage("Just now"),
        "sharedLanguage": MessageLookupByLibrary.simpleMessage("Language"),
        "sharedLock": MessageLookupByLibrary.simpleMessage("Lock"),
        "sharedLockStakeable":
            MessageLookupByLibrary.simpleMessage("Lock Stakeable"),
        "sharedMemo": MessageLookupByLibrary.simpleMessage("Memo"),
        "sharedMinuteAgo": m8,
        "sharedMinutes": m9,
        "sharedNext": MessageLookupByLibrary.simpleMessage("Next"),
        "sharedNoResultFound":
            MessageLookupByLibrary.simpleMessage("No result found"),
        "sharedNoResultFoundDes": MessageLookupByLibrary.simpleMessage(
            "We can’t find any item matching your search"),
        "sharedNodeId": MessageLookupByLibrary.simpleMessage("Node ID"),
        "sharedNonce": MessageLookupByLibrary.simpleMessage("Nonce"),
        "sharedNotConfirm": MessageLookupByLibrary.simpleMessage("Not Confirm"),
        "sharedOutput": MessageLookupByLibrary.simpleMessage("Output"),
        "sharedPChain": MessageLookupByLibrary.simpleMessage("P chain"),
        "sharedPassphrase": MessageLookupByLibrary.simpleMessage("Passphrase"),
        "sharedPasteAddress":
            MessageLookupByLibrary.simpleMessage("Paste Address"),
        "sharedPotentialReward":
            MessageLookupByLibrary.simpleMessage("Potential Reward"),
        "sharedPrivateKey": MessageLookupByLibrary.simpleMessage("Private Key"),
        "sharedProcessing": MessageLookupByLibrary.simpleMessage("Processing"),
        "sharedQuantity": MessageLookupByLibrary.simpleMessage("Quantity"),
        "sharedReceive": MessageLookupByLibrary.simpleMessage("Receive"),
        "sharedReceived": MessageLookupByLibrary.simpleMessage("Received"),
        "sharedResult": MessageLookupByLibrary.simpleMessage("Result"),
        "sharedSelect": MessageLookupByLibrary.simpleMessage("Select"),
        "sharedSend": MessageLookupByLibrary.simpleMessage("Send"),
        "sharedSendTo": MessageLookupByLibrary.simpleMessage("Send to"),
        "sharedSendTransaction":
            MessageLookupByLibrary.simpleMessage("Send Transaction"),
        "sharedSent": MessageLookupByLibrary.simpleMessage("Sent"),
        "sharedSetAmount": MessageLookupByLibrary.simpleMessage("Set amount"),
        "sharedShare": MessageLookupByLibrary.simpleMessage("Share"),
        "sharedSource": MessageLookupByLibrary.simpleMessage("Source"),
        "sharedStake": MessageLookupByLibrary.simpleMessage("Stake"),
        "sharedStaking": MessageLookupByLibrary.simpleMessage("Staking"),
        "sharedStartAgain": MessageLookupByLibrary.simpleMessage("Start Again"),
        "sharedStartDate": MessageLookupByLibrary.simpleMessage("Start date"),
        "sharedStatus": MessageLookupByLibrary.simpleMessage("Status"),
        "sharedSubmit": MessageLookupByLibrary.simpleMessage("Submit"),
        "sharedSuccess": MessageLookupByLibrary.simpleMessage("Success"),
        "sharedTitle": MessageLookupByLibrary.simpleMessage("Title"),
        "sharedTo": MessageLookupByLibrary.simpleMessage("To"),
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
        "sharedTransactions":
            MessageLookupByLibrary.simpleMessage("Transactions"),
        "sharedTransfer": MessageLookupByLibrary.simpleMessage("Transfer"),
        "sharedTryAgain":
            MessageLookupByLibrary.simpleMessage("Please try again"),
        "sharedType": MessageLookupByLibrary.simpleMessage("Type"),
        "sharedValidate": MessageLookupByLibrary.simpleMessage("Validate"),
        "sharedValue": MessageLookupByLibrary.simpleMessage("Value"),
        "sharedWalletAddress":
            MessageLookupByLibrary.simpleMessage("Wallet address"),
        "sharedXChain": MessageLookupByLibrary.simpleMessage("X chain"),
        "transactionsForm": MessageLookupByLibrary.simpleMessage("Form:"),
        "transactionsGasUsedByTransaction":
            MessageLookupByLibrary.simpleMessage("Gas Used by Transaction"),
        "transactionsNoInputs": MessageLookupByLibrary.simpleMessage(
            "No input UTXOs found for this transaction."),
        "transactionsNoOutputs": MessageLookupByLibrary.simpleMessage(
            "No output UTXOs found for this transaction."),
        "transactionsNoRecord":
            MessageLookupByLibrary.simpleMessage("No transaction record"),
        "transactionsSignature":
            MessageLookupByLibrary.simpleMessage("Signature:"),
        "transactionsTo": MessageLookupByLibrary.simpleMessage("To:"),
        "walletAddToken": MessageLookupByLibrary.simpleMessage("Add Token"),
        "walletReceiveBitcoin":
            MessageLookupByLibrary.simpleMessage("Bitcoin (BTC)"),
        "walletReceiveSendOnly":
            MessageLookupByLibrary.simpleMessage("Send only "),
        "walletReceiveSetAmount":
            MessageLookupByLibrary.simpleMessage("Set Amount"),
        "walletReceiveToThis": MessageLookupByLibrary.simpleMessage(
            " to this address\nSending any other coins my result in permanent loss"),
        "walletSendBalance": m10,
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
            MessageLookupByLibrary.simpleMessage("Memo (optional)"),
        "walletTokenAddressExists": MessageLookupByLibrary.simpleMessage(
            "Contract address is already existed"),
        "walletTokenAddressInvalid":
            MessageLookupByLibrary.simpleMessage("Invalid contract address"),
        "walletTokenContractAddress":
            MessageLookupByLibrary.simpleMessage("Token Contract Address"),
        "walletTokenDecimal":
            MessageLookupByLibrary.simpleMessage("Token Decimal"),
        "walletTokenDecimalInvalid": MessageLookupByLibrary.simpleMessage(
            "You must provide a token decimal."),
        "walletTokenEmpty": MessageLookupByLibrary.simpleMessage("Empty Token"),
        "walletTokenEmptyDes":
            MessageLookupByLibrary.simpleMessage("Tokens will appear here "),
        "walletTokenName": MessageLookupByLibrary.simpleMessage("Token Name"),
        "walletTokenNameInvalid":
            MessageLookupByLibrary.simpleMessage("You must provide a name."),
        "walletTokenSymbol":
            MessageLookupByLibrary.simpleMessage("Token Symbol"),
        "walletTokenSymbolInvalid":
            MessageLookupByLibrary.simpleMessage("You must provide a symbol."),
        "walletTokenSymbolLengthInvalid": MessageLookupByLibrary.simpleMessage(
            "Symbol must be 4 characters max.")
      };
}

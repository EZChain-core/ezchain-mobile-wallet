// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class Strings {
  Strings();

  static Strings? _current;

  static Strings get current {
    assert(_current != null,
        'No instance of Strings was loaded. Try to initialize the Strings delegate before accessing Strings.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<Strings> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = Strings();
      Strings._current = instance;

      return instance;
    });
  }

  static Strings of(BuildContext context) {
    final instance = Strings.maybeOf(context);
    assert(instance != null,
        'No instance of Strings present in the widget tree. Did you add Strings.delegate in localizationsDelegates?');
    return instance!;
  }

  static Strings? maybeOf(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  /// `EZC Wallet`
  String get appName {
    return Intl.message(
      'EZC Wallet',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Welcome {name}`
  String pageHomeWelcome(Object name) {
    return Intl.message(
      'Welcome $name',
      name: 'pageHomeWelcome',
      desc: '',
      args: [name],
    );
  }

  /// `Private Key`
  String get sharedPrivateKey {
    return Intl.message(
      'Private Key',
      name: 'sharedPrivateKey',
      desc: '',
      args: [],
    );
  }

  /// `Access Wallet`
  String get sharedAccessWallet {
    return Intl.message(
      'Access Wallet',
      name: 'sharedAccessWallet',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get sharedCancel {
    return Intl.message(
      'Cancel',
      name: 'sharedCancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get sharedConfirm {
    return Intl.message(
      'Confirm',
      name: 'sharedConfirm',
      desc: '',
      args: [],
    );
  }

  /// `EZChain`
  String get sharedEZChain {
    return Intl.message(
      'EZChain',
      name: 'sharedEZChain',
      desc: '',
      args: [],
    );
  }

  /// `Token`
  String get sharedToken {
    return Intl.message(
      'Token',
      name: 'sharedToken',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get sharedBalance {
    return Intl.message(
      'Balance',
      name: 'sharedBalance',
      desc: '',
      args: [],
    );
  }

  /// `X chain`
  String get sharedXChain {
    return Intl.message(
      'X chain',
      name: 'sharedXChain',
      desc: '',
      args: [],
    );
  }

  /// `P chain`
  String get sharedPChain {
    return Intl.message(
      'P chain',
      name: 'sharedPChain',
      desc: '',
      args: [],
    );
  }

  /// `C chain`
  String get sharedCChain {
    return Intl.message(
      'C chain',
      name: 'sharedCChain',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get sharedSend {
    return Intl.message(
      'Send',
      name: 'sharedSend',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get sharedReceive {
    return Intl.message(
      'Receive',
      name: 'sharedReceive',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get sharedAvailable {
    return Intl.message(
      'Available',
      name: 'sharedAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Lock`
  String get sharedLock {
    return Intl.message(
      'Lock',
      name: 'sharedLock',
      desc: '',
      args: [],
    );
  }

  /// `Lock Stakeable`
  String get sharedLockStakeable {
    return Intl.message(
      'Lock Stakeable',
      name: 'sharedLockStakeable',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get sharedCopy {
    return Intl.message(
      'Copy',
      name: 'sharedCopy',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get sharedShare {
    return Intl.message(
      'Share',
      name: 'sharedShare',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get sharedTotal {
    return Intl.message(
      'Total',
      name: 'sharedTotal',
      desc: '',
      args: [],
    );
  }

  /// `Transaction fee`
  String get sharedTransactionFee {
    return Intl.message(
      'Transaction fee',
      name: 'sharedTransactionFee',
      desc: '',
      args: [],
    );
  }

  /// `Set amount`
  String get sharedSetAmount {
    return Intl.message(
      'Set amount',
      name: 'sharedSetAmount',
      desc: '',
      args: [],
    );
  }

  /// `Send to`
  String get sharedSendTo {
    return Intl.message(
      'Send to',
      name: 'sharedSendTo',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get sharedAmount {
    return Intl.message(
      'Amount',
      name: 'sharedAmount',
      desc: '',
      args: [],
    );
  }

  /// `Send Transaction`
  String get sharedSendTransaction {
    return Intl.message(
      'Send Transaction',
      name: 'sharedSendTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Sent`
  String get sharedTransactionSent {
    return Intl.message(
      'Transaction Sent',
      name: 'sharedTransactionSent',
      desc: '',
      args: [],
    );
  }

  /// `Start Again`
  String get sharedStartAgain {
    return Intl.message(
      'Start Again',
      name: 'sharedStartAgain',
      desc: '',
      args: [],
    );
  }

  /// `Memo`
  String get sharedMemo {
    return Intl.message(
      'Memo',
      name: 'sharedMemo',
      desc: '',
      args: [],
    );
  }

  /// `Paste Address`
  String get sharedPasteAddress {
    return Intl.message(
      'Paste Address',
      name: 'sharedPasteAddress',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get sharedLanguage {
    return Intl.message(
      'Language',
      name: 'sharedLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get sharedCurrency {
    return Intl.message(
      'Currency',
      name: 'sharedCurrency',
      desc: '',
      args: [],
    );
  }

  /// `Passphrase`
  String get sharedPassphrase {
    return Intl.message(
      'Passphrase',
      name: 'sharedPassphrase',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Address`
  String get sharedInvalidAddress {
    return Intl.message(
      'Invalid Address',
      name: 'sharedInvalidAddress',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Amount`
  String get sharedInvalidAmount {
    return Intl.message(
      'Invalid Amount',
      name: 'sharedInvalidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Source`
  String get sharedSource {
    return Intl.message(
      'Source',
      name: 'sharedSource',
      desc: '',
      args: [],
    );
  }

  /// `Destination`
  String get sharedDestination {
    return Intl.message(
      'Destination',
      name: 'sharedDestination',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get sharedTransfer {
    return Intl.message(
      'Transfer',
      name: 'sharedTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get sharedExport {
    return Intl.message(
      'Export',
      name: 'sharedExport',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get sharedImport {
    return Intl.message(
      'Import',
      name: 'sharedImport',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get sharedProcessing {
    return Intl.message(
      'Processing',
      name: 'sharedProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get sharedAccepted {
    return Intl.message(
      'Accepted',
      name: 'sharedAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get sharedError {
    return Intl.message(
      'Error',
      name: 'sharedError',
      desc: '',
      args: [],
    );
  }

  /// `Transaction`
  String get sharedTransaction {
    return Intl.message(
      'Transaction',
      name: 'sharedTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Just now`
  String get sharedJustNow {
    return Intl.message(
      'Just now',
      name: 'sharedJustNow',
      desc: '',
      args: [],
    );
  }

  /// `{count,plural, =1{1 minute ago} other{{count} minutes ago}}`
  String sharedMinuteAgo(num count) {
    return Intl.plural(
      count,
      one: '1 minute ago',
      other: '$count minutes ago',
      name: 'sharedMinuteAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count,plural, =1{1 hour ago} other{{count} hours ago}}`
  String sharedHourAgo(num count) {
    return Intl.plural(
      count,
      one: '1 hour ago',
      other: '$count hours ago',
      name: 'sharedHourAgo',
      desc: '',
      args: [count],
    );
  }

  /// `Create Wallet`
  String get onBoardCreateWallet {
    return Intl.message(
      'Create Wallet',
      name: 'onBoardCreateWallet',
      desc: '',
      args: [],
    );
  }

  /// `How do you want to access your wallet?`
  String get accessWalletOptionsTitle {
    return Intl.message(
      'How do you want to access your wallet?',
      name: 'accessWalletOptionsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic Key Phrase`
  String get accessWalletOptionsMnemonic {
    return Intl.message(
      'Mnemonic Key Phrase',
      name: 'accessWalletOptionsMnemonic',
      desc: '',
      args: [],
    );
  }

  /// `Keystore File`
  String get accessWalletOptionsKeystoreFile {
    return Intl.message(
      'Keystore File',
      name: 'accessWalletOptionsKeystoreFile',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have a wallet?`
  String get accessWalletOptionsDontHaveWallet {
    return Intl.message(
      'Don’t have a wallet?',
      name: 'accessWalletOptionsDontHaveWallet',
      desc: '',
      args: [],
    );
  }

  /// `Your Private Key`
  String get accessPrivateKeyYourPrivateKey {
    return Intl.message(
      'Your Private Key',
      name: 'accessPrivateKeyYourPrivateKey',
      desc: '',
      args: [],
    );
  }

  /// `Type your private key`
  String get accessPrivateKeyYourPrivateKeyHint {
    return Intl.message(
      'Type your private key',
      name: 'accessPrivateKeyYourPrivateKeyHint',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Private Key`
  String get accessPrivateKeyWarning {
    return Intl.message(
      'Invalid Private Key',
      name: 'accessPrivateKeyWarning',
      desc: '',
      args: [],
    );
  }

  /// `Mnemonic Key Phrase`
  String get accessMnemonicKeyTitle {
    return Intl.message(
      'Mnemonic Key Phrase',
      name: 'accessMnemonicKeyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Hit ‘SPACE’ after every successful word entry.`
  String get accessMnemonicKeyDes {
    return Intl.message(
      'Hit ‘SPACE’ after every successful word entry.',
      name: 'accessMnemonicKeyDes',
      desc: '',
      args: [],
    );
  }

  /// `Invalid mnemonic phrase. Make sure your mnemonic is all lowercase.`
  String get accessMnemonicKeyWarning {
    return Intl.message(
      'Invalid mnemonic phrase. Make sure your mnemonic is all lowercase.',
      name: 'accessMnemonicKeyWarning',
      desc: '',
      args: [],
    );
  }

  /// `Passphrase to restore`
  String get createWalletPassphraseToRestore {
    return Intl.message(
      'Passphrase to restore',
      name: 'createWalletPassphraseToRestore',
      desc: '',
      args: [],
    );
  }

  /// `Yes, I kept them safe`
  String get createWalletKeptKey {
    return Intl.message(
      'Yes, I kept them safe',
      name: 'createWalletKeptKey',
      desc: '',
      args: [],
    );
  }

  /// `Store this key phrase in a secure location. Anyone with this key phrase can access your EZChain wallet. there is no way to recover lost key phrase`
  String get createWalletDes {
    return Intl.message(
      'Store this key phrase in a secure location. Anyone with this key phrase can access your EZChain wallet. there is no way to recover lost key phrase',
      name: 'createWalletDes',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your passphrase backup`
  String get createWalletConfirmDes {
    return Intl.message(
      'Confirm your passphrase backup',
      name: 'createWalletConfirmDes',
      desc: '',
      args: [],
    );
  }

  /// `PIN code`
  String get pinCodeTitle {
    return Intl.message(
      'PIN code',
      name: 'pinCodeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Set up your PIN code to unlock the wallet, confirm transactions and other activities tha require your permission`
  String get pinCodeDes {
    return Intl.message(
      'Set up your PIN code to unlock the wallet, confirm transactions and other activities tha require your permission',
      name: 'pinCodeDes',
      desc: '',
      args: [],
    );
  }

  /// `PIN Code doesn’t match! Try Again`
  String get pinCodeWrong {
    return Intl.message(
      'PIN Code doesn’t match! Try Again',
      name: 'pinCodeWrong',
      desc: '',
      args: [],
    );
  }

  /// ` or Set new PIN code`
  String get pinCodeSetNewPin {
    return Intl.message(
      ' or Set new PIN code',
      name: 'pinCodeSetNewPin',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get dashboardWallet {
    return Intl.message(
      'Wallet',
      name: 'dashboardWallet',
      desc: '',
      args: [],
    );
  }

  /// `Cross`
  String get dashboardCross {
    return Intl.message(
      'Cross',
      name: 'dashboardCross',
      desc: '',
      args: [],
    );
  }

  /// `Earn`
  String get dashboardEarn {
    return Intl.message(
      'Earn',
      name: 'dashboardEarn',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get dashboardSetting {
    return Intl.message(
      'Setting',
      name: 'dashboardSetting',
      desc: '',
      args: [],
    );
  }

  /// `Change PIN`
  String get settingChangePin {
    return Intl.message(
      'Change PIN',
      name: 'settingChangePin',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Security`
  String get settingWalletSecurity {
    return Intl.message(
      'Wallet Security',
      name: 'settingWalletSecurity',
      desc: '',
      args: [],
    );
  }

  /// `General Setting`
  String get settingGeneral {
    return Intl.message(
      'General Setting',
      name: 'settingGeneral',
      desc: '',
      args: [],
    );
  }

  /// `About EZChain`
  String get settingAboutEZC {
    return Intl.message(
      'About EZChain',
      name: 'settingAboutEZC',
      desc: '',
      args: [],
    );
  }

  /// `Touch ID`
  String get settingTouchId {
    return Intl.message(
      'Touch ID',
      name: 'settingTouchId',
      desc: '',
      args: [],
    );
  }

  /// `Please enter old PIN`
  String get settingEnterOldPin {
    return Intl.message(
      'Please enter old PIN',
      name: 'settingEnterOldPin',
      desc: '',
      args: [],
    );
  }

  /// `Please enter new PIN`
  String get settingEnterNewPin {
    return Intl.message(
      'Please enter new PIN',
      name: 'settingEnterNewPin',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm new PIN`
  String get settingConfirmNewPin {
    return Intl.message(
      'Please confirm new PIN',
      name: 'settingConfirmNewPin',
      desc: '',
      args: [],
    );
  }

  /// `PIN Code Wrong!`
  String get settingOldPinWrong {
    return Intl.message(
      'PIN Code Wrong!',
      name: 'settingOldPinWrong',
      desc: '',
      args: [],
    );
  }

  /// `PIN Code doesn’t match!`
  String get settingConfirmNewPinWrong {
    return Intl.message(
      'PIN Code doesn’t match!',
      name: 'settingConfirmNewPinWrong',
      desc: '',
      args: [],
    );
  }

  /// `Deactivate Account`
  String get settingGeneralDeactivateAccount {
    return Intl.message(
      'Deactivate Account',
      name: 'settingGeneralDeactivateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Remove Wallet`
  String get settingGeneralRemoveWallet {
    return Intl.message(
      'Remove Wallet',
      name: 'settingGeneralRemoveWallet',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Address`
  String get settingSecurityWalletAddress {
    return Intl.message(
      'Wallet Address',
      name: 'settingSecurityWalletAddress',
      desc: '',
      args: [],
    );
  }

  /// `Never disclose this key. Anyone with your private keys can steal any assets held in your wallet.`
  String get settingSecurityPrivateKeyNote {
    return Intl.message(
      'Never disclose this key. Anyone with your private keys can steal any assets held in your wallet.',
      name: 'settingSecurityPrivateKeyNote',
      desc: '',
      args: [],
    );
  }

  /// `C Chain Private Key`
  String get settingSecurityCPrivateKey {
    return Intl.message(
      'C Chain Private Key',
      name: 'settingSecurityCPrivateKey',
      desc: '',
      args: [],
    );
  }

  /// `Send only `
  String get walletReceiveSendOnly {
    return Intl.message(
      'Send only ',
      name: 'walletReceiveSendOnly',
      desc: '',
      args: [],
    );
  }

  /// `Bitcoin(BTC)`
  String get walletReceiveBitcoin {
    return Intl.message(
      'Bitcoin(BTC)',
      name: 'walletReceiveBitcoin',
      desc: '',
      args: [],
    );
  }

  /// ` to this address\nSending any other coins my result in permanent loss`
  String get walletReceiveToThis {
    return Intl.message(
      ' to this address\nSending any other coins my result in permanent loss',
      name: 'walletReceiveToThis',
      desc: '',
      args: [],
    );
  }

  /// `Set Amount`
  String get walletReceiveSetAmount {
    return Intl.message(
      'Set Amount',
      name: 'walletReceiveSetAmount',
      desc: '',
      args: [],
    );
  }

  /// `Memo (optional)`
  String get walletSendMemo {
    return Intl.message(
      'Memo (optional)',
      name: 'walletSendMemo',
      desc: '',
      args: [],
    );
  }

  /// `Balance: {balance}`
  String walletSendBalance(Object balance) {
    return Intl.message(
      'Balance: $balance',
      name: 'walletSendBalance',
      desc: '',
      args: [balance],
    );
  }

  /// `Gas Price`
  String get walletSendGasPrice {
    return Intl.message(
      'Gas Price',
      name: 'walletSendGasPrice',
      desc: '',
      args: [],
    );
  }

  /// `Gas Price (GWEI)`
  String get walletSendGasPriceGWEI {
    return Intl.message(
      'Gas Price (GWEI)',
      name: 'walletSendGasPriceGWEI',
      desc: '',
      args: [],
    );
  }

  /// `GWEI`
  String get walletSendGasGWEI {
    return Intl.message(
      'GWEI',
      name: 'walletSendGasGWEI',
      desc: '',
      args: [],
    );
  }

  /// `Adjusted automatically according to network load.`
  String get walletSendGasPriceNote {
    return Intl.message(
      'Adjusted automatically according to network load.',
      name: 'walletSendGasPriceNote',
      desc: '',
      args: [],
    );
  }

  /// `Gas Limit`
  String get walletSendGasLimit {
    return Intl.message(
      'Gas Limit',
      name: 'walletSendGasLimit',
      desc: '',
      args: [],
    );
  }

  /// `Gas Limit will be automatically calculated after you click Confirm.`
  String get walletSendGasLimitNote {
    return Intl.message(
      'Gas Limit will be automatically calculated after you click Confirm.',
      name: 'walletSendGasLimitNote',
      desc: '',
      args: [],
    );
  }

  /// `Invalid C Chain address. Make sure your address begins with "0x" or "C-0x"`
  String get walletSendCChainErrorAddress {
    return Intl.message(
      'Invalid C Chain address. Make sure your address begins with "0x" or "C-0x"',
      name: 'walletSendCChainErrorAddress',
      desc: '',
      args: [],
    );
  }

  /// `Fee (export + import)`
  String get crossFee {
    return Intl.message(
      'Fee (export + import)',
      name: 'crossFee',
      desc: '',
      args: [],
    );
  }

  /// `ID:`
  String get crossId {
    return Intl.message(
      'ID:',
      name: 'crossId',
      desc: '',
      args: [],
    );
  }

  /// `Status:`
  String get crossStatus {
    return Intl.message(
      'Status:',
      name: 'crossStatus',
      desc: '',
      args: [],
    );
  }

  /// `Transferring...`
  String get crossTransferring {
    return Intl.message(
      'Transferring...',
      name: 'crossTransferring',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Completed`
  String get crossTransferCompleted {
    return Intl.message(
      'Transfer Completed',
      name: 'crossTransferCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Incomplete`
  String get crossTransferIncomplete {
    return Intl.message(
      'Transfer Incomplete',
      name: 'crossTransferIncomplete',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get crossTransferWrong {
    return Intl.message(
      'Something went wrong',
      name: 'crossTransferWrong',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully transferred\nbetween chains.`
  String get crossTransferCompletedDes {
    return Intl.message(
      'You have successfully transferred\nbetween chains.',
      name: 'crossTransferCompletedDes',
      desc: '',
      args: [],
    );
  }

  /// `No transaction record`
  String get transactionsNoRecord {
    return Intl.message(
      'No transaction record',
      name: 'transactionsNoRecord',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<Strings> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<Strings> load(Locale locale) => Strings.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

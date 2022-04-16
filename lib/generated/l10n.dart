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

  /// `Sent`
  String get sharedSent {
    return Intl.message(
      'Sent',
      name: 'sharedSent',
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

  /// `Received`
  String get sharedReceived {
    return Intl.message(
      'Received',
      name: 'sharedReceived',
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

  /// `Generic`
  String get sharedGeneric {
    return Intl.message(
      'Generic',
      name: 'sharedGeneric',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get sharedCustom {
    return Intl.message(
      'Custom',
      name: 'sharedCustom',
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

  /// `Transactions`
  String get sharedTransactions {
    return Intl.message(
      'Transactions',
      name: 'sharedTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Detail`
  String get sharedTransactionDetail {
    return Intl.message(
      'Transaction Detail',
      name: 'sharedTransactionDetail',
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

  /// `{dayCount,plural, =1{1 day} other{{dayCount} days}} {hourCount,plural, =1{1 hour} other{{hourCount} hours}} {minuteCount,plural, =1{1 minute} other{{minuteCount} minutes}}`
  String sharedDateDuration(num dayCount, num hourCount, num minuteCount) {
    return Intl.message(
      '${Intl.plural(dayCount, one: '1 day', other: '$dayCount days')} ${Intl.plural(hourCount, one: '1 hour', other: '$hourCount hours')} ${Intl.plural(minuteCount, one: '1 minute', other: '$minuteCount minutes')}',
      name: 'sharedDateDuration',
      desc: '',
      args: [dayCount, hourCount, minuteCount],
    );
  }

  /// `{count,plural, =1{1 day} other{{count} days}}`
  String sharedDays(num count) {
    return Intl.plural(
      count,
      one: '1 day',
      other: '$count days',
      name: 'sharedDays',
      desc: '',
      args: [count],
    );
  }

  /// `{count,plural, =1{1 hour} other{{count} hours}}`
  String sharedHours(num count) {
    return Intl.plural(
      count,
      one: '1 hour',
      other: '$count hours',
      name: 'sharedHours',
      desc: '',
      args: [count],
    );
  }

  /// `{count,plural, =1{1 minute} other{{count} minutes}}`
  String sharedMinutes(num count) {
    return Intl.plural(
      count,
      one: '1 minute',
      other: '$count minutes',
      name: 'sharedMinutes',
      desc: '',
      args: [count],
    );
  }

  /// `{count,plural, =1{in a year} other{in {count} years}}`
  String sharedInYears(num count) {
    return Intl.plural(
      count,
      one: 'in a year',
      other: 'in $count years',
      name: 'sharedInYears',
      desc: '',
      args: [count],
    );
  }

  /// `{count,plural, =1{in a day} other{in {count} days}}`
  String sharedInDays(num count) {
    return Intl.plural(
      count,
      one: 'in a day',
      other: 'in $count days',
      name: 'sharedInDays',
      desc: '',
      args: [count],
    );
  }

  /// `Value`
  String get sharedValue {
    return Intl.message(
      'Value',
      name: 'sharedValue',
      desc: '',
      args: [],
    );
  }

  /// `Burned`
  String get sharedBurned {
    return Intl.message(
      'Burned',
      name: 'sharedBurned',
      desc: '',
      args: [],
    );
  }

  /// `Blockchain`
  String get sharedBlockchain {
    return Intl.message(
      'Blockchain',
      name: 'sharedBlockchain',
      desc: '',
      args: [],
    );
  }

  /// `Input`
  String get sharedInput {
    return Intl.message(
      'Input',
      name: 'sharedInput',
      desc: '',
      args: [],
    );
  }

  /// `Output`
  String get sharedOutput {
    return Intl.message(
      'Output',
      name: 'sharedOutput',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get sharedSuccess {
    return Intl.message(
      'Success',
      name: 'sharedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Fail`
  String get sharedFail {
    return Intl.message(
      'Fail',
      name: 'sharedFail',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed`
  String get sharedConfirmed {
    return Intl.message(
      'Confirmed',
      name: 'sharedConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Not Confirm`
  String get sharedNotConfirm {
    return Intl.message(
      'Not Confirm',
      name: 'sharedNotConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Result`
  String get sharedResult {
    return Intl.message(
      'Result',
      name: 'sharedResult',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get sharedStatus {
    return Intl.message(
      'Status',
      name: 'sharedStatus',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get sharedBlock {
    return Intl.message(
      'Block',
      name: 'sharedBlock',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get sharedFrom {
    return Intl.message(
      'From',
      name: 'sharedFrom',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get sharedTo {
    return Intl.message(
      'To',
      name: 'sharedTo',
      desc: '',
      args: [],
    );
  }

  /// `Fee`
  String get sharedFee {
    return Intl.message(
      'Fee',
      name: 'sharedFee',
      desc: '',
      args: [],
    );
  }

  /// `Gas Price`
  String get sharedGasPrice {
    return Intl.message(
      'Gas Price',
      name: 'sharedGasPrice',
      desc: '',
      args: [],
    );
  }

  /// `Gas Limit`
  String get sharedGasLimit {
    return Intl.message(
      'Gas Limit',
      name: 'sharedGasLimit',
      desc: '',
      args: [],
    );
  }

  /// `Nonce`
  String get sharedNonce {
    return Intl.message(
      'Nonce',
      name: 'sharedNonce',
      desc: '',
      args: [],
    );
  }

  /// `Delegate`
  String get sharedDelegate {
    return Intl.message(
      'Delegate',
      name: 'sharedDelegate',
      desc: '',
      args: [],
    );
  }

  /// `Delegator`
  String get sharedDelegator {
    return Intl.message(
      'Delegator',
      name: 'sharedDelegator',
      desc: '',
      args: [],
    );
  }

  /// `Node ID`
  String get sharedNodeId {
    return Intl.message(
      'Node ID',
      name: 'sharedNodeId',
      desc: '',
      args: [],
    );
  }

  /// `End Time`
  String get sharedEndTime {
    return Intl.message(
      'End Time',
      name: 'sharedEndTime',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get sharedSelect {
    return Intl.message(
      'Select',
      name: 'sharedSelect',
      desc: '',
      args: [],
    );
  }

  /// `Validate`
  String get sharedValidate {
    return Intl.message(
      'Validate',
      name: 'sharedValidate',
      desc: '',
      args: [],
    );
  }

  /// `Start date`
  String get sharedStartDate {
    return Intl.message(
      'Start date',
      name: 'sharedStartDate',
      desc: '',
      args: [],
    );
  }

  /// `End date`
  String get sharedEndDate {
    return Intl.message(
      'End date',
      name: 'sharedEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get sharedSubmit {
    return Intl.message(
      'Submit',
      name: 'sharedSubmit',
      desc: '',
      args: [],
    );
  }

  /// `Committed`
  String get sharedCommitted {
    return Intl.message(
      'Committed',
      name: 'sharedCommitted',
      desc: '',
      args: [],
    );
  }

  /// `Wallet address`
  String get sharedWalletAddress {
    return Intl.message(
      'Wallet address',
      name: 'sharedWalletAddress',
      desc: '',
      args: [],
    );
  }

  /// `Stake`
  String get sharedStake {
    return Intl.message(
      'Stake',
      name: 'sharedStake',
      desc: '',
      args: [],
    );
  }

  /// `Potential Reward`
  String get sharedPotentialReward {
    return Intl.message(
      'Potential Reward',
      name: 'sharedPotentialReward',
      desc: '',
      args: [],
    );
  }

  /// `Copied`
  String get sharedCopied {
    return Intl.message(
      'Copied',
      name: 'sharedCopied',
      desc: '',
      args: [],
    );
  }

  /// `Staking`
  String get sharedStaking {
    return Intl.message(
      'Staking',
      name: 'sharedStaking',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong, please try again later!`
  String get sharedCommonError {
    return Intl.message(
      'Something went wrong, please try again later!',
      name: 'sharedCommonError',
      desc: '',
      args: [],
    );
  }

  /// `Please try again`
  String get sharedTryAgain {
    return Intl.message(
      'Please try again',
      name: 'sharedTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Please complete the biometrics to proceed.`
  String get sharedCompleteBiometrics {
    return Intl.message(
      'Please complete the biometrics to proceed.',
      name: 'sharedCompleteBiometrics',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get sharedNext {
    return Intl.message(
      'Next',
      name: 'sharedNext',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get sharedTitle {
    return Intl.message(
      'Title',
      name: 'sharedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get sharedType {
    return Intl.message(
      'Type',
      name: 'sharedType',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get sharedQuantity {
    return Intl.message(
      'Quantity',
      name: 'sharedQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid image URL.`
  String get sharedInvalidUrlMess {
    return Intl.message(
      'Not a valid image URL.',
      name: 'sharedInvalidUrlMess',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid JSON.`
  String get sharedInvalidJsonMess {
    return Intl.message(
      'Not a valid JSON.',
      name: 'sharedInvalidJsonMess',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get sharedDescription {
    return Intl.message(
      'Description',
      name: 'sharedDescription',
      desc: '',
      args: [],
    );
  }

  /// `No result found`
  String get sharedNoResultFound {
    return Intl.message(
      'No result found',
      name: 'sharedNoResultFound',
      desc: '',
      args: [],
    );
  }

  /// `We can’t find any item matching your search`
  String get sharedNoResultFoundDes {
    return Intl.message(
      'We can’t find any item matching your search',
      name: 'sharedNoResultFoundDes',
      desc: '',
      args: [],
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

  /// `Confirm your PIN`
  String get pinCodeConfirm {
    return Intl.message(
      'Confirm your PIN',
      name: 'pinCodeConfirm',
      desc: '',
      args: [],
    );
  }

  /// `PIN Code Wrong!`
  String get pinCodeConfirmWrong {
    return Intl.message(
      'PIN Code Wrong!',
      name: 'pinCodeConfirmWrong',
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

  /// `My NFT`
  String get dashboardNft {
    return Intl.message(
      'My NFT',
      name: 'dashboardNft',
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

  /// `Switch Networks`
  String get settingSwitchNetworks {
    return Intl.message(
      'Switch Networks',
      name: 'settingSwitchNetworks',
      desc: '',
      args: [],
    );
  }

  /// `EZChain Mainnet`
  String get settingEzcMainnet {
    return Intl.message(
      'EZChain Mainnet',
      name: 'settingEzcMainnet',
      desc: '',
      args: [],
    );
  }

  /// `EZChain Testnet`
  String get settingEzcTestnet {
    return Intl.message(
      'EZChain Testnet',
      name: 'settingEzcTestnet',
      desc: '',
      args: [],
    );
  }

  /// `Network connected`
  String get settingNetworkConnected {
    return Intl.message(
      'Network connected',
      name: 'settingNetworkConnected',
      desc: '',
      args: [],
    );
  }

  /// `Biometric systems is not enabled`
  String get settingBiometricSystemsNotEnabled {
    return Intl.message(
      'Biometric systems is not enabled',
      name: 'settingBiometricSystemsNotEnabled',
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

  /// `Bitcoin (BTC)`
  String get walletReceiveBitcoin {
    return Intl.message(
      'Bitcoin (BTC)',
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

  /// `Add Token`
  String get walletAddToken {
    return Intl.message(
      'Add Token',
      name: 'walletAddToken',
      desc: '',
      args: [],
    );
  }

  /// `Token Name`
  String get walletTokenName {
    return Intl.message(
      'Token Name',
      name: 'walletTokenName',
      desc: '',
      args: [],
    );
  }

  /// `Token Contract Address`
  String get walletTokenContractAddress {
    return Intl.message(
      'Token Contract Address',
      name: 'walletTokenContractAddress',
      desc: '',
      args: [],
    );
  }

  /// `Token Symbol`
  String get walletTokenSymbol {
    return Intl.message(
      'Token Symbol',
      name: 'walletTokenSymbol',
      desc: '',
      args: [],
    );
  }

  /// `Token Decimal`
  String get walletTokenDecimal {
    return Intl.message(
      'Token Decimal',
      name: 'walletTokenDecimal',
      desc: '',
      args: [],
    );
  }

  /// `Invalid contract address`
  String get walletTokenAddressInvalid {
    return Intl.message(
      'Invalid contract address',
      name: 'walletTokenAddressInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Contract address is already existed`
  String get walletTokenAddressExists {
    return Intl.message(
      'Contract address is already existed',
      name: 'walletTokenAddressExists',
      desc: '',
      args: [],
    );
  }

  /// `You must provide a name.`
  String get walletTokenNameInvalid {
    return Intl.message(
      'You must provide a name.',
      name: 'walletTokenNameInvalid',
      desc: '',
      args: [],
    );
  }

  /// `You must provide a symbol.`
  String get walletTokenSymbolInvalid {
    return Intl.message(
      'You must provide a symbol.',
      name: 'walletTokenSymbolInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Symbol must be 4 characters max.`
  String get walletTokenSymbolLengthInvalid {
    return Intl.message(
      'Symbol must be 4 characters max.',
      name: 'walletTokenSymbolLengthInvalid',
      desc: '',
      args: [],
    );
  }

  /// `You must provide a token decimal.`
  String get walletTokenDecimalInvalid {
    return Intl.message(
      'You must provide a token decimal.',
      name: 'walletTokenDecimalInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Empty Token`
  String get walletTokenEmpty {
    return Intl.message(
      'Empty Token',
      name: 'walletTokenEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Tokens will appear here `
  String get walletTokenEmptyDes {
    return Intl.message(
      'Tokens will appear here ',
      name: 'walletTokenEmptyDes',
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

  /// `Form:`
  String get transactionsForm {
    return Intl.message(
      'Form:',
      name: 'transactionsForm',
      desc: '',
      args: [],
    );
  }

  /// `Signature:`
  String get transactionsSignature {
    return Intl.message(
      'Signature:',
      name: 'transactionsSignature',
      desc: '',
      args: [],
    );
  }

  /// `To:`
  String get transactionsTo {
    return Intl.message(
      'To:',
      name: 'transactionsTo',
      desc: '',
      args: [],
    );
  }

  /// `No input UTXOs found for this transaction.`
  String get transactionsNoInputs {
    return Intl.message(
      'No input UTXOs found for this transaction.',
      name: 'transactionsNoInputs',
      desc: '',
      args: [],
    );
  }

  /// `No output UTXOs found for this transaction.`
  String get transactionsNoOutputs {
    return Intl.message(
      'No output UTXOs found for this transaction.',
      name: 'transactionsNoOutputs',
      desc: '',
      args: [],
    );
  }

  /// `Gas Used by Transaction`
  String get transactionsGasUsedByTransaction {
    return Intl.message(
      'Gas Used by Transaction',
      name: 'transactionsGasUsedByTransaction',
      desc: '',
      args: [],
    );
  }

  /// `You do not own an EZChain node, but you want to stake using another node.`
  String get earnDelegateDescription {
    return Intl.message(
      'You do not own an EZChain node, but you want to stake using another node.',
      name: 'earnDelegateDescription',
      desc: '',
      args: [],
    );
  }

  /// `You must have at least 25 EZC on the P chain to become a delegator.`
  String get earnDelegateValidMess {
    return Intl.message(
      'You must have at least 25 EZC on the P chain to become a delegator.',
      name: 'earnDelegateValidMess',
      desc: '',
      args: [],
    );
  }

  /// `Add Delegator`
  String get earnDelegateAdd {
    return Intl.message(
      'Add Delegator',
      name: 'earnDelegateAdd',
      desc: '',
      args: [],
    );
  }

  /// `Back to Earn`
  String get earnDelegateBackToEarn {
    return Intl.message(
      'Back to Earn',
      name: 'earnDelegateBackToEarn',
      desc: '',
      args: [],
    );
  }

  /// `Invalid end date`
  String get earnDelegateInvalidEndDate {
    return Intl.message(
      'Invalid end date',
      name: 'earnDelegateInvalidEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Your validation will start at least 5 minutes after you submit this form.`
  String get earnDelegateConfirmStartDate {
    return Intl.message(
      'Your validation will start at least 5 minutes after you submit this form.',
      name: 'earnDelegateConfirmStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Cross Chain Transfer`
  String get earnCrossTransfer {
    return Intl.message(
      'Cross Chain Transfer',
      name: 'earnCrossTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Rewards`
  String get earnEstimatedRewards {
    return Intl.message(
      'Estimated Rewards',
      name: 'earnEstimatedRewards',
      desc: '',
      args: [],
    );
  }

  /// `Validator Stake`
  String get earnValidatorStake {
    return Intl.message(
      'Validator Stake',
      name: 'earnValidatorStake',
      desc: '',
      args: [],
    );
  }

  /// `Staking End Date`
  String get earnStakingEndDate {
    return Intl.message(
      'Staking End Date',
      name: 'earnStakingEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Stake Amount`
  String get earnStakeAmount {
    return Intl.message(
      'Stake Amount',
      name: 'earnStakeAmount',
      desc: '',
      args: [],
    );
  }

  /// `Your EZC tokens will be locked until this date.`
  String get earnStakingEndDateNote {
    return Intl.message(
      'Your EZC tokens will be locked until this date.',
      name: 'earnStakingEndDateNote',
      desc: '',
      args: [],
    );
  }

  /// `Reward Address`
  String get earnRewardAddress {
    return Intl.message(
      'Reward Address',
      name: 'earnRewardAddress',
      desc: '',
      args: [],
    );
  }

  /// `Custom Address`
  String get earnCustomAddress {
    return Intl.message(
      'Custom Address',
      name: 'earnCustomAddress',
      desc: '',
      args: [],
    );
  }

  /// `Balance: {balance}`
  String earnStakeBalance(Object balance) {
    return Intl.message(
      'Balance: $balance',
      name: 'earnStakeBalance',
      desc: '',
      args: [balance],
    );
  }

  /// `Staking Amount`
  String get earnStakingAmount {
    return Intl.message(
      'Staking Amount',
      name: 'earnStakingAmount',
      desc: '',
      args: [],
    );
  }

  /// `Delegation Fee`
  String get earnDelegationFee {
    return Intl.message(
      'Delegation Fee',
      name: 'earnDelegationFee',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Reward`
  String get earnEstimatedReward {
    return Intl.message(
      'Estimated Reward',
      name: 'earnEstimatedReward',
      desc: '',
      args: [],
    );
  }

  /// `Staking Duration`
  String get earnStakingDuration {
    return Intl.message(
      'Staking Duration',
      name: 'earnStakingDuration',
      desc: '',
      args: [],
    );
  }

  /// `Use your wallet`
  String get earnUseYourWallet {
    return Intl.message(
      'Use your wallet',
      name: 'earnUseYourWallet',
      desc: '',
      args: [],
    );
  }

  /// `Invalid address. Reward address must be a valid P chain address.`
  String get earnDelegateInvalidAddress {
    return Intl.message(
      'Invalid address. Reward address must be a valid P chain address.',
      name: 'earnDelegateInvalidAddress',
      desc: '',
      args: [],
    );
  }

  /// `Total Rewards`
  String get earnTotalRewards {
    return Intl.message(
      'Total Rewards',
      name: 'earnTotalRewards',
      desc: '',
      args: [],
    );
  }

  /// `Delegation`
  String get earnDelegation {
    return Intl.message(
      'Delegation',
      name: 'earnDelegation',
      desc: '',
      args: [],
    );
  }

  /// `Validator Address `
  String get earnValidatorAddress {
    return Intl.message(
      'Validator Address ',
      name: 'earnValidatorAddress',
      desc: '',
      args: [],
    );
  }

  /// `Empty Estimate Rewards`
  String get earnEstimateRewardsEmpty {
    return Intl.message(
      'Empty Estimate Rewards',
      name: 'earnEstimateRewardsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Rewards will appear here`
  String get earnEstimateRewardsEmptyDes {
    return Intl.message(
      'Rewards will appear here',
      name: 'earnEstimateRewardsEmptyDes',
      desc: '',
      args: [],
    );
  }

  /// `Mint`
  String get nftMint {
    return Intl.message(
      'Mint',
      name: 'nftMint',
      desc: '',
      args: [],
    );
  }

  /// `New Family`
  String get nftNewFamily {
    return Intl.message(
      'New Family',
      name: 'nftNewFamily',
      desc: '',
      args: [],
    );
  }

  /// `Create a new set of collectibles with a name and symbol.`
  String get nftNewFamilyDesc {
    return Intl.message(
      'Create a new set of collectibles with a name and symbol.',
      name: 'nftNewFamilyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Mint Collectible`
  String get nftMintCollectible {
    return Intl.message(
      'Mint Collectible',
      name: 'nftMintCollectible',
      desc: '',
      args: [],
    );
  }

  /// `You do not own an EZChain node, but you want to stake using another node.`
  String get nftMintCollectibleDesc {
    return Intl.message(
      'You do not own an EZChain node, but you want to stake using another node.',
      name: 'nftMintCollectibleDesc',
      desc: '',
      args: [],
    );
  }

  /// `Create Family`
  String get nftCreateFamily {
    return Intl.message(
      'Create Family',
      name: 'nftCreateFamily',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get nftName {
    return Intl.message(
      'Name',
      name: 'nftName',
      desc: '',
      args: [],
    );
  }

  /// `Symbol`
  String get nftSymbol {
    return Intl.message(
      'Symbol',
      name: 'nftSymbol',
      desc: '',
      args: [],
    );
  }

  /// `About collectible`
  String get nftAboutCollectible {
    return Intl.message(
      'About collectible',
      name: 'nftAboutCollectible',
      desc: '',
      args: [],
    );
  }

  /// `Collectibles`
  String get nftCollectibles {
    return Intl.message(
      'Collectibles',
      name: 'nftCollectibles',
      desc: '',
      args: [],
    );
  }

  /// `Image URL`
  String get nftImageUrl {
    return Intl.message(
      'Image URL',
      name: 'nftImageUrl',
      desc: '',
      args: [],
    );
  }

  /// `Choose tittle`
  String get nftChooseTitle {
    return Intl.message(
      'Choose tittle',
      name: 'nftChooseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Number of Groups`
  String get nftNumberOfGroups {
    return Intl.message(
      'Number of Groups',
      name: 'nftNumberOfGroups',
      desc: '',
      args: [],
    );
  }

  /// `https://`
  String get nftHttps {
    return Intl.message(
      'https://',
      name: 'nftHttps',
      desc: '',
      args: [],
    );
  }

  /// `TxID`
  String get nftTxId {
    return Intl.message(
      'TxID',
      name: 'nftTxId',
      desc: '',
      args: [],
    );
  }

  /// `UTF-8`
  String get nftUtf8 {
    return Intl.message(
      'UTF-8',
      name: 'nftUtf8',
      desc: '',
      args: [],
    );
  }

  /// `URL`
  String get nftUrl {
    return Intl.message(
      'URL',
      name: 'nftUrl',
      desc: '',
      args: [],
    );
  }

  /// `{count,plural, =1{1 item} other{{count} items}}`
  String nftItems(num count) {
    return Intl.plural(
      count,
      one: '1 item',
      other: '$count items',
      name: 'nftItems',
      desc: '',
      args: [count],
    );
  }

  /// `JSON`
  String get nftJson {
    return Intl.message(
      'JSON',
      name: 'nftJson',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get nftStartDate {
    return Intl.message(
      'Start Date',
      name: 'nftStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Sart at least 5 minutes after you submit this form.`
  String get nftStartDateDesc {
    return Intl.message(
      'Sart at least 5 minutes after you submit this form.',
      name: 'nftStartDateDesc',
      desc: '',
      args: [],
    );
  }

  /// `Family Name`
  String get nftFamilyName {
    return Intl.message(
      'Family Name',
      name: 'nftFamilyName',
      desc: '',
      args: [],
    );
  }

  /// `Back to My NFT`
  String get nftBackMyNFT {
    return Intl.message(
      'Back to My NFT',
      name: 'nftBackMyNFT',
      desc: '',
      args: [],
    );
  }

  /// `Empty Collectibles`
  String get nftCollectiblesEmpty {
    return Intl.message(
      'Empty Collectibles',
      name: 'nftCollectiblesEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Collectibles will appear here`
  String get nftCollectiblesEmptyDesc {
    return Intl.message(
      'Collectibles will appear here',
      name: 'nftCollectiblesEmptyDesc',
      desc: '',
      args: [],
    );
  }

  /// `You must provide a name.`
  String get nftNameEmptyError {
    return Intl.message(
      'You must provide a name.',
      name: 'nftNameEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `You must provide a symbol.`
  String get nftSymbolEmptyError {
    return Intl.message(
      'You must provide a symbol.',
      name: 'nftSymbolEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Symbol must be 4 characters max.`
  String get nftSymbolLengthError {
    return Intl.message(
      'Symbol must be 4 characters max.',
      name: 'nftSymbolLengthError',
      desc: '',
      args: [],
    );
  }

  /// `Number of groups must be at least 1.`
  String get nftNumberLengthError {
    return Intl.message(
      'Number of groups must be at least 1.',
      name: 'nftNumberLengthError',
      desc: '',
      args: [],
    );
  }

  /// `Quantity must be at least 1.`
  String get nftQuantityValidateError {
    return Intl.message(
      'Quantity must be at least 1.',
      name: 'nftQuantityValidateError',
      desc: '',
      args: [],
    );
  }

  /// `Payload (MAX 1024 characters)`
  String get nftPayload {
    return Intl.message(
      'Payload (MAX 1024 characters)',
      name: 'nftPayload',
      desc: '',
      args: [],
    );
  }

  /// `JSON Payload (MAX 1024 characters)`
  String get nftJsonPayload {
    return Intl.message(
      'JSON Payload (MAX 1024 characters)',
      name: 'nftJsonPayload',
      desc: '',
      args: [],
    );
  }

  /// `Search Assets`
  String get nftSearchHint {
    return Intl.message(
      'Search Assets',
      name: 'nftSearchHint',
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

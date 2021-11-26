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

  /// `ROI Wallet`
  String get appName {
    return Intl.message(
      'ROI Wallet',
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

  /// `Yes, I kept them  safe`
  String get createWalletKeptKey {
    return Intl.message(
      'Yes, I kept them  safe',
      name: 'createWalletKeptKey',
      desc: '',
      args: [],
    );
  }

  /// `Store this key phrase in a secure location. Anyone with this key phrase can access your ROIChain wallet. there is no way to recover lost key phrase`
  String get createWalletDes {
    return Intl.message(
      'Store this key phrase in a secure location. Anyone with this key phrase can access your ROIChain wallet. there is no way to recover lost key phrase',
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

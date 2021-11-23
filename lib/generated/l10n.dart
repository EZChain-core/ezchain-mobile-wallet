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

  /// `Access Wallet`
  String get onBoardAccessWallet {
    return Intl.message(
      'Access Wallet',
      name: 'onBoardAccessWallet',
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

  /// `Private Key`
  String get accessWalletOptionsPrivateKey {
    return Intl.message(
      'Private Key',
      name: 'accessWalletOptionsPrivateKey',
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

  /// `Don’t have a wallet?`
  String get accessWalletOptionsDontHaveWallet {
    return Intl.message(
      'Don’t have a wallet?',
      name: 'accessWalletOptionsDontHaveWallet',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get accessWalletOptionsCancel {
    return Intl.message(
      'Cancel',
      name: 'accessWalletOptionsCancel',
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

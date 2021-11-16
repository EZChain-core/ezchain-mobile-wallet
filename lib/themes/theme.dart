import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallet/generated/l10n.dart';

class WalletThemeProvider with ChangeNotifier {
  Locale _locale = Locale(Intl.getCurrentLocale());

  Locale get locale => _locale;

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void setLocale(Locale locale) {
    _locale = locale;
    Strings.load(locale);
    notifyListeners();
  }

  void setLight() {
    _themeMode = ThemeMode.light;
    // Cần lưu xuống Shared Prefs
    notifyListeners();
  }

  void setDark() {
    _themeMode = ThemeMode.dark;
    // Cần lưu xuống Shared Prefs
    notifyListeners();
  }
}

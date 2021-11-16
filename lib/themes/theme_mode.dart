import 'package:flutter/material.dart';

extension ThemeModeExt on ThemeMode {
  bool get isLight => this == ThemeMode.light;

  bool get isDark => this == ThemeMode.dark;

  bool get isSystem => this == ThemeMode.system;
}

import 'package:flutter/material.dart';
import 'package:wallet/generated/colors.gen.dart';
import 'theme_mode.dart';

extension BaseColor on ThemeMode {
  Color get textPrimary =>
      isDark ? ColorName.textPrimaryDark : ColorName.textPrimaryLight;
}

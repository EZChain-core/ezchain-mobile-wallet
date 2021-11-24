import 'package:flutter/material.dart';
import 'package:wallet/generated/colors.gen.dart';

import 'theme_mode.dart';

extension BaseColor on ThemeMode {
  Color get textPrimary =>
      isDark ? ColorName.textPrimaryDark : ColorName.textPrimaryLight;

  Color get primary => isDark ? ColorName.primaryDark : ColorName.primaryLight;

  Color get primary110 =>
      isDark ? ColorName.primary110Dark : ColorName.primary110Light;

  Color get primary80 =>
      isDark ? ColorName.primary80Dark : ColorName.primary80Light;

  Color get primary60 =>
      isDark ? ColorName.primary60Dark : ColorName.primary60Light;

  Color get primary40 =>
      isDark ? ColorName.primary40Dark : ColorName.primary40Light;

  Color get primary20 =>
      isDark ? ColorName.primary20Dark : ColorName.primary20Light;

  Color get primary10 =>
      isDark ? ColorName.primary10Dark : ColorName.primary10Light;

  Color get text => isDark ? ColorName.textDark : ColorName.textLight;

  Color get text90 => isDark ? ColorName.text90Dark : ColorName.text90Light;

  Color get text80 => isDark ? ColorName.text80Dark : ColorName.text80Light;

  Color get text70 => isDark ? ColorName.text70Dark : ColorName.text70Light;

  Color get text60 => isDark ? ColorName.text60Dark : ColorName.text60Light;

  Color get text50 => isDark ? ColorName.text50Dark : ColorName.text50Light;

  Color get text40 => isDark ? ColorName.text40Dark : ColorName.text40Light;

  Color get text30 => isDark ? ColorName.text30Dark : ColorName.text30Light;

  Color get text20 => isDark ? ColorName.text20Dark : ColorName.text20Light;

  Color get text10 => isDark ? ColorName.text10Dark : ColorName.text10Light;

  Color get bg => isDark ? ColorName.bgDark : ColorName.bgLight;

  Color get border => isDark ? ColorName.borderDark : ColorName.borderLight;

  Color get borderActive =>
      isDark ? ColorName.borderActiveDark : ColorName.borderLight;
}

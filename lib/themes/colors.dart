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

  Color get secondary =>
      isDark ? ColorName.secondaryDark : ColorName.secondaryLight;

  Color get secondary80 =>
      isDark ? ColorName.secondary80Dark : ColorName.secondary80Light;

  Color get secondary60 =>
      isDark ? ColorName.secondary60Dark : ColorName.secondary60Light;

  Color get secondary40 =>
      isDark ? ColorName.secondary40Dark : ColorName.secondary40Light;

  Color get secondary20 =>
      isDark ? ColorName.secondary20Dark : ColorName.secondary20Light;

  Color get secondary10 =>
      isDark ? ColorName.secondary10Dark : ColorName.secondary10Light;

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

  Color get stateSuccess => isDark ? ColorName.stateSuccessDark : ColorName.stateSuccessLight;

  Color get stateDanger => isDark ? ColorName.stateDangerDark : ColorName.stateDangerLight;

  Color get bg => isDark ? ColorName.bgDark : ColorName.bgLight;

  Color get border => isDark ? ColorName.borderDark : ColorName.borderLight;

  Color get borderActive =>
      isDark ? ColorName.borderActiveDark : ColorName.borderActiveLight;

  Color get red => isDark ? ColorName.redDark : ColorName.redLight;

  Color get white => isDark ? ColorName.whiteDark : ColorName.whiteLight;

  Color get midnightBlue =>
      isDark ? ColorName.midnightBlueDark : ColorName.midnightBlueLight;

  Color get aquaGreen =>
      isDark ? ColorName.aquaGreenDark : ColorName.aquaGreenLight;

  Color get wispPink =>
      isDark ? ColorName.wispPinkDark : ColorName.wispPinkLight;

  Color get blue1 => isDark ? ColorName.blue1Dark : ColorName.blue1Light;

  Color get whiteSmoke => isDark ? ColorName.whiteSmokeDark : ColorName.whiteSmokeLight;
}

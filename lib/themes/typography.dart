import 'package:flutter/material.dart';
import 'package:wallet/generated/fonts.gen.dart';

class WalletTextStyle extends TextStyle {
  final Color color;

  final double height;

  final double fontSize;

  final String fontFamily;

  final FontWeight fontWeight;

  const WalletTextStyle(
      {required this.color,
      required this.height,
      required this.fontSize,
      required this.fontWeight,
      this.fontFamily = FontFamily.beVietnamPro})
      : super(fontFamily: fontFamily);
}

class WalletHeadlineMediumTextStyle extends WalletTextStyle {
  final Color color;

  const WalletHeadlineMediumTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 28,
            height: 36 / 28,
            fontWeight: FontWeight.w400);
}

class WalletHeadlineSmallTextStyle extends WalletTextStyle {
  final Color color;

  const WalletHeadlineSmallTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 24,
            height: 32 / 24,
            fontWeight: FontWeight.w400);
}

class WalletTitleLargeTextStyle extends WalletTextStyle {
  final Color color;

  const WalletTitleLargeTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 16,
            height: 24 / 16,
            fontWeight: FontWeight.w500);
}

class WalletTitleSmallTextStyle extends WalletTextStyle {
  final Color color;

  const WalletTitleSmallTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w500);
}

class WalletBodyLargeTextStyle extends WalletTextStyle {
  final Color color;

  const WalletBodyLargeTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 16,
            height: 24 / 16,
            fontWeight: FontWeight.w400);
}

class WalletBodyMediumTextStyle extends WalletTextStyle {
  final Color color;

  const WalletBodyMediumTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 14,
            height: 20 / 14,
            fontWeight: FontWeight.w400);
}

class WalletLabelMediumTextStyle extends WalletTextStyle {
  final Color color;

  const WalletLabelMediumTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w500);
}

class WalletLabelSmallTextStyle extends WalletTextStyle {
  final Color color;

  const WalletLabelSmallTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 10,
            height: 16 / 10,
            fontWeight: FontWeight.w500);
}

class WalletButtonTextStyle extends WalletTextStyle {
  final Color color;

  const WalletButtonTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 14,
            height: 24 / 14,
            fontWeight: FontWeight.w500);
}

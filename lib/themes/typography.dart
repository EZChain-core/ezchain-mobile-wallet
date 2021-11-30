import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/fonts.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';

class ROIMnemonicText extends StatelessWidget {
  final String text;

  const ROIMnemonicText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: provider.themeMode.secondary),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          text,
          style: ROIBodySmallTextStyle(color: provider.themeMode.secondary),
        ),
      ),
    );
  }
}

class ROITextStyle extends TextStyle {
  final Color color;

  final double height;

  final double fontSize;

  final String fontFamily;

  final FontWeight fontWeight;

  const ROITextStyle({
    required this.color,
    required this.height,
    required this.fontSize,
    required this.fontWeight,
    this.fontFamily = FontFamily.beVietnamPro,
  }) : super(fontFamily: fontFamily);
}

class ROIHeadlineMediumTextStyle extends ROITextStyle {
  final Color color;

  const ROIHeadlineMediumTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 28,
            height: 36 / 28,
            fontWeight: FontWeight.w400);
}

class ROIHeadlineSmallTextStyle extends ROITextStyle {
  final Color color;

  const ROIHeadlineSmallTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 24,
            height: 32 / 24,
            fontWeight: FontWeight.w400);
}

class ROITitleLargeTextStyle extends ROITextStyle {
  final Color color;

  const ROITitleLargeTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 16,
            height: 24 / 16,
            fontWeight: FontWeight.w500);
}

class ROITitleSmallTextStyle extends ROITextStyle {
  final Color color;

  const ROITitleSmallTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w500);
}

class ROIBodyLargeTextStyle extends ROITextStyle {
  final Color color;

  const ROIBodyLargeTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 16,
            height: 24 / 16,
            fontWeight: FontWeight.w400);
}

class ROIBodyMediumTextStyle extends ROITextStyle {
  final Color color;

  const ROIBodyMediumTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 14,
            height: 20 / 14,
            fontWeight: FontWeight.w400);
}

class ROIBodySmallTextStyle extends ROITextStyle {
  final Color color;

  const ROIBodySmallTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w400);
}

class ROILabelMediumTextStyle extends ROITextStyle {
  final Color color;

  const ROILabelMediumTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w500);
}

class ROILabelSmallTextStyle extends ROITextStyle {
  final Color color;

  const ROILabelSmallTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 10,
            height: 16 / 10,
            fontWeight: FontWeight.w500);
}

class ROIButtonTextStyle extends ROITextStyle {
  final Color color;

  const ROIButtonTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 14,
            height: 24 / 14,
            fontWeight: FontWeight.w500);
}

class ROISemiBoldSmallTextStyle extends ROITextStyle {
  final Color color;

  const ROISemiBoldSmallTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w600);
}

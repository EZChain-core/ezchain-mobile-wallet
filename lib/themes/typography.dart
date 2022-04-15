import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/fonts.gen.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';

class EZCMnemonicText extends StatelessWidget {
  final String text;

  const EZCMnemonicText({Key? key, required this.text}) : super(key: key);

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
          style: EZCBodySmallTextStyle(color: provider.themeMode.secondary),
        ),
      ),
    );
  }
}

class EZCChainLabelText extends StatelessWidget {
  final String text;

  const EZCChainLabelText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: provider.themeMode.primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          text,
          style: EZCTitleSmallTextStyle(color: provider.themeMode.text90),
        ),
      ),
    );
  }
}

class EZCTextStyle extends TextStyle {
  final Color color;

  final double fontSize;

  final String fontFamily;

  final FontWeight fontWeight;

  const EZCTextStyle({
    required this.color,
    required this.fontSize,
    required this.fontWeight,
    this.fontFamily = FontFamily.beVietnamPro,
  }) : super(fontFamily: fontFamily);
}

class EZCHeadlineMediumTextStyle extends EZCTextStyle {
  final Color color;

  const EZCHeadlineMediumTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.w400);
}

class EZCHeadlineSmallTextStyle extends EZCTextStyle {
  final Color color;

  const EZCHeadlineSmallTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w400);
}

class EZCTitleLargeTextStyle extends EZCTextStyle {
  final Color color;

  const EZCTitleLargeTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w500);
}

class EZCTitleMediumTextStyle extends EZCTextStyle {
  final Color color;

  const EZCTitleMediumTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500);
}

class EZCTitleSmallTextStyle extends EZCTextStyle {
  final Color color;

  const EZCTitleSmallTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500);
}

class EZCTitleCustomTextStyle extends EZCTextStyle {
  final Color color;
  final double size;

  const EZCTitleCustomTextStyle({required this.color, required this.size})
      : super(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w500);
}

class EZCBodyLargeTextStyle extends EZCTextStyle {
  final Color color;

  const EZCBodyLargeTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w400);
}

class EZCBodyMediumTextStyle extends EZCTextStyle {
  final Color color;

  const EZCBodyMediumTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w400);
}

class EZCBodySmallTextStyle extends EZCTextStyle {
  final Color color;

  const EZCBodySmallTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w400);
}

class EZCLabelMediumTextStyle extends EZCTextStyle {
  final Color color;

  const EZCLabelMediumTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500);
}

class EZCLabelSmallTextStyle extends EZCTextStyle {
  final Color color;

  const EZCLabelSmallTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w500);
}

class EZCButtonTextStyle extends EZCTextStyle {
  final Color color;

  const EZCButtonTextStyle({required this.color})
      : super(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500);
}

class EZCSemiBoldSmallTextStyle extends EZCTextStyle {
  final Color color;

  const EZCSemiBoldSmallTextStyle({required this.color})
      : super(color: color, fontSize: 12, fontWeight: FontWeight.w600);
}

class EZCSemiBoldLargeTextStyle extends EZCTextStyle {
  final Color color;

  const EZCSemiBoldLargeTextStyle({required this.color})
      : super(color: color, fontSize: 24, fontWeight: FontWeight.w600);
}

class EZCBoldMediumTextStyle extends EZCTextStyle {
  final Color color;

  const EZCBoldMediumTextStyle({required this.color})
      : super(color: color, fontSize: 16, fontWeight: FontWeight.w700);
}

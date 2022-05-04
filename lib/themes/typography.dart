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
  const EZCTextStyle({
    required Color color,
    required double fontSize,
    required FontWeight fontWeight,
    String fontFamily = FontFamily.beVietnamPro,
  }) : super(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: fontFamily);
}

class EZCHeadlineMediumTextStyle extends EZCTextStyle {
  const EZCHeadlineMediumTextStyle({required Color color})
      : super(color: color, fontSize: 28, fontWeight: FontWeight.w400);
}

class EZCHeadlineSmallTextStyle extends EZCTextStyle {
  const EZCHeadlineSmallTextStyle({required Color color})
      : super(color: color, fontSize: 24, fontWeight: FontWeight.w400);
}

class EZCTitleLargeTextStyle extends EZCTextStyle {
  const EZCTitleLargeTextStyle({required Color color})
      : super(color: color, fontSize: 16, fontWeight: FontWeight.w500);
}

class EZCTitleMediumTextStyle extends EZCTextStyle {
  const EZCTitleMediumTextStyle({required Color color})
      : super(color: color, fontSize: 14, fontWeight: FontWeight.w500);
}

class EZCTitleSmallTextStyle extends EZCTextStyle {
  const EZCTitleSmallTextStyle({required Color color})
      : super(color: color, fontSize: 12, fontWeight: FontWeight.w500);
}

class EZCTitleCustomTextStyle extends EZCTextStyle {
  const EZCTitleCustomTextStyle({required Color color, required double size})
      : super(color: color, fontSize: size, fontWeight: FontWeight.w500);
}

class EZCBodyLargeTextStyle extends EZCTextStyle {
  const EZCBodyLargeTextStyle({required Color color})
      : super(color: color, fontSize: 16, fontWeight: FontWeight.w400);
}

class EZCBodyMediumTextStyle extends EZCTextStyle {
  const EZCBodyMediumTextStyle({required Color color})
      : super(color: color, fontSize: 14, fontWeight: FontWeight.w400);
}

class EZCBodySmallTextStyle extends EZCTextStyle {
  const EZCBodySmallTextStyle({required Color color})
      : super(color: color, fontSize: 12, fontWeight: FontWeight.w400);
}

class EZCLabelMediumTextStyle extends EZCTextStyle {
  const EZCLabelMediumTextStyle({required Color color})
      : super(color: color, fontSize: 12, fontWeight: FontWeight.w500);
}

class EZCLabelSmallTextStyle extends EZCTextStyle {
  const EZCLabelSmallTextStyle({required Color color})
      : super(color: color, fontSize: 10, fontWeight: FontWeight.w500);
}

class EZCButtonTextStyle extends EZCTextStyle {
  const EZCButtonTextStyle({required Color color})
      : super(color: color, fontSize: 14, fontWeight: FontWeight.w500);
}

class EZCSemiBoldSmallTextStyle extends EZCTextStyle {
  const EZCSemiBoldSmallTextStyle({required Color color})
      : super(color: color, fontSize: 12, fontWeight: FontWeight.w600);
}

class EZCSemiBoldLargeTextStyle extends EZCTextStyle {
  const EZCSemiBoldLargeTextStyle({required Color color})
      : super(color: color, fontSize: 24, fontWeight: FontWeight.w600);
}

class EZCBoldMediumTextStyle extends EZCTextStyle {
  const EZCBoldMediumTextStyle({required Color color})
      : super(color: color, fontSize: 16, fontWeight: FontWeight.w700);
}

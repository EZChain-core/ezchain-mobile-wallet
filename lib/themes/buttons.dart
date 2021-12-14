import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

const roiButtonRadius = 8.0;
const roiButtonMediumHeight = 40.0;
const EdgeInsetsGeometry roiButtonMediumPadding =
    EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 8);

class ROIButton extends StatelessWidget {
  final double height;

  final String text;

  final TextStyle textStyle;

  final ButtonStyle buttonStyle;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  const ROIButton(
      {required this.height,
      required this.text,
      required this.textStyle,
      required this.buttonStyle,
      this.onPressed,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        height: height,
        child: TextButton(
          child: Text(text, style: textStyle),
          style: buttonStyle,
          onPressed: onPressed,
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}

class ROIMediumPrimaryButton extends StatelessWidget {
  final String text;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  const ROIMediumPrimaryButton(
      {required this.text, this.onPressed, this.onLongPress, this.padding, this.width});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
        builder: (context, provider, child) => SizedBox(
              height: roiButtonMediumHeight,
              width: width,
              child: TextButton(
                child: Text(text,
                    textAlign: TextAlign.center,
                    style:
                        ROIButtonTextStyle(color: provider.themeMode.text90)),
                style: ROIButtonStyle(
                    bgColor: provider.themeMode.primary,
                    buttonPadding: padding ?? roiButtonMediumPadding),
                onPressed: onPressed,
                onLongPress: onLongPress,
              ),
            ));
  }
}

class ROIMediumNoneButton extends StatelessWidget {
  final String text;

  final Widget? iconLeft;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  const ROIMediumNoneButton(
      {required this.text,
      this.iconLeft,
      this.onPressed,
      this.onLongPress,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
        builder: (context, provider, child) => SizedBox(
              height: roiButtonMediumHeight,
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconLeft != null) iconLeft!,
                    if (iconLeft != null) const SizedBox(width: 8),
                    Text(
                      text,
                      style:
                          ROIButtonTextStyle(color: provider.themeMode.primary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                style: ROIButtonStyle(
                    bgColor: Colors.transparent,
                    buttonPadding: padding ?? roiButtonMediumPadding),
                onPressed: onPressed,
                onLongPress: onLongPress,
              ),
            ));
  }
}

class ROISpecialNoneButton extends StatelessWidget {
  final String text;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  const ROISpecialNoneButton(
      {required this.text, this.onPressed, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
        builder: (context, provider, child) => SizedBox(
              height: roiButtonMediumHeight,
              child: TextButton(
                child: Text(text,
                    style: ROIBodyLargeTextStyle(
                        color: provider.themeMode.primary)),
                style: ROIButtonStyle(
                    bgColor: Colors.transparent,
                    buttonPadding: roiButtonMediumPadding),
                onPressed: onPressed,
                onLongPress: onLongPress,
              ),
            ));
  }
}

class ROIButtonStyle extends ButtonStyle {
  final Color bgColor;

  final EdgeInsetsGeometry buttonPadding;

  ROIButtonStyle({required this.bgColor, required this.buttonPadding})
      : super(
          enableFeedback: false,
          padding:
              ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(buttonPadding),
          backgroundColor: ButtonStyleButton.allOrNull<Color>(bgColor),
          shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(roiButtonRadius),
            ),
          ),
        );
}

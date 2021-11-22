import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

const wallet_button_radius = 8.0;
const wallet_button_medium_height = 40.0;
final EdgeInsetsGeometry walletButtonMediumPadding =
    EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 8);

class WalletButton extends StatelessWidget {
  final double height;

  final String text;

  final TextStyle textStyle;

  final ButtonStyle buttonStyle;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  const WalletButton(
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
            ));
  }
}

class WalletMediumPrimaryButton extends StatelessWidget {
  final String text;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  const WalletMediumPrimaryButton(
      {required this.text, this.onPressed, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
        builder: (context, provider, child) => SizedBox(
              height: wallet_button_medium_height,
              child: TextButton(
                child: Text(text,
                    style: WalletButtonTextStyle(
                        color: provider.themeMode.text90)),
                style: WalletButtonStyle(
                    bgColor: provider.themeMode.primary,
                    buttonPadding: walletButtonMediumPadding),
                onPressed: onPressed,
                onLongPress: onLongPress,
              ),
            ));
  }
}

class WalletMediumNoneButton extends StatelessWidget {
  final String text;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  const WalletMediumNoneButton(
      {required this.text, this.onPressed, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
        builder: (context, provider, child) => SizedBox(
              height: wallet_button_medium_height,
              child: TextButton(
                child: Text(text,
                    style: WalletButtonTextStyle(
                        color: provider.themeMode.primary)),
                style: WalletButtonStyle(
                    bgColor: Colors.transparent,
                    buttonPadding: walletButtonMediumPadding),
                onPressed: onPressed,
                onLongPress: onLongPress,
              ),
            ));
  }
}

class WalletButtonStyle extends ButtonStyle {
  final Color bgColor;

  final EdgeInsetsGeometry buttonPadding;

  WalletButtonStyle({required this.bgColor, required this.buttonPadding})
      : super(
            enableFeedback: false,
            padding:
                ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(buttonPadding),
            backgroundColor: ButtonStyleButton.allOrNull<Color>(bgColor),
            shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(wallet_button_radius))));
}

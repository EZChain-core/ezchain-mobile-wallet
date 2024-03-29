import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/common/connectivity/connectivity.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

const ezcButtonRadius = 8.0;
const ezcButtonMediumHeight = 40.0;
const EdgeInsetsGeometry ezcButtonMediumPadding =
    EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 8);

class EZCButton extends StatelessWidget {
  final double height;

  final String text;

  final TextStyle textStyle;

  final ButtonStyle buttonStyle;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  const EZCButton(
      {required this.height,
      required this.text,
      required this.textStyle,
      required this.buttonStyle,
      this.onPressed,
      this.onLongPress,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        height: height,
        child: TextButton(
          child: Text(text, style: textStyle),
          style: buttonStyle,
          onPressed: _onPressedInternal,
          onLongPress: _onLongPressedInternal,
        ),
      ),
    );
  }

  _onPressedInternal() async {
    if (await hasInternetConnection()) {
      onPressed?.call();
    } else {
      showInternetConnectionDisconnectedSnackBar();
    }
  }

  _onLongPressedInternal() async {
    if (await hasInternetConnection()) {
      onLongPress?.call();
    } else {
      showInternetConnectionDisconnectedSnackBar();
    }
  }
}

class EZCMediumPrimaryButton extends StatelessWidget {
  final String text;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final bool? isLoading;

  final bool? enabled;

  const EZCMediumPrimaryButton(
      {required this.text,
      this.onPressed,
      this.onLongPress,
      this.padding,
      this.width,
      this.isLoading,
      this.enabled,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDisable = enabled == false;
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        height: ezcButtonMediumHeight,
        width: width,
        child: TextButton(
          child: isLoading == true
              ? EZCLoading(
                  color: provider.themeMode.text90,
                  size: ezcButtonMediumHeight - 20,
                  strokeWidth: 2)
              : Text(text,
                  textAlign: TextAlign.center,
                  style: EZCButtonTextStyle(
                      color: isDisable
                          ? provider.themeMode.text40
                          : provider.themeMode.text90)),
          style: EZCButtonStyle(
              bgColor: isDisable
                  ? provider.themeMode.text10
                  : provider.themeMode.primary,
              buttonPadding: padding ?? ezcButtonMediumPadding),
          onPressed: isDisable ? null : _onPressedInternal,
          onLongPress: isDisable ? null : _onLongPressedInternal,
        ),
      ),
    );
  }

  _onPressedInternal() async {
    if (await hasInternetConnection()) {
      onPressed?.call();
    } else {
      showInternetConnectionDisconnectedSnackBar();
    }
  }

  _onLongPressedInternal() async {
    if (await hasInternetConnection()) {
      onLongPress?.call();
    } else {
      showInternetConnectionDisconnectedSnackBar();
    }
  }
}

class EZCMediumPrimaryOutlineButton extends StatelessWidget {
  final String text;

  final double? width;

  final double? height;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final bool? isLoading;

  final bool? enabled;

  final TextStyle? textStyle;

  const EZCMediumPrimaryOutlineButton(
      {required this.text,
      this.onPressed,
      this.onLongPress,
      this.padding,
      this.width,
      this.height,
      this.isLoading,
      this.enabled,
      Key? key,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDisable = enabled == false;
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        height: height ?? ezcButtonMediumHeight,
        width: width,
        child: OutlinedButton(
          child: isLoading == true
              ? EZCLoading(
                  color: provider.themeMode.text90,
                  size: ezcButtonMediumHeight - 20,
                  strokeWidth: 2)
              : Text(text,
                  textAlign: TextAlign.center,
                  style: textStyle ??
                      EZCButtonTextStyle(
                          color: isDisable
                              ? provider.themeMode.text40
                              : provider.themeMode.primary)),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: BorderSide(width: 1, color: provider.themeMode.primary),
          ),
          onPressed: isDisable ? null : _onPressedInternal,
          onLongPress: isDisable ? null : _onLongPressedInternal,
        ),
      ),
    );
  }

  _onPressedInternal() async {
    if (await hasInternetConnection()) {
      onPressed?.call();
    } else {
      showInternetConnectionDisconnectedSnackBar();
    }
  }

  _onLongPressedInternal() async {
    if (await hasInternetConnection()) {
      onLongPress?.call();
    } else {
      showInternetConnectionDisconnectedSnackBar();
    }
  }
}

class EZCMediumSuccessButton extends StatelessWidget {
  final String text;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final bool? isLoading;

  const EZCMediumSuccessButton(
      {required this.text,
      this.onPressed,
      this.onLongPress,
      this.padding,
      this.width,
      this.isLoading,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => SizedBox(
        height: ezcButtonMediumHeight,
        width: width,
        child: TextButton(
          child: isLoading == true
              ? EZCLoading(
                  color: provider.themeMode.white,
                  size: ezcButtonMediumHeight - 20,
                  strokeWidth: 2)
              : Text(text,
                  textAlign: TextAlign.center,
                  style: EZCButtonTextStyle(color: provider.themeMode.white)),
          style: EZCButtonStyle(
              bgColor: provider.themeMode.stateSuccess,
              buttonPadding: padding ?? ezcButtonMediumPadding),
          onPressed: isLoading == true ? null : onPressed,
          onLongPress: isLoading == true ? null : onLongPress,
        ),
      ),
    );
  }
}

class EZCMediumNoneButton extends StatelessWidget {
  final String text;

  final Color? textColor;

  final double? width;

  final Widget? iconLeft;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  const EZCMediumNoneButton(
      {required this.text,
      this.iconLeft,
      this.onPressed,
      this.onLongPress,
      this.padding,
      this.textColor,
      this.width,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
        builder: (context, provider, child) => SizedBox(
              height: ezcButtonMediumHeight,
              width: width,
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconLeft != null) iconLeft!,
                    if (iconLeft != null) const SizedBox(width: 8),
                    Text(
                      text,
                      style: EZCButtonTextStyle(
                          color: textColor ?? provider.themeMode.primary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                style: EZCButtonStyle(
                    bgColor: Colors.transparent,
                    buttonPadding: padding ?? ezcButtonMediumPadding),
                onPressed: _onPressedInternal,
                onLongPress: _onLongPressedInternal,
              ),
            ));
  }

  _onPressedInternal() async {
    if (await hasInternetConnection()) {
      onPressed?.call();
    } else {
      showInternetConnectionDisconnectedSnackBar();
    }
  }

  _onLongPressedInternal() async {
    if (await hasInternetConnection()) {
      onLongPress?.call();
    } else {
      showInternetConnectionDisconnectedSnackBar();
    }
  }
}

class EZCBodyLargeNoneButton extends StatelessWidget {
  final String text;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  const EZCBodyLargeNoneButton(
      {required this.text, this.onPressed, this.onLongPress, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
        builder: (context, provider, child) => SizedBox(
              height: ezcButtonMediumHeight,
              child: TextButton(
                child: Text(text,
                    style: EZCBodyLargeTextStyle(
                        color: provider.themeMode.primary)),
                style: EZCButtonStyle(
                    bgColor: Colors.transparent,
                    buttonPadding: ezcButtonMediumPadding),
                onPressed: _onPressedInternal,
                onLongPress: _onLongPressedInternal,
              ),
            ));
  }

  _onPressedInternal() async {
    if (await hasInternetConnection()) {
      onPressed?.call();
    } else {
      showInternetConnectionDisconnectedSnackBar();
    }
  }

  _onLongPressedInternal() async {
    if (await hasInternetConnection()) {
      onLongPress?.call();
    } else {
      showInternetConnectionDisconnectedSnackBar();
    }
  }
}

class EZCButtonStyle extends ButtonStyle {
  final Color bgColor;

  final EdgeInsetsGeometry buttonPadding;

  EZCButtonStyle({required this.bgColor, required this.buttonPadding})
      : super(
          enableFeedback: false,
          padding:
              ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(buttonPadding),
          backgroundColor: ButtonStyleButton.allOrNull<Color>(bgColor),
          shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ezcButtonRadius),
            ),
          ),
        );
}

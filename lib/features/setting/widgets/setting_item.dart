import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class SettingItem extends StatelessWidget {
  final String text;
  final Color? textColor;
  final String? rightText;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool? isSwitch;
  final bool? initSwitch;
  final Function(bool value)? onSwitch;

  const SettingItem(
      {Key? key,
      required this.text,
      this.icon,
      this.onPressed,
      this.isSwitch,
      this.onSwitch,
      this.rightText,
      this.textColor,
      this.initSwitch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasLeftIcon = icon != null;

    final hasRightText = rightText != null;

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: provider.themeMode.text10),
            ),
          ),
          child: Row(
            children: [
              if (hasLeftIcon) ...[icon!, const SizedBox(width: 8)],
              Text(
                text,
                style: EZCTitleLargeTextStyle(
                    color: textColor ?? provider.themeMode.text),
              ),
              const Spacer(),
              if (hasRightText)
                Text(
                  rightText!,
                  style:
                      EZCBodyLargeTextStyle(color: provider.themeMode.text70),
                ),
              if (isSwitch == true)
                FlutterSwitch(
                  width: 49,
                  height: 24,
                  value: initSwitch ?? false,
                  toggleSize: 20,
                  borderRadius: 12,
                  padding: 2,
                  activeColor: provider.themeMode.primary,
                  inactiveColor: provider.themeMode.text70,
                  onToggle: (val) {
                    onSwitch?.call(val);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

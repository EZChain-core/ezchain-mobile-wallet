import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class SettingItem extends StatefulWidget {
  final String text;
  final Color? textColor;
  final String? rightText;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool? isSwitch;
  final Function(bool value)? onSwitch;

  const SettingItem(
      {Key? key,
      required this.text,
      this.icon,
      this.onPressed,
      this.isSwitch,
      this.onSwitch,
      this.rightText,
      this.textColor})
      : super(key: key);

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  bool _switchValue = true;

  bool get hasLeftIcon => widget.icon != null;

  bool get hasRightText => widget.rightText != null;

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => GestureDetector(
        onTap: widget.onPressed,
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
              if (hasLeftIcon) ...[widget.icon!, const SizedBox(width: 8)],
              Text(
                widget.text,
                style: ROITitleLargeTextStyle(
                    color: widget.textColor ?? provider.themeMode.text),
              ),
              const Spacer(),
              if (hasRightText)
                Text(
                  widget.rightText!,
                  style:
                      ROIBodyLargeTextStyle(color: provider.themeMode.text70),
                ),
              if (widget.isSwitch == true)
                FlutterSwitch(
                  width: 49,
                  height: 24,
                  value: _switchValue,
                  toggleSize: 20,
                  borderRadius: 12,
                  padding: 2,
                  activeColor: provider.themeMode.primary,
                  inactiveColor: provider.themeMode.text70,
                  onToggle: (val) {
                    widget.onSwitch!(val);
                    setState(
                      () {
                        _switchValue = val;
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

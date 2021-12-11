import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:wallet/generated/assets.gen.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _SettingItem(
                text: Strings.current.settingChangePin,
                icon: Assets.icons.icChangePin.svg(),
                onPressed: () => {},
              ),
              _SettingItem(
                text: Strings.current.settingWalletSecurity,
                icon: Assets.icons.icSecurity.svg(),
                onPressed: () => {},
              ),
              _SettingItem(
                text: Strings.current.settingGeneral,
                icon: Assets.icons.icGeneralSetting.svg(),
                onPressed: () => {},
              ),
              _SettingItem(
                text: Strings.current.settingAboutRoi,
                icon: Assets.icons.icQuestion.svg(),
                onPressed: () => {},
              ),
              _SettingItem(
                text: Strings.current.settingTouchId,
                icon: Assets.icons.icTouchId.svg(),
                isSwitch: true,
                onSwitch: (value) => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingItem extends StatefulWidget {
  final String text;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool? isSwitch;
  final Function(bool value)? onSwitch;

  const _SettingItem(
      {Key? key,
      required this.text,
      required this.icon,
      this.onPressed,
      this.isSwitch,
      this.onSwitch})
      : super(key: key);

  @override
  State<_SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<_SettingItem> {
  bool _switchValue = true;

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
              widget.icon,
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: ROITitleLargeTextStyle(color: provider.themeMode.text),
              ),
              const Spacer(),
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

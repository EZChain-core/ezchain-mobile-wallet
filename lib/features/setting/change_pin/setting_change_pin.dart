import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/auth/pin/widgets/pin_code_input.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class SettingChangePinScreen extends StatelessWidget {
  const SettingChangePinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              ROIAppBar(
                title: Strings.current.settingChangePin,
                onPressed: () {
                  context.router.pop();
                },
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Strings.current.settingEnterOldPin,
                      style: ROIBodyLargeTextStyle(
                          color: provider.themeMode.text70),
                    ),
                    const SizedBox(height: 16),
                    PinCodeInput(
                      onSuccess: (String pin) {

                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum _SettingChangePinState {
  oldPin,
  oldPinError,
  newPin,
  confirmPin,
  confirmPin,

}
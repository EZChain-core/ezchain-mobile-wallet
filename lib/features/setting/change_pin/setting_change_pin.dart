// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:wallet/features/auth/pin/widgets/pin_code_input.dart';
import 'package:wallet/features/setting/change_pin/setting_change_pin_store.dart';
import 'package:wallet/generated/l10n.dart';
import 'package:wallet/themes/colors.dart';
import 'package:wallet/themes/theme.dart';
import 'package:wallet/themes/typography.dart';
import 'package:wallet/themes/widgets.dart';

class SettingChangePinScreen extends StatelessWidget {
  const SettingChangePinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingChangePinStore = SettingChangePinStore();

    return Consumer<WalletThemeProvider>(
      builder: (context, provider, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              EZCAppBar(
                title: Strings.current.settingChangePin,
                onPressed: () {
                  context.router.pop();
                },
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 1),
                    Observer(
                      builder: (_) => Text(
                        settingChangePinStore.state.errorMessage(),
                        style: EZCBodyMediumTextStyle(
                            color: provider.themeMode.stateDanger),
                      ),
                    ),
                    Observer(
                      builder: (_) => Text(
                        settingChangePinStore.state.title(),
                        style: EZCBodyLargeTextStyle(
                            color: provider.themeMode.text70),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: PinCodeInput(
                          onSuccess: (String pin) {
                            settingChangePinStore.state.maybeWhen(
                              oldPin: () =>
                                  settingChangePinStore.verifyOldPin(pin),
                              newPin: () =>
                                  settingChangePinStore.setNewPin(pin),
                              confirmNewPin: () {
                                settingChangePinStore.verifyNewPin(pin);
                              },
                              orElse: () {},
                            );
                          },
                          onChanged: () {
                            settingChangePinStore.state.maybeWhen(
                              oldPinError: () {
                                settingChangePinStore.transitionState(
                                    const SettingChangePinState.oldPin());
                              },
                              confirmNewPinError: () {
                                settingChangePinStore.transitionState(
                                    const SettingChangePinState
                                        .confirmNewPin());
                              },
                              orElse: () {},
                            );
                          },
                        ),
                      ),
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
